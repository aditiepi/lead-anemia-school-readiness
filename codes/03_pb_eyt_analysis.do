/**********************************************************************
REPEATED Eexcutive Function (Early Years Toolbox) analysis

Purpose

To evaluate the association between baseline blood lead concentration
(BPb) and repeated measures of Executive Function (EF) scores ///
(Working Memory, Inhibitory control and cognitive flexibility) ///
collected at baseline (T1) and one-year follow-up (T2).


Input:
analysis_dataset.dta

Outputs:
Table 2
Note:
Figure 2 was generated separately in R using the analytical dataset
created in this workflow.
***********************************************************************/

clear
use analysis_dataset.dta, clear

*******************************************************************************
*Analytical approach:
*1. Reshape data from wide to long format.
*2. Fit linear mixed-effects models adjust for child age, hemoglobin, household 
    ///crowding, and maternal education, with random intercepts were included for 
   ///child and preschool to account for within-child correlation over time.
*4. Estimate adjusted differences comparing children at the 90th versus ///
    /// 10th percentile of BPb using marginal predictions.
*5. Test interaction between blood lead and IDELA
********************************************************************************

************************************************************************
* Reshape EYT data from wide to long format
************************************************************************
reshape long idela_total1_t idela_total2_t z_idela_total1_t z_idela_total2_t ///
            theta_total1_t theta_total2_t theta_total1m_t theta_total2m_t ///
			z_theta_total1m_t z_theta_total2m_t EF1_t EF1nostop_t z_EF1_t ///
		    z_EF1nostop_t z_EF2_t score_mrant_t z_score_mrant_t ///
			z_score_cardsort_t ///
			score_cardsort_t impulse_score_t z_impulse_score_t, /// 
			i(record_id) j(time)

tab time
gen time0 = time - 1

xtset record_id time

************************************************************************
* Primary mixed-effects model with WM (z_score_mrant_t) as primary outcome
* Output Table 2
************************************************************************
mixed z_score_mrant_t ///
      c.log2bpb2 ///
      c.c_age ///
      c.child_hb ///
	  c.crowding ///
      i.m_edu_recode3 ///
	  i.time ///
	  || record_id: 

************************************************************************
* Estimate the adjusted difference in Working Memory (WM) score comparing
* children at the 90th (40 µg/dL) versus 10th (4.5 µg/dL) percentile
* of blood lead concentration.
************************************************************************

local contrast = ln(40/4.5)/ln(2)

