/*Purpose

1 Merge datasets

2 Create complete-case dataset

3 Generate exposure variables

4 Save analytical dataset
*/

************************************************************************
* SETUP
************************************************************************

clear all
set more off
version 16.1

* Change this path to the location of the analytical datasets
global projdir "C:\Users\AditiRoy\OneDrive - Centre For Chronic Disease Control\ECD_Urban Pollution\pb_ECD_paper"

cd "$projdir"

/************************************************************************
Input files

eligibility.dta      Participant eligibility and identifiers
hhq.dta              Household socioeconomic characteristics
biological.dta       Blood lead and other clinical parameters
idela_T1_final.dta   Baseline IDELA scores
idela_T2_final.dta   Follow-up IDELA scores
eyt_wide.dta         Early Years Toolbox-Executive function assessments
rcpm_raw.dta         Raven's Coloured Progressive Matrices
************************************************************************/

*eligibility*
use eligibility.dta, clear

*socioeconmic covariates*
merge 1:1 record_id using "hhq.dta"

drop _merge

*biological data*
merge 1:1 record_id using "biological.dta"

drop _merge

*IDELA data (total of raw scores and IRT-derived scores)
merge 1:1 record_id using "idela_T1_final.dta"

keep if _merge==3
drop _merge

*merging follow-up IDELA data*
merge 1:1 record_id using "idela_T2_final.dta"
keep if _merge==3
drop _merge

*merging Early years toolbox data*
merge 1:1 record_id using "eyt_wide.dta" 
drop _merge

*merging RCPM data*
merge 1:1 record_id using "rcpm_raw.dta"
keep if _merge==3
drop _merge

count

******create a complte-case dataset for analysis*******
gen exclude = 0
replace exclude = 1 if idela_complete_t1 == 0
replace exclude = 1 if idela_complete_t2 == 0
replace exclude = 1 if bpb ==.
replace exclude =. if idela_complete_t1==. & idela_complete_t2==. & bpb==.
tab exclude

*prepare the exposure variable (logarithm )
gen log2bpb2 = log(bpb2)/log(2)
label var log2bpb2 "Blood lead (log2 of bpb2, per doubling)" ///This is the primary exposure variable


*age adjustment for RCPM raw scores 
reg rcpm_raw age_years_1dp if exclude==0
predict rcpm_ageadj, resid

*Save the analytical dataset
save analysis_dataset.dta, replace

