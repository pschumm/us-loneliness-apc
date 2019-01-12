// Changes to Kristen's HRS file to facilitate analysis

version 15.1
clear all
include config
set more off

use data/loneliness_dataset
drop _merge

egen su_id = group(hhid pn)
tostring su_id, replace

drop yr
ren yr_ yr

// Use previous weight for 2016
bys hhid pn (yr): replace wgtr = wgtr[_n-1] if yr==16 & mi(wgtr)
ass !mi(wgtr)

// Create weights constant within individual
gen double wgtr2 = wgtr
bys hhid pn (yr): replace wgtr2 = wgtr2[_n-1] if _n>1
corr wgtr wgtr2
corr wgtr wgtr2 if wgtr!=wgtr2

ren birthyr yob
ass inrange(yob,1920,1965)

compress
isid su_id yr, so
datasig confirm using signatures/hrs, strict
cap mkdir tmp
save `"`tmp'/hrs"', replace