// Rae Adimer
// https://github.com/raevt/active-editor-seasonality
// Section 1, part 3: Trend

// Open the .dta file created in part 0

// Linear regression on the plateau and visualization
regress active_editors month if month >= tm(2014m1)
predict y if month >= tm(2014m1)
label var y "Linear Regression"
tsline active_editors y if month >= tm(2014m1)

// Adjust time series by the linear regression
summarize y // specifically to find the mean, which is 37477.41
gen adjusted = (active_editors - y) + 37477.41
tsline active_editors adjusted if month >= tm(2014m1)

// Prepare data to create a new dataset for the adjusted data
drop if month < tm(2014m1)
drop active_editors y
rename adjusted active_editors
label var active_editors "Active editors"

// Save as a new .dta file

// 2008 to 2014
// Open the .dta file created in part 0

// Prepare data and run/graph linear regression
drop if month < tm(2008m1)
regress active_editors month if month < tm(2014m1)
predict y if month < tm(2014m1)
label var y "Linear Regression"
tsline active_editors y

// Adjust and display time series by the linear regression
gen adjusted = (active_editors - y) + 37477.41 if month < tm(2014m1)
replace adjusted = active_editors if month >= tm(2014m1)
tsline adjusted

// Create and display a combined 2008 to present adjusted variable
// Open the .dta file created in part 0
drop if month < tm(2008m1)
regress active_editors month if month < tm(2014m1)
predict y if month < tm(2014m1)
gen adjusted = (active_editors-y) + 37477.41 if month < tm(2014m1)
regress active_editors month if month >= tm(2014m1)
predict x if month >= tm(2014m1)
replace adjusted = (active_editors-x) + 37477.41 if month >= tm(2014m1)
tsline active_editors adjusted

// Save as a new .dta file