lincom `contrast'*log2bpb2

 
************************************************************************

************************************************************************
* Effect modification by child hemoglobin concentration
*
* The interaction between baseline BPb and child hemoglobin concentration
* was evaluated using a mixed-effects model with an interaction term.
* Adjusted WM scores were estimated at low (10.0 g/dL), mean
* (11.3 g/dL), and high (12.6 g/dL) hemoglobin concentrations,
* corresponding to the mean ± 1 SD of the study population.
************************************************************************

mixed z_score_mrant_t ///
      c.log2bpb2##c.child_hb ///
      i.time ///
      c.c_age ///
      c.crowding ///
      i.m_edu_recode3 ///
   	  || record_id:
	  
************************************************************************
* Estimate adjusted WM scores at the 10th (4.5 µg/dL) and
* 90th (40 µg/dL) percentiles of blood lead for representative
* hemoglobin concentrations (mean ±1 SD).
************************************************************************

summ child_hb if e(sample)

local hb_mean = r(mean)
local hb_low  = r(mean) - r(sd)
local hb_high = r(mean) + r(sd)

local pb10 = ln(4.5)/ln(2)
local pb90 = ln(40)/ln(2)

margins, ///
    at(log2bpb2=(2.17 5.32) ///
       child_hb=(`hb_low' `hb_mean' `hb_high')) ///
    atmeans ///
    predict(xb) post

***********************************************************************
* Compare adjusted WM scores between the 90th and 10th percentile
* of BPb within each hemoglobin level.
************************************************************************

lincom _b[4._at] - _b[1._at]   // Low Hb
lincom _b[5._at] - _b[2._at]   // Mean Hb
lincom _b[6._at] - _b[3._at]   // High Hb

************************************************************************
*Note:
*Publication-quality Figure 2 was generated separately in R using the
*adjusted predictions from the fitted mixed-effects model. Figure 2 shows the
*Adjusted differences in (B) Working memory 
*comparing children at the 90th (40 μg/dL) versus 10th percentiles (4.5 μg/dL) 
*of blood lead concentration (BPb), according to the child hemoglobin (Hb) levels.  
************************************************************************

************************************************************************
* Effect modification by child age: 
************************************************************************
mixed z_score_mrant_t ///
      c.log2bpb2##c.c_age ///
      time ///
      c.child_hb ///
      crowding ///
      i.m_edu_recode3 ///
      || record_id:

************************************************************************
* Effect modification by child height-for-age (HAZ)
************************************************************************
mixed z_score_mrant_t ///
      c.log2bpb2##c.haz ///
      time ///
	  c.c_age ///
      c.child_hb ///
      crowding ///
      i.m_edu_recode3 ///
      || record_id:
************************************************************************
* Effect modification by child sex
************************************************************************
mixed z_score_mrant_t ///
      c.log2bpb2##i.c_sex ///
      time ///
	  c.c_age ///
      c.child_hb ///
      crowding ///
      i.m_edu_recode3 ///
      || record_id:
************************************************************************
* Effect modification by maternal education
************************************************************************	  
mixed z_score_mrant_t ///
      c.log2bpb2##i.m_edu_recode3 ///
      time ///
      c.child_hb ///
	  c.c_age    ///
      crowding ///
	  || record_id:

**************************************************************************
*Note: no interactions between BPb and child age, sex, or mother’s education	  
******************************************************************************	
************************************************************************
* Sensitivity analysis: BPb × study visit interaction
*
* Evaluate whether the association between baseline BPb and repeated
* WM scores differed between baseline (T1) and follow-up (T2).
************************************************************************

mixed z_score_mrant_t ///
      c.log2bpb2##i.time ///
      c.c_age ///
      c.child_hb ///
      c.crowding ///
      i.m_edu_recode3 ///
      || record_id:

* Test the BPb × study visit interaction
testparm c.log2bpb2#i.time

lincom 2.time#c.log2bpb2
***********************************************************************
***************************************************************************  
************************************************************************
* Primary mixed-effects model with Impulse Control (z_impulse_score_t) as primary outcome
* Output Table 2
************************************************************************
mixed z_impulse_score_t ///
      c.log2bpb2 ///
      c.c_age ///
      c.child_hb ///
	  c.crowding ///
      i.m_edu_recode3 ///
	  i.time ///
	  || record_id: 

************************************************************************
* Estimate the adjusted difference in Impulse Control (IC) score comparing
* children at the 90th (40 µg/dL) versus 10th (4.5 µg/dL) percentile
* of blood lead concentration.
************************************************************************

local contrast = ln(40/4.5)/ln(2)

lincom `contrast'*log2bpb2

 
************************************************************************
* Effect modification by child hemoglobin concentration, age, sex and maternal
*education for Impulse Control (IC) score as an outcome
/*
* The interaction between baseline BPb and child hemoglobin concentration
* was evaluated using a mixed-effects model with an interaction term.
* Adjusted Impulse Control (IC) scores were estimated at low (10.0 g/dL), mean
* (11.3 g/dL), and high (12.6 g/dL) hemoglobin concentrations,
* corresponding to the mean ± 1 SD of the study population.
************************************************************************

mixed z_impulse_score_t ///
      c.log2bpb2##c.child_hb ///
      i.time ///
      c.c_age ///
      c.crowding ///
      i.m_edu_recode3 ///
   	  || record_id:
	  
************************************************************************
* Estimate adjusted Impulse Control (IC) scores at the 10th (4.5 µg/dL) and
* 90th (40 µg/dL) percentiles of blood lead for representative
* hemoglobin concentrations (mean ±1 SD).
************************************************************************

summ child_hb if e(sample)

local hb_mean = r(mean)
local hb_low  = r(mean) - r(sd)
local hb_high = r(mean) + r(sd)

local pb10 = ln(4.5)/ln(2)
local pb90 = ln(40)/ln(2)

margins, ///
    at(log2bpb2=(2.17 5.32) ///
       child_hb=(`hb_low' `hb_mean' `hb_high')) ///
    atmeans ///
    predict(xb) post

***********************************************************************
* Compare adjusted Impulse Control (IC) scores between the 90th and 10th percentile
* of BPb within each hemoglobin level.
************************************************************************

lincom _b[4._at] - _b[1._at]   // Low Hb
lincom _b[5._at] - _b[2._at]   // Mean Hb
lincom _b[6._at] - _b[3._at]   // High Hb


************************************************************************
* Effect modification by child age: 
************************************************************************
mixed z_impulse_score_t ///
      c.log2bpb2##c.c_age ///
      time ///
      c.child_hb ///
      crowding ///
      i.m_edu_recode3 ///
      || record_id:

************************************************************************
* Effect modification by child height-for-age (HAZ)
************************************************************************
mixed z_impulse_score_t ///
      c.log2bpb2##c.haz ///
      time ///
	  c.c_age ///
      c.child_hb ///
      crowding ///
      i.m_edu_recode3 ///
      || record_id:
************************************************************************
* Effect modification by child sex
************************************************************************
mixed z_impulse_score_t ///
      c.log2bpb2##i.c_sex ///
      time ///
	  c.c_age ///
      c.child_hb ///
      crowding ///
      i.m_edu_recode3 ///
      || record_id:
************************************************************************
* Effect modification by maternal education
************************************************************************	  
mixed z_impulse_score_t ///
      c.log2bpb2##i.m_edu_recode3 ///
      time ///
      c.child_hb ///
	  c.c_age    ///
      crowding ///
	  || record_id:

**************************************************************************
*Note: no interactions between BPb and child age, sex, or mother’s education	  
******************************************************************************	
************************************************************************
* Sensitivity analysis: BPb × study visit interaction
*
* Evaluate whether the association between baseline BPb and repeated
* IC scores differed between baseline (T1) and follow-up (T2).
************************************************************************

mixed z_impulse_score_t ///
      c.log2bpb2##i.time ///
      c.c_age ///
      c.child_hb ///
      c.crowding ///
      i.m_edu_recode3 ///
      || record_id:

* Test the BPb × study visit interaction
testparm c.log2bpb2#i.time

lincom 2.time#c.log2bpb2
***********************************************************************
***************************************************************************  
*/


