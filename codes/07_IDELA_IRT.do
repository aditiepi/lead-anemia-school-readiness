/**********************************************************************
This script reproduces the Item Response Theory (IRT) analyses
described in:

Roy A et al.
Lead exposure, anemia, and school readiness among low-income urban
children in Bihar, India: A longitudinal study.
Submitted to The Lancet Regional Health – Southeast Asia.

Purpose:
This script estimates latent developmental scores using graded response
models (GRM) and derives standardized domain and composite scores.

The same workflow was applied to both baseline (T1) and follow-up (T2)
datasets. The second half of the script repeats the identical analyses
using the T2 analytical dataset.

Data availability:
The analytical dataset used in this study is not publicly available
because it contains confidential participant information. Deidentified and curated data will be made available to bona fide researchers for scientific purposes upon reasonable request to the corresponding author (aditi@ccdcindia.org), subject to the necessary institutional and ethical approvals. 

Software:
Stata 16.1
**********************************************************************/

clear
* Set the working directory before running
* cd "path_to_project_directory"

*log using "idela ITR.log"

/*Open the File: Use the IDELA T1 score file for IRT analsis*/
use "idela_t1.dta", clear

*************emergent literacy and language domain*******************
irt grm expvocab1 expvocab2 pa1 pa2 pa3 letterid lettersound1 lettersound2 lettersound3 writelevel oralcomp1 oralcomp2 oralcomp3 oralcomp4 oralcomp5 if idela_complete==2
predict theta_lit, latent, if idela_complete==2
estat report  /*Psychomteric checking*/
estat ic
estat report, byparm
irtgraph icc
summarize theta_lit
egen z_theta_lit = std(theta_lit)
sum z_theta_lit

/*for checking alternative model- excluding pa varibles*****
irt grm expvocab1 expvocab2 letterid lettersound1 lettersound2 lettersound3 writelevel oralcomp1 oralcomp2 oralcomp3 oralcomp4 oralcomp5
estat ic
******further reduced model***************
irt grm expvocab1 expvocab2 letterid writelevel oralcomp1 oralcomp2 oralcomp3 oralcomp4 oralcomp5
*/

*****************emergent numeracy***************
irt grm size1 size2 size3 size4 sort1 sort2 shapeid1 shapeid2 shapeid3 shapeid4 shapeid5 numberid onetoone1 onetoone2 onetoone3 operation1 operation2 operation3 puzzle if idela_complete==2
predict theta_num, latent, if idela_complete==2
estat report
irtgraph tcc
irtgraph tcc, thetalines(-1.96 0 1.96)
summarize theta_num
egen z_theta_num = std(theta_num)
sum z_theta_num

******************socio-emotional development*********
irt grm personal1 personal2 personal3 personal4 personal5 personal6 friends1 emotion1 emotion2 emotion3 emotion4 empathy1 empathy2 empathy3 conflict1 conflict2 if idela_complete==2
predict theta_socem, latent, if idela_complete==2
estat report
irtgraph tcc
irtgraph tcc, thetalines(-1.96 0 1.96)
summarize theta_socem
egen z_theta_socem = std(theta_socem)
sum z_theta_socem

******************gross & fine motor development*********
/*
irt grm copyshape1 copyshape2 drawhuman1 drawhuman2 drawhuman3 drawhuman4 drawhuman5 drawhuman6 drawhuman7 drawhuman8 fold hop if idela_complete==2  /*included hopping*/
predict theta_grossfine, latent, if idela_complete==2
estat report
summarize theta_grossfine   ///The model ran fine in T1; the GRM assumptions were satisfied. However, to be consistent with T2 where monotonic assumpions are met for drawhuman items; we will summarize the drawing items and then use that in the GRM model for motor and only fine motor models

irt grm copyshape1 copyshape2 drawhuman1 drawhuman2 drawhuman3 drawhuman4 drawhuman5 drawhuman6 drawhuman7 drawhuman8 fold if idela_complete==2 //only fine motor
predict theta_finemotor, latent, if idela_complete==2
*/
egen drawhuman_total = rowtotal(drawhuman1-drawhuman8) if idela_complete==2
sum drawhuman_total

irt grm copyshape1 copyshape2 drawhuman_total fold hop if idela_complete==2
predict theta_grossfine, latent, if idela_complete==2
estat report
irtgraph tcc
irtgraph tcc, thetalines(-1.96 0 1.96)
summarize theta_grossfine // IRT model using drawing total which did not show increase in difficulty
egen z_theta_grossfine = std(theta_grossfine)
sum z_theta_grossfine

