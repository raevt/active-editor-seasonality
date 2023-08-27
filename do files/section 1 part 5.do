// Rae Adimer
// https://github.com/raevt/active-editor-seasonality
// Section 1, part 5: Seasonal dummy adjustments

// Load the 2014 to present adjusted dataset

// Prepare the dataset for this part

rename month time
generate m=month(dofm(month))
generate m1=(m==1)
generate m2=(m==2)
generate m3=(m==3)
generate m4=(m==4)
generate m5=(m==5)
generate m6=(m==6)
generate m7=(m==7)
generate m8=(m==8)
generate m9=(m==9)
generate m10=(m==10)
generate m11=(m==11)
generate m12=(m==12)
gen mean = 37477.41 // this is the mean of the 2014 to present data

// Generate seasonal dummies and residuals
regress active_editors b3.m
predict seasonal_adjustment
predict residuals, residuals

// Overlay adjustments on time series
tsline active_editors seasonal_adjustment

// Display and summarize residuals
tsline residuals
summarize residuals

// Autocorrelations for residuals
ac residuals

// Create and overlay adjusted time series on active_editors 
gen adjusted = mean + residuals
tsline active_editors adjusted

// Save as a new .dta file