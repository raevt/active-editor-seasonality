// Rae Adimer
// https://github.com/raevt/active-editor-seasonality
// Section 1, part 2: Overview of the plateau

// Open the .dta file created in part 0

// Plateau (2014 - present) tsline
tsline active_editors if month >= tm(2014m1)

//Summary stats
summarize active_editors if month >= tm(2014m1)