irt grm copyshape1 copyshape2 drawhuman_total fold if idela_complete==2
predict theta_finemotor, latent, if idela_complete==2
estat report
irtgraph tcc
irtgraph tcc, thetalines(-1.96 0 1.96)
summarize theta_finemotor
egen z_theta_finemotor = std(theta_finemotor)
sum z_theta_finemotor

*summarize all domains*
summarize theta_lit theta_num theta_socem theta_grossfine theta_finemotor
summarize z_theta_lit z_theta_num z_theta_socem z_theta_grossfine z_theta_finemotor

/*Corrlation between dev domains
pwcorr theta_lit theta_num theta_socem theta_grossfine theta_finemotor
ssc install heatplot
ssc install mat2txt
corr theta_lit theta_num theta_socem theta_grossfine theta_finemotor
matrix C = r(C)
heatplot C, ///
	values(format(%4.2f)) ///
    color(hcl blues, reverse) ///
    xlabel(, angle(45)) ///
	title("Correlation matrix of developmental domains at T1")
*/

*total of all domains using SEM*
*with all four domains*
sem (theta_lit theta_num theta_socem theta_grossfine <- F_total), standardized
predict theta_total1, latent(F_total) /* This total includes 4 domains: literacy, numeracy, socio-emotional dev and fine motor*/
estat gof, stats(all)
label var theta_total1 "IRT + SEM-derived scores including gross & fine motor domains"

sem (theta_lit theta_num theta_socem theta_finemotor <- F_total), standardized
predict theta_total2, latent(F_total) /* This total includes 4 domains: literacy, numeracy, socio-emotional dev and fine motor only*/
estat gof, stats(all)
label var theta_total2 "IRT + SEM-derived scores including 4 domains w/o gross motor"

*using simple mean composite*
egen theta_total1m = rowmean(z_theta_lit z_theta_num z_theta_socem z_theta_grossfine)
label var theta_total1m "average of standardized domain scores"
egen z_theta_total1m = std(theta_total1m)
label var z_theta_total1m "standardized simple mean composite of IRT-derived scores with all 4 domains"

egen theta_total2m = rowmean(z_theta_lit z_theta_num z_theta_socem z_theta_finemotor) 
label var theta_total2m "average of standardized domain scores"
egen z_theta_total2m = std(theta_total2m)
label var z_theta_total2m "standardized simple mean composite of IRT-derived scores 4 domains & fine motor only"


corr theta_total1 theta_total1m
scatter theta_total1 z_theta_total1m, ///
    yline(0) xline(0) ///
    title("SEM total vs Mean composite") /*SEM and mean composite are not different. Hence no extra gain with SEM. Use mean composite*/

corr z_theta_total1 z_theta_total1m
scatter z_theta_total1 z_theta_total1m, ///
    yline(0) xline(0) ///
    title("SEM total vs Mean composite T2") /*SEM and mean composite are not different. Hence no extra gain with SEM. Use mean composite*/
	
*Rename variables to distinguish between T1 and T2
foreach v of varlist ///
    idela_date1 idelainterviewer assess_alone assessment_place ///
	idela_place_other idela_complete theta_grossfine theta_finemotor theta_lit ///
	theta_num theta_socem z_theta_lit z_theta_num z_theta_socem z_theta_grossfine 	 z_theta_finemotor theta_total1 theta_total2 theta_total1m z_theta_total1m ///
    theta_total2m z_theta_total2m {

    rename `v' `v'_t1
}

/*Create dataset with all IDELA variables for final analysis: this includes total sums and IRT-derived variables/

keep record_id redcap_event_name idela_date1_t1 idelainterviewer_t1 assess_alone_t1 assessment_place_t1 idela_place_other_t1 idela_complete_t1 motor1_t1 motor2_t1 emergentlit_t1 EF1_t1 EF1nostop_t1 EF2_t1 idela_total1_t1 socioemotion_t1 emergentnum_t1 idela_total2_t1 z_motor1_t1 z_motor2_t1 z_emergentlit_t1 z_emergentnum_t1 z_socioemotion_t1 z_EF1_t1 z_EF1nostop_t1 z_EF2_t1 z_idela_total1_t1 z_idela_total2_t1 theta_lit_t1 theta_num_t1 theta_socem_t1 theta_grossfine_t1 theta_finemotor_t1 theta_total1_t1 theta_total2_t1 theta_total1m_t1 z_theta_total1m_t1 theta_total2m_t1 z_theta_total2m_t1

save idela_T1_final.dta, replace*/

log close

