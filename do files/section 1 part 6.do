// Rae Adimer
// https://github.com/raevt/active-editor-seasonality
// Section 1, part 6: Visualizing seasonality

// Open the .dta file created in part 5

// "Typical" year graph
gen monthly_displacement = seasonal_adjustment - mean if time <= tm(2015m1)
tsline monthly_displacement if time <= tm(2015m1)

// Graph each month's displacement from its year's mean (note: this involves reshaping) for 2014 to present
gen year = floor(time/12)
drop time m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 mean seasonal_adjustment residuals adjusted 
rename m month
reshape wide active_editors, i(year) j(month)
egen mean_editors = rowmean(active_editors1 - active_editors12)
tsmktim time, start(2014)
tsset time
drop year
order time
rename active_editors1 January
label var January "January"
rename active_editors2 February
label var February "February"
rename active_editors3 March
label var March "March"
rename active_editors4 April
label var April "April"
rename active_editors5 May
label var May "May"
rename active_editors6 June
label var June "June"
rename active_editors7 July
label var July "July"
rename active_editors8 August
label var August "August"
rename active_editors9 September
label var September "September"
rename active_editors10 October
label var October "October"
rename active_editors11 November
label var November "November"
rename active_editors12 December
label var December "December"
gen January_adj = January - mean_editors
gen February_adj = February - mean_editors
gen March_adj = March - mean_editors
gen April_adj = April - mean_editors
gen May_adj = May - mean_editors
gen June_adj = June - mean_editors
gen July_adj = July - mean_editors
gen August_adj = August - mean_editors
gen September_adj = September - mean_editors
gen October_adj = October - mean_editors
gen November_adj = November - mean_editors
gen December_adj = December - mean_editors
tsline January_adj February_adj March_adj April_adj May_adj June_adj July_adj August_adj September_adj October_adj November_adj December_adj

// Save as a new .dta file

// 2008 to present
// Open the adjusted 2008 to present dataset created in part 3
drop active_editors y x
rename adjusted active_editors
generate m=month(dofm(month))
rename month time
rename m month
gen year = floor(time/12)
drop time
reshape wide active_editors, i(year) j(month)
egen mean_editors = rowmean(active_editors1 - active_editors12)
tsmktim time, start(2008)
tsset time
drop year
order time
rename active_editors1 January
label var January "January"
rename active_editors2 February
label var February "February"
rename active_editors3 March
label var March "March"
rename active_editors4 April
label var April "April"
rename active_editors5 May
label var May "May"
rename active_editors6 June
label var June "June"
rename active_editors7 July
label var July "July"
rename active_editors8 August
label var August "August"
rename active_editors9 September
label var September "September"
rename active_editors10 October
label var October "October"
rename active_editors11 November
label var November "November"
rename active_editors12 December
label var December "December"
gen January_adj = January - mean_editors
gen February_adj = February - mean_editors
gen March_adj = March - mean_editors
gen April_adj = April - mean_editors
gen May_adj = May - mean_editors
gen June_adj = June - mean_editors
gen July_adj = July - mean_editors
gen August_adj = August - mean_editors
gen September_adj = September - mean_editors
gen October_adj = October - mean_editors
gen November_adj = November - mean_editors
gen December_adj = December - mean_editors
tsline January_adj February_adj March_adj April_adj May_adj June_adj July_adj August_adj September_adj October_adj November_adj December_adj

// Save as a new .dta file


// Using months_analysis.py
// Prepare the data for python:
drop mean_editors January_adj February_adj March_adj April_adj May_adj June_adj July_adj August_adj September_adj October_adj November_adj December_adj

// After running the .py file, there are three .csvs: one with kendall tau distances, one table of months' placement each year, and one with the mean placement and standard deviation of each month. The latter two are best viewed manually in excel.

// Kendall tau distances
tsset year
drop in 16/16 // 2023's data is incomplete at time of writing, and thus returns an inaccurate distance
tsline distance

// Scatter plot with overlaid linear regression
graph twoway (scatter distance year) (lfit distance year)
regress distance year


