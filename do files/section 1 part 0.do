// Rae Adimer
// https://github.com/raevt/active-editor-seasonality
// Section 1, part 0: Preparing data

// Load data from https://stats.wikimedia.org/#/en.wikipedia.org/contributing/active-editors/normal%7Cline%7C2001-01-01~2023-06-22%7C(page_type)~content*non-content%7Cmonthly

// Rename and label main variable, drop unnecessary variables
rename totaltotal active_editors
label var active_editors "Active editors"
drop timerangestart timerangeend

// Using tsmktim, generate a new month variable
ssc install tsmktim // If you don't have tsmktim yet
tsmktim time, start(2001m1)
drop month
rename time month
label var month "Month"
tsset month
order month

// Save as a new .dta file