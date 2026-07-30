*------------------------------------------------------------------*
*Purpose
*Prepare Table 1
***************************************************
*------------------------------------------------------------------*

clear
use "analysis_dataset.dta"
********************************************************************************
*Prepare variables for Table 1
********************************************************************************
*Create a wealth index
********************************************************************************
/*Run PCA*/
pca hh_possessions___1 ///
	hh_possessions___2 ///
	hh_possessions___3 ///
	hh_possessions___4 ///
	hh_possessions___5 ///
	hh_possessions___6 ///
	hh_possessions___7 ///
	hh_possessions___8 ///
	hh_possessions___9 ///
	hh_possessions___10 ///
	hh_possessions___11 ///
	hh_possessions___12 ///
	hh_possessions___13 ///
	drkwater_src ///
	crowd_cat1 ///
	hh_ownership1_recode1 ///
	recode_hh_material_3 ///
	recode_cfuel_type ///
	recode_cstove_type

/*See the screeplot*/
screeplot

/*Predict the scores*/
predict PC1 PC2 PC3 PC4 PC5, score

/*PCA Wealth index*_*FINAL*/
predict score
xtile wealth_index=score,nq(3)
lab def wealth_index 1"Low" 2"Medium" 3"High"
lab val wealth_index wealth_index
tab wealth_index

/*See the KMO*/
estat kmo

************************************************************************
* Table 1. Participant characteristics
* - Overall study population
* - Stratified by child sex
*************************************************************************

*overall 
table1_mc if exclude1==0, ///
vars( ///
c_age_y conts \ ///
c_age_y contn %5.1f \ ///
preschool cat \ ///
m_edu_recode3 cat \ ///
m_employment cat \ ///
f_edu_final_1 cat \ ///
siblings_f cat \ ///
under5_f cat \ ///
ration_card1 cat \ ///
crowd_cat1 cat \ ///
hh_ownership1_recode1 cat \ ///
recode_hh_material_3 cat \ ///
drkwater_src cat \ ///
cstove_type cat \ ///
recode_cfuel_type cat \ ///
wealth_index cat \ ///
caste_n cat ///
bpb_ugdl med \ ///
anemia cat \ ///
stunted cat \ ///
underweight cat ///
) ///
saving(ECD_HHQ_Table1.xlsx, ///
sheet("Overall", replace))

*Stratified by sex
table1_mc if exclude1==0, by(c_sex) ///
vars( ///
c_age_y conts \ ///
c_age_y contn %5.1f \ ///
preschool cat \ ///
m_edu_recode3 cat \ ///
m_employment cat \ ///
f_edu_final_1 cat \ ///
siblings_f cat \ ///
under5_f cat \ ///
ration_card1 cat \ ///
crowd_cat1 cat \ ///
hh_ownership1_recode1 cat \ ///
recode_hh_material_3 cat \ ///
drkwater_src cat \ ///
cstove_type cat \ ///
recode_cfuel_type cat \ ///
wealth_index cat \ ///
caste_n cat ///
bpb_ugdl med \ ///
anemia cat \ ///
stunted cat \ ///
underweight cat ///
) ///
saving(ECD_HHQ_Table1.xlsx, ///
sheet("strat_by_sex", replace))