************************************************************************
* Primary mixed-effects model with Cognitive Flexibility (z_score_cardsort_t) 
*as primary outcome
* Output Table 2
************************************************************************
mixed z_score_cardsort_t ///
      c.log2bpb2 ///
      c.c_age ///
      c.child_hb ///
	  c.crowding ///
      i.m_edu_recode3 ///
	  i.time ///
	  || record_id: 

************************************************************************
* Estimate the adjusted difference in Cognitive Flexibility (cog Flex) score comparing
* children at the 90th (40 µg/dL) versus 10th (4.5 µg/dL) percentile
* of blood lead concentration.
************************************************************************

local contrast = ln(40/4.5)/ln(2)

lincom `contrast'*log2bpb2

 
************************************************************************

************************************************************************
* Effect modification by child hemoglobin concentration
*
* The interaction between baseline BPb and child hemoglobin concentration
* was evaluated using a mixed-effects model with an interaction term.
* Adjusted Cog flex scores were estimated at low (10.0 g/dL), mean
* (11.3 g/dL), and high (12.6 g/dL) hemoglobin concentrations,
* corresponding to the mean ± 1 SD of the study population.
************************************************************************

mixed z_score_cardsort_t ///
      c.log2bpb2##c.child_hb ///
      i.time ///
      c.c_age ///
      c.crowding ///
      i.m_edu_recode3 ///
   	  || record_id:
	  
************************************************************************
* Estimate adjusted WM scores at the 10th (4.5 µg/dL) and
* 90th (40 µg/dL) percentiles of blood lead for representative
* hemoglobin concentrations (mean ±1 SD).
************************************************************************

summ child_hb if e(sample)

local hb_mean = r(mean)
local hb_low  = r(mean) - r(sd)
local hb_high = r(mean) + r(sd)

local pb10 = ln(4.5)/ln(2)
local pb90 = ln(40)/ln(2)

margins, ///
    at(log2bpb2=(2.17 5.32) ///
       child_hb=(`hb_low' `hb_mean' `hb_high')) ///
    atmeans ///
    predict(xb) post

***********************************************************************
* Compare adjusted WM scores between the 90th and 10th percentile
* of BPb within each hemoglobin level.
************************************************************************

lincom _b[4._at] - _b[1._at]   // Low Hb
lincom _b[5._at] - _b[2._at]   // Mean Hb
lincom _b[6._at] - _b[3._at]   // High Hb

/*************************************************************************
* Effect modification by child hemoglobin concentration, age, sex and maternal
*education for Cog Flex score as an outcome
/*
* The interaction between baseline BPb and child hemoglobin concentration
* was evaluated using a mixed-effects model with an interaction term.
* Adjusted Cog Flex scores were estimated at low (10.0 g/dL), mean
* (11.3 g/dL), and high (12.6 g/dL) hemoglobin concentrations,
* corresponding to the mean ± 1 SD of the study population.
************************************************************************

mixed z_score_cardsort_t ///
      c.log2bpb2##c.child_hb ///
      i.time ///
      c.c_age ///
      c.crowding ///
      i.m_edu_recode3 ///
   	  || record_id:
	  
************************************************************************
* Estimate adjusted Cog Flex scores at the 10th (4.5 µg/dL) and
* 90th (40 µg/dL) percentiles of blood lead for representative
* hemoglobin concentrations (mean ±1 SD).
************************************************************************

summ child_hb if e(sample)

local hb_mean = r(mean)
local hb_low  = r(mean) - r(sd)
local hb_high = r(mean) + r(sd)

local pb10 = ln(4.5)/ln(2)
local pb90 = ln(40)/ln(2)

margins, ///
    at(log2bpb2=(2.17 5.32) ///
       child_hb=(`hb_low' `hb_mean' `hb_high')) ///
    atmeans ///
    predict(xb) post

***********************************************************************
* Compare adjusted Cog Flex scores between the 90th and 10th percentile
* of BPb within each hemoglobin level.
************************************************************************

lincom _b[4._at] - _b[1._at]   // Low Hb
lincom _b[5._at] - _b[2._at]   // Mean Hb
lincom _b[6._at] - _b[3._at]   // High Hb


************************************************************************
* Effect modification by child age: 
************************************************************************
mixed z_score_cardsort_t ///
      c.log2bpb2##c.c_age ///
      time ///
      c.child_hb ///
      crowding ///
      i.m_edu_recode3 ///
      || record_id:

************************************************************************
* Effect modification by child height-for-age (HAZ)
************************************************************************
mixed z_score_cardsort_t ///
      c.log2bpb2##c.haz ///
      time ///
	  c.c_age ///
      c.child_hb ///
      crowding ///
      i.m_edu_recode3 ///
      || record_id:
************************************************************************
* Effect modification by child sex
************************************************************************
mixed z_score_cardsort_t ///
      c.log2bpb2##i.c_sex ///
      time ///
	  c.c_age ///
      c.child_hb ///
      crowding ///
      i.m_edu_recode3 ///
      || record_id:
************************************************************************
* Effect modification by maternal education
************************************************************************	  
mixed z_score_cardsort_t ///
      c.log2bpb2##i.m_edu_recode3 ///
      time ///
      c.child_hb ///
	  c.c_age    ///
      crowding ///
	  || record_id:

**************************************************************************
*Note: no interactions between BPb and child age, sex, or mother’s education	  
******************************************************************************	
************************************************************************
* Sensitivity analysis: BPb × study visit interaction
*
* Evaluate whether the association between baseline BPb and repeated
* Cog Flex scores differed between baseline (T1) and follow-up (T2).
************************************************************************

mixed z_score_cardsort_t ///
      c.log2bpb2##i.time ///
      c.c_age ///
      c.child_hb ///
      c.crowding ///
      i.m_edu_recode3 ///
      || record_id:

* Test the BPb × study visit interaction
testparm c.log2bpb2#i.time

lincom 2.time#c.log2bpb2
***********************************************************************
***************************************************************************  

*/

****************************************************************************
* Note: 
******************************************************************************
*Publication-quality Figure 2 was generated separately in R.
******************************************************************************
* Assessment of non-linearity
* Non-linear associations between BPb and EF scores were evaluated
* using restricted cubic spline models implemented in R.
* See the corresponding R script.
************************************************************************

