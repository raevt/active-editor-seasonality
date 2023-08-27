# Understanding the data
This section outlines my process and thoughts in analyzing the active editors data.

## Part 0: Preparing data
The data used in this project is [publicly available on stats.wikimedia.org](https://stats.wikimedia.org/#/en.wikipedia.org/contributing/active-editors/normal%7Cline%7C2001-01-01~2023-06-22%7C(page_type)~content*non-content%7Cmonthly): monthly active editors (5+ edits) on the English Wikipedia.

After importing this data (as a .csv) into Stata, rename and lavel the variable of relevance (active editor count) and drop unnecessary variables:
```
rename totaltotal active_editors
label var active_editors "Active editors"
drop timerangestart timerangeend
```
Using tsmktim, generate a new month variable:
```
ssc install tsmktim // If you don't have tsmktim yet
tsmktim time, start(2001m1)
drop month
rename time month
label var month "Month"
tsset month
order month
```
Save the result as a .dta file.

## Part 1: Review of the entire dataset
After loading the .dta file created in part 0, graph the active_editors time series:
```
tsline active editors
```
![](/graphs/part%201%20entire%20time%20series%20tsline.svg)

This time series indicates three distinct periods:
1. The 'spike', up until roughly 2008
2. The 'decline', from 2008 to 2014
3. The 'plateau', from 2014 to present

For this project, I am mostly interested in the plateau, initially mentioned in the Wikimedia Australia post.

(After an overview of the plateau, I consider whether the 2008 to 2014 period can be trend-modified to be useful)

## Part 2: Overview of the plateau
```
tsline active_editors if month >= tm(2014m1)
```
![](/graphs/part%202%20plateau%20tsline.svg)
```
summarize active_editors if month >= tm(2014m1)
```
![](/graphs/part%202%20plateau%20summary%20stats.png)

Reviewing the time series line and summary statistics for the plateau, there is visibly a strong seasonal component, and possibly a slight positive trend. The trend needs to be considered before seasonality.

## Part 3: Trend

In considering whether there is a trend component in this series, run a linear regression on the series from 2014 to present:
```
regress active_editors month if month >= tm(2014m1)
```
![](/graphs/part%203%202014%20to%20present%20regression.png)

This result strongly indicates a trend component, with a t-statistic of 5.30 and p-value of 0. However, the average month-over-month change is relatively small, at 29 active editors.

Considering the clarity of these results and the r-squared value of 0.2, this is something that needs to be adjusted for prior to reviewing and estimating seasonality.

To better visualize these regression results:
```
predict y if month >= tm(2014m1)
label var y "Linear Regression"
tsline active_editors y if month >= tm(2014m1)
```
![](/graphs/part%203%20linear%20regression%20overlaid%202014%20to%20present.svg)

Over the 113 months included in this regression, with a slope of 28.89, the regression line increased from 35,859.26 to 39,095.56. This is a change of 3,236.3 active editors.

Though an estimated ~3,200 more monthly active editors in a nearly 10 year period is not exactly a large number, it is a statistically significant trend component that requires adjustment, prior to reviewing seasonality

To make and display this linear adjustment:.
```
summarize y // specifically to find the mean, which is 37477.41
gen adjusted = (active_editors - y) + 37477.41
tsline active_editors adjusted if month >= tm(2014m1)
```
![](/graphs/part%203%20linearly%20adjusted%20plateau%20overlaid.svg)

Prepare a new dataset with this adjusted data:
```
drop if month < tm(2014m1)
drop active_editors y
rename adjusted active_editors
label var active_editors "Active editors"
```
Save as a new .dta file.

### Trend for 2008 to 2014
Before continuing with an analysis of the seasonality of the adjusted 2014 to present data, it seems pertinent to explore the potential relevance of the 2008 to 2014 data.

Though the seasonal spikes from 2014 to present were the subject of Wikimedia Australia's post, it's possible that the negative trend apparent from 2008 to 2014 masks similar seasonality. This sub-part seeks to explore that possibility.

Opening the active editor seasonality file created in part 0, prepare the data and graph a linear regression on 2008 to 2014:
```
drop if month < tm(2008m1)
regress active_editors month if month < tm(2014m1)
predict y if month < tm(2014m1)
label var y "Linear Regression"
tsline active_editors y
```
![](/graphs/part%203%20linear%20regression%20overlaid%202008%20to%202014.svg)

To adjust this data to focus on seasonality, it seems best to use the mean of the 2014 to present data, which is 37477.41:
```
gen adjusted = (active_editors - y) + 37477.41 if month < tm(2014m1)
replace adjusted = active_editors if month >= tm(2014m1)
tsline adjusted
```
![](/graphs/part%203%202008%20to%202014%20adjusted.svg)

I've added a bar denoting the switch between the linearly adjusted 2008 to 2014 data, and the unmodified 2014 to present data. I've also circled in red every March in the adjusted period.

These spikes in March are quire pronounced, similar to the 2014 to present data, indicating that it may be useful to involve the adjusted data in my analyses. However, given the clearly-visible, likely-cyclical volatility apparent in that data, it may be disruptive if used in attempting to quantify the magnitude of seasonality in more recent trends.

Before moving forward, make a combined adjusted 2008 to present dataset from the .dta file created in part 0:
```
drop if month < tm(2008m1)
regress active_editors month if month < tm(2014m1)
predict y if month < tm(2014m1)
gen adjusted = (active_editors-y) + 37477.41 if month < tm(2014m1)
regress active_editors month if month >= tm(2014m1)
predict x if month >= tm(2014m1)
replace adjusted = (active_editors-x) + 37477.41 if month >= tm(2014m1)
tsline active_editors adjusted
```
![](/graphs/part%203%202008%20to%20present%20combined%20adjusted.svg)

Save this as a new .dta file.

## Part 4: Autocorrelations

### Autocorrelations for 2008 to 2014

## Part 5: Seasonal adjustments

## Part 6: Visualizing seasonality
