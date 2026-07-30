/**********************************************************************
Purpose
Cross-sectional association between baseline BPb and follow-up RCPM 
//(fluid intelligence) outcome.

Outputs
* Statistical analyses were performed in Stata 16.1.
* Supplementary Fig. S5 was generated in R (version 4.3.3).

***********************************************************************/

clear
use analysis_dataset.dta, clear

********************************************************************************
* Multivariable linear regression analysis of follow-up RCPM scores
*
* Outcome: Follow-up RCPM raw score
* Exposure: Baseline blood lead concentration (log2-transformed; per doubling)
* Covariates: Child age, hemoglobin concentration, household crowding,
*             maternal education, and preschool
* tested interactions with child hemoglobin, age and maternal education
*******************************************************************************

reg rcpm_raw ///
	c.log2bpb2 ///
	c. c_age  ///
	c.cage_rcpm  ///
	c. child_hb ///
	c. crowding ///
	i.m_edu_recode3 ///
	i.preschool  

/*Exploratary analysis

*checking nonlinearlity with age^2
reg rcpm_raw log2bpb2 c.c_age##c.c_age age_years_1dp child_hb crowding i.m_edu_recode3 i.preschool  

*Linear regression model with baseline BPb as exposure and age-adjusted RCPM 
///at follow-up as an outcome
reg rcpm_ageadj ///
	c.log2bpb2 ///
	c. c_age  ///
	c. child_hb ///
	c. crowding ///
	i.m_edu_recode3 ///
	i.preschool  
	
*adding socioeconomic status (composite wealth index) as covariate
reg rcpm_raw ///
	c.log2bpb2 ///
	c. c_age  ///
	c.cage_rcpm  ///
	c. child_hb ///
	c. crowding ///
	i.m_edu_recode3 ///
	i.preschool  ///
	c.score
*/
*****************************************************************************
*Testing interaction between Pb and Hb 
*****************************************************************************
reg rcpm_raw ///
	c.log2bpb2##c.child_hb ///
	c. c_age  ///
	c.cage_rcpm  ///
	c. crowding ///
	i.m_edu_recode3 ///
	i.preschool  

*****************************************************************************
*Testing interaction between Pb and child age
*****************************************************************************
reg rcpm_raw ///
	c.log2bpb2##c.c_age ///
	c. child_hb ///
	c.cage_rcpm  ///
	c.crowding ///
	i.m_edu_recode3 ///
	i.preschool  
	
*****************************************************************************
*Testing interaction between Pb and maternal education
*****************************************************************************
reg rcpm_raw ///
	c.log2bpb2##i.m_edu_recode3 /// 
	c.c_age ///
	c.child_hb ///
	c.cage_rcpm  ///
	c.crowding ///
	i.preschool  

