// Rae Adimer
// https://github.com/raevt/active-editor-seasonality
// Section 1, part 4: Autocorrelations

// Open the 2014 to present adjusted .dta file created in part 3

// Chart and tabulate autocorrelations for 2014 to present
ac active_editors
corrgram active_editors

// 2008 to 2014
// Open the 2008 to 2014 combined adjusted .dta file created in part 3
ac adjusted if month < tm(2014m1)