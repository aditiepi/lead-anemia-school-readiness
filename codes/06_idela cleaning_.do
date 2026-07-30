/**********************************************************************
/**********************************************************************
Title: IDELA scoring and derivation of domain scores

Purpose:
This script derives IDELA domain scores and standardized outcomes used
in the manuscript "Lead exposure, anemia, and school readiness among
low-income urban children in Bihar, India: A longitudinal study."

The same scoring procedures were applied to both baseline (T1) and
follow-up (T2) assessments. To generate T2 scores, replace the input
dataset with the follow-up dataset (e.g., idela_t2.dta).

Data availability:
The analytical dataset used in this study is not publicly available
because it contains confidential participant information. Deidentified and curated data will be made available to bona fide researchers for scientific purposes upon reasonable request to the corresponding author (aditi@ccdcindia.org), subject to the necessary institutional and ethical approvals. 

Software:
Stata 16.1
**********************************************************************/
**********************************************************************/


clear
* Set working directory before running
* cd "path_to_project_folder"

///General information///
tab idela_date1
tab redcap_event_name
tab idela_complete
tab idelainterviewer
tab assess_alone
tab assessment_place
tab idela_place_other

/* IDELA (main assessment)*/
///Check individual responses on 24 items + 2 additional items (Item C and Item H)///
///Item 1: personal awareness///
tab personal1 
tab personal2 
tab personal3 
tab personal4 
tab personal5 
tab personal6 

////Item 2: size/length////
tab size1 
tab size2 
tab size3 
tab size4 

////Item 3: card sorting////
tab sort1 
tab sort2 /*In case sort1 was not attempted; sort2 was given 999*/
recode sort2 (999 = 0)

///Item 4: shape identification///
tab shapeid1
tab shapeid2
tab shapeid3
tab shapeid4
tab shapeid5

///Item A: Positionality////
tab position1
tab position2
tab position3
tab position4

///Item 5: Number ID (emergent math)///
tab numberid_skiprefused
/*list record_id if numberid_skiprefused==1*/
sum numberid 

*Setting missing for those who skipped/refused numberid
replace numberid=0 if numberid_skiprefused==1
sum numberid

///Item 6: one-to-one correspondence///
tab onetoone1 
tab onetoone2  
tab onetoone3 /*In case one-to-one 2 was not attempted; one-to-one 3  was given 999*/
recode onetoone3 (999 = 0)

/*persistence/engagement/// 
tab one2toonepersist1 
tab one2toonepersist2 
*/

////Item 7: Addition/subtraction///
tab operation1 
tab operation2 
tab operation3 

///Item B: Number comparisons///
tab comparison1
tab comparison2
tab comparison3

///Item C: Patterns-1 ////
tab pattern1

///Item 8: Puzzle ////
sum puzzle 

///Item 9: Friends (SEL)///
sum friends1 

///Item 10: Emotional regulation///
tab emotion1 
tab emotion2 
tab emotion3  /*In case emotion 2 was not attempted; emotion 3  was given 999*/
recode emotion3 (999 = 0)
tab emotion3
tab emotion4 

///Item 11: Empathy///
tab empathy1 
tab empathy2 
tab empathy3 /*skipped if empathy2 is no*/
recode empathy3 (999 = 0)
tab empathy3

///Item 12: Solving conflict///
tab conflict1
tab conflict2 /*skipped if conflict2 is no*/
recode conflict2 (999 = 0)
tab conflict2

///Item 13: Working memory///
tab memory1 
recode memory1(999=0) 
tab memory1
tab memory2 
recode memory2(999=0) 
tab memory2
tab memory3 
recode memory3(999=0)
tab memory3
tab memory4 
recode memory4(999=0)
tab memory4

////Item 14: Head-toes games (IC)///
tab hsktstop //whether child understands instructions and could do practice tests- only then proceed
tab hskt1 if hsktstop==1
tab hskt2 if hsktstop==1
tab hskt3 if hsktstop==1
tab hskt4 if hsktstop==1
tab hskt5 if hsktstop==1

///Item 15: Expressive vocabulary///
sum expvocab1 
sum expvocab2 

///Item 16: Print awareness///
tab pa1 
recode pa1 (999=0) /*refused to open the book--recoding to 0*/
tab pa1
tab pa2 
recode pa2 (999=0) /*recoding skipped to 0*/
tab pa2
tab pa3 
recode pa3 (999=0) /*recoding skipped to 0*/
tab pa3

///Item 17: Letter ID////
sum letterid 
recode letterid (999=0) /*refused to write--recoded to 0*/
sum letterid

///Item 18: First letter sounds///
tab lettersound1 
tab lettersound2 
recode lettersound2 (999=0) /*refused-- recoded to 0*/
tab lettersound2
tab lettersound3 
recode lettersound3 (999=0) /*refused-- recoded to 0*/
tab lettersound3 

///Item 19: Writing////
sum writelevel 
recode writelevel (999=0) /*refused-- recoded to 0*/
sum writelevel

///Item 20: Listenning comprehension///
tab oralcomp1
tab oralcomp2
tab oralcomp3
tab oralcomp4

/*Persistence/engagement///
tab oralcomppersist1
tab oralcomppersist2
*/

///Item 21: Copying a shape////
tab copyshape1
recode copyshape1 (999=0) /*refused-- recoded to 0*/
tab copyshape1
tab copyshape2 
recode copyshape2 (999=0) /*if copyshape1 is refused then copyshape2 was not administered*/
tab copyshape2

///Item 22: Drawing///
tab drawhuman1
recode drawhuman1 (999=0) /*refused to draw--recoded to 0*/
tab drawhuman1
tab drawhuman2
recode drawhuman2 (999=0) 
tab drawhuman2
tab drawhuman3
recode drawhuman3 (999=0) 
tab drawhuman3
tab drawhuman4
recode drawhuman4 (999=0) 
tab drawhuman4
tab drawhuman5
recode drawhuman5 (999=0) 
tab drawhuman5
tab drawhuman6
recode drawhuman6 (999=0) 
tab drawhuman6
tab drawhuman7
recode drawhuman7 (999=0) 
tab drawhuman7
tab drawhuman8
recode drawhuman8 (999=0) 
tab drawhuman8

///Item 23: Folding///
*list record_id if fold==999
sum fold 
recode fold (999=0)
sum fold
/*Persistence/engagement///
tab foldpersist1
tab foldpersist2
*/

///Item H: Knock-tap (IC)///
tab knocktaptrial
tab knocktap1 if knocktaptrial==1
tab knocktap1
tab knocktap2
tab knocktap3
tab knocktap16
recode knocktap*(999=0)
tab knocktap2
tab knocktap3
tab knocktap16

///Item 24: Hopping///
tab hop_yesno
tab hop

////////Total scores in individual domains///////
////Calculating total scores////
//Item 1.personal awareness (Domain: socio-emotional)//
*Generate new personal awareness total score from 6 items*
egen pa_total=rowtotal(personal1 personal2 personal3 personal4 personal5 personal6)
replace pa_total=. if personal1==. & personal2==. & personal3==. & personal4==. & personal5==. & personal6==. 
label var pa_total "Personal awareness total"
sum pa_total 
gen pct_correct_pa= pa_total/6 /*percentage correct*/
replace pct_correct_pa=. if pa_total==.
sum pct_correct_pa, detail

//Item 2. Size (Domain: emergent numeracy)//
egen size_total=rowtotal(size1 size2 size3 size4)
replace size_total=. if size1==. & size2==. & size3==. & size4==. 
label var size_total "Comparison by size and length"
sum size_total 
gen pct_correct_size= size_total/4
replace pct_correct_size=. if size_total==.
sum pct_correct_size, detail

//Item 3. Sorting (emergent numeracy)//
egen sort_total= rowtotal(sort1 sort2)
replace sort_total=. if sort1==. & sort2==.
label var sort_total "Sorting"
sum sort_total 
gen pct_correct_sort= sort_total/2
replace pct_correct_sort=. if sort_total==.
sum pct_correct_sort, detail

//Item 4. Shape Identification (emergent numeracy)//
egen shapeid_total= rowtotal(shapeid1 shapeid2 shapeid3 shapeid4 shapeid5)
replace shapeid_total=. if shapeid1==. & shapeid2==. & shapeid3==. & shapeid4==. & shapeid5==. 
label var shapeid_total "Total score for shape id"
sum shapeid_total 
gen pct_correct_shapeid= shapeid_total/5
replace pct_correct_shapeid=. if shapeid_total==.
sum pct_correct_shapeid, detail

//Item A: Positionality//
egen position= rowtotal(position1 position2 position3 position4)
replace position=. if position1==. & position2==. & position3==. & position4==.
sum position
gen pct_correct_position= position/4
replace pct_correct_position=. if position==.
sum pct_correct_position, detail

//Item 5.Number identification (emergent literacy)//
sum numberid, detail
gen pct_correct_numberid= numberid/20
replace pct_correct_numberid=. if numberid==.
sum pct_correct_numberid, detail

//Item 6.One to one correspondence (emergent numeracy)//
egen onetoone_total= rowtotal(onetoone1 onetoone2 onetoone3)
replace onetoone_total=. if onetoone1==. & onetoone2==. & onetoone3==.
label var onetoone_total "Total score on one to one correspondence"
sum onetoone_total 
gen pct_correct_onetoone= onetoone_total/3
replace pct_correct_onetoone=. if onetoone_total==.
sum pct_correct_onetoone, detail

//Item 7.Addition & subtraction (emergent numeracy)//
egen operation_total= rowtotal(operation1 operation2 operation3)
replace operation_total=. if operation1==. & operation2==. & operation3==. 
label var operation_total "Total score on add & subtraction"
sum operation_total 
gen pct_correct_operation= operation_total/3
replace pct_correct_operation=. if operation_total==.
sum pct_correct_operation, detail

//Item B: Number comparison (emergent numeracy)//
egen comparison_total= rowtotal(comparison1 comparison2 comparison3)
replace comparison_total=. if comparison1==. & comparison2==. & comparison3==.
label var comparison_total "Total score on num comparison"
sum comparison_total, detail
gen pct_correct_comparison= comparison_total/3
replace pct_correct_comparison=. if comparison_total==.
sum pct_correct_comparison, detail

//Item C: patterns//
sum pattern1, detail

//Item 8.Puzzle (emergent numeracy)//
label var puzzle "Total score on puzzle completion"
sum puzzle 
gen pct_correct_puzzle= puzzle/4
replace pct_correct_puzzle=.  if puzzle==.
sum pct_correct_puzzle, detail

//Item 9.Friends (soc-emotional)//
gen pct_correct_friends= friends1/10
replace pct_correct_friends=. if friends1==.
sum pct_correct_friends, detail

//Item 10.Emotional regulation (soc-emotional)//
egen emotion_total= rowtotal(emotion1 emotion2 emotion3 emotion4)
replace emotion_total=. if emotion1==. & emotion2==. & emotion3==. & emotion4==. 
sum emotion_total 
gen pct_correct_emotion= emotion_total/4
replace pct_correct_emotion=. if emotion_total==.
sum pct_correct_emotion, detail

//Item 11.Empathy (soc-emotional)//
egen empathy_total= rowtotal(empathy1 empathy2 empathy3)
replace empathy_total=. if empathy1==. & empathy2==. & empathy3==. 
sum empathy_total
label var empathy_total "Total score on empathy"
gen pct_correct_empathy= empathy_total/3
replace pct_correct_empathy=. if empathy_total==.
sum pct_correct_empathy, detail

//Item 12.Conflict solving (soc-emotional)//
egen conflict_total= rowtotal(conflict1 conflict2)
replace conflict_total=. if conflict1==. & conflict2==.
sum conflict_total 
label var conflict_total "Total score on conflict solving"
gen pct_correct_conflict= conflict_total/2
replace pct_correct_conflict=.  if conflict_total==.
sum pct_correct_conflict, detail

//Item 13.short-term memory (EF)//
*forward number*
egen shortmemory_total= rowtotal(memory1 memory2 memory3 memory4)
replace shortmemory_total=. if memory1==. & memory2==. & memory3==. & memory4==.
sum shortmemory_total  
label var shortmemory_total "Total score on working memory"
gen pct_correct_memory= shortmemory_total/4
replace pct_correct_memory=. if shortmemory_total==.
sum pct_correct_memory, detail

//Item 14. Inhibitory control (EF)//
egen IC_total= rowtotal(hskt1 hskt2 hskt3 hskt4 hskt5)
replace IC_total=. if hsktstop==0 
replace IC_total=. if hskt1==. & hskt2==. & hskt3==. & hskt4==. & hskt5==.
sum IC_total
label var IC_total "Total score on inhibitory control"
gen pct_correct_IC= IC_total/10
replace IC_total=. if IC_total==.
sum pct_correct_IC, detail  

*replacing missing data with 0 or incorrect for those who failed practice*
replace hskt1=0 if hsktstop==0 & idela_complete==2
replace hskt2=0 if hsktstop==0 & idela_complete==2
replace hskt4=0 if hsktstop==0 & idela_complete==2
replace hskt5=0 if hsktstop==0 & idela_complete==2
*recalculated total scores*
egen IC_totalnostop= rowtotal(hskt1 hskt2 hskt3 hskt4 hskt5)
replace IC_totalnostop=. if hskt1==. & hskt2==. & hskt3==. & hskt4==. & hskt5==.
sum IC_totalnostop 
gen pct_correct_IC_nostop= IC_totalnostop/10
sum pct_correct_IC_nostop 

//Item 15.vocabulary (Emergent literacy)//
egen expvocab_total= rowtotal(expvocab1 expvocab2)
replace expvocab_total=. if expvocab1==. & expvocab2==.
sum expvocab_total 
label var expvocab_total "Total score on exp vocab"
gen pct_correct_expvocab= expvocab_total/20
replace pct_correct_expvocab=. if expvocab_total==.
sum pct_correct_expvocab, detail

//Item 16.print awareness (emergent literacy)//
egen print_total= rowtotal(pa1 pa2 pa3)
replace print_total=. if pa1==. & pa2==. & pa3==.
label var print_total "Total score on print awareness"
sum print_total 
gen pct_correct_print= print_total/3
replace pct_correct_print=. if print_total==.
sum pct_correct_print, detail

//Item 17. Letter identification (emergent literacy)//
label var letterid "Total score on letter identification"
gen pct_correct_letterid= letterid/20
replace pct_correct_letterid=. if letterid==.
sum pct_correct_letterid, detail

//Item 18. letter sound (emergent literacy)//
egen lettersound_total= rowtotal(lettersound1 lettersound2 lettersound3)
replace lettersound_total=. if lettersound1==. & lettersound2==. & lettersound3==.
label var lettersound_total "Total score on letter sound identification"
sum lettersound_total 
gen pct_correct_lettersound= lettersound_total/3
replace pct_correct_lettersound=. if lettersound_total==.
sum pct_correct_lettersound, detail

//Item 19.writing (emergent literacy)//
label var writelevel "Score on writing level"
gen pct_correct_write= writelevel/4
replace pct_correct_write=. if writelevel==.
sum pct_correct_write, detail

//Item 20. oral comprehension (emergent literacy)//
egen oralcomp_total= rowtotal(oralcomp1 oralcomp2 oralcomp3 oralcomp4 oralcomp5)
replace oralcomp_total=. if oralcomp1==. & oralcomp2==. & oralcomp3==. & oralcomp4==. & oralcomp5==.
label var oralcomp_total "Total on oral comprehension"
sum oralcomp_total 
gen pct_correct_oralcomp= oralcomp_total/5
replace pct_correct_oralcomp=. if oralcomp_total==.
sum pct_correct_oralcomp, detail

//Item 21. Copying a shape (fine motor)//
egen copyshape_total= rowtotal(copyshape1 copyshape2)
replace copyshape_total=. if copyshape1==. & copyshape2==.
label var copyshape_total "Total score on copying a shape"
sum copyshape_total 
gen pct_correct_copyshape= copyshape_total/4
replace pct_correct_copyshape=. if copyshape_total==.
sum pct_correct_copyshape, detail

//Item 22. Drawing (fine motor)//
egen draw= rowtotal(drawhuman1 drawhuman2 drawhuman3 drawhuman4 drawhuman5 drawhuman6 drawhuman7 drawhuman8)
replace draw=. if drawhuman1==. & drawhuman2==. & drawhuman3==. & drawhuman4==. & drawhuman5==. & drawhuman6==. & drawhuman7==. & drawhuman8==.
label var draw "Total score on drawing"
sum draw 
gen pct_correct_draw= draw/8
replace pct_correct_draw=. if draw==.
sum pct_correct_draw, detail

//Item 23. folding (fine motor)//
label var fold "Number of (fold) steps followed correctly"
gen pct_correct_fold= fold/4
replace pct_correct_fold=. if fold==.
sum pct_correct_fold, detail 

//Item H: Knock-tap (Inhibitory Control)//
egen kt_total= rowtotal(knocktap1 - knocktap16)
replace kt_total=. if knocktaptrial==0
replace kt_total=. if knocktap1==. & knocktap2==. &  knocktap3==. & knocktap4==.
sum kt_total
label var kt_total "Total score on knock tap"
gen pc_correct_kt= kt_total/16
replace pc_correct_kt=. if kt_total==.
sum pc_correct_kt, detail

egen kt_total1= rowtotal(knocktap1 - knocktap16)
replace kt_total1=0 if knocktaptrial==0
replace kt_total1=. if knocktaptrial==.
sum kt_total1 //use this one for final analysis
label var kt_total1 "Total score on knock tap"
gen pc_correct_kt1= kt_total1/16
replace pc_correct_kt1=. if kt_total1==.
sum pc_correct_kt1, detail

//24. Hopping (gross motor)//
label var hop "Number of steps hopped"
gen pct_correct_hop= hop/10
replace pct_correct_hop=. if hop==.
sum pct_correct_hop, detail

/////////////////domain scores//////////////////////////////////////////////////
//gross & fine motor development//
gen motor1= (pct_correct_hop + pct_correct_copyshape + pct_correct_draw + pct_correct_fold)/4
replace motor1=. if pct_correct_hop==. & pct_correct_copyshape==. & pct_correct_draw==. & pct_correct_fold==.
label var motor1 "Gross & fine motor development % correct total score"
sum motor1, detail

///Only fine motor development////
gen motor2= (pct_correct_copyshape + pct_correct_draw + pct_correct_fold)/3
replace motor2=. if pct_correct_copyshape==. & pct_correct_draw==. & pct_correct_fold==.
label var motor2 "Fine motor development % correct total score"
sum motor2, detail

//emergent literacy and language//
gen emergentlit= (pct_correct_expvocab + pct_correct_print + pct_correct_letterid + pct_correct_lettersound + pct_correct_write + pct_correct_oralcomp)/6
replace emergentlit=. if pct_correct_expvocab==. & pct_correct_print==. & pct_correct_letterid==. & pct_correct_lettersound==. & pct_correct_write==. & pct_correct_oralcomp==.
label var emergentlit "Emergent literacy and language development"
sum emergentlit, detail

//Emergent numeracy//
gen emergentnum= (pct_correct_size + pct_correct_sort + pct_correct_shapeid + pct_correct_numberid + pct_correct_onetoone + pct_correct_operation + pct_correct_puzzle)/7
replace emergentnum=.  if pct_correct_size==. & pct_correct_sort==. & pct_correct_shapeid==0 & pct_correct_numberid==. & pct_correct_onetoone==. & pct_correct_operation==. & pct_correct_puzzle==.
label var emergentnum "Emergent Numeracy % score"
sum emergentnum, detail

/*gen emergentnum1= (pct_correct_size + pct_correct_sort + pct_correct_shapeid + ///
	pct_correct_numberid + pct_correct_onetoone + pct_correct_operation + ///
	pct_correct_puzzle)/7
replace emergentnum1=0  if pct_correct_size==. | pct_correct_sort==. | pct_correct_shapeid==0 | pct_correct_numberid==. | pct_correct_onetoone==. | pct_correct_operation==. | pct_correct_puzzle==.
replace emergentnum1=. if idela_complete==0
label var emergentnum1 "Emergent Numeracyy % score (not attempted set to 0)"
sum emergentnum1, detail
*/

//Socio-emotional development//
gen socioemotion= (pct_correct_pa + pct_correct_friends + pct_correct_emotion + pct_correct_empathy + pct_correct_conflict)/5
replace socioemotion=. if pct_correct_pa==. & pct_correct_friends==. & pct_correct_emotion==. & pct_correct_empathy==. & pct_correct_conflict==. 
label var socioemotion "Socio-emotional development % score" 
sum socioemotion, detail

//Executive function//
gen EF1= (pct_correct_memory + pct_correct_IC)/2
replace EF1=. if pct_correct_memory==. & pct_correct_IC==.
label var EF1 "Executive function score" //Executive Function (only memory + impulse control)
sum EF1, detail 

gen EF1nostop= (pct_correct_memory + pct_correct_IC_nostop)/2
replace EF1nostop=. if pct_correct_memory==. & pct_correct_IC_nostop==.
label var EF1nostop "EF1 with no stop rule"  //Executive Function (no stop rule applied)
sum EF1nostop, detail 

gen EF2= (pct_correct_memory + pct_correct_IC_nostop + pc_correct_kt)/3
replace EF2=. if pct_correct_memory==. & pct_correct_IC_nostop==. & pc_correct_kt==.
label var EF2 "All EF tests" //All EF tests
sum EF2, detail 

****************************Total sum scores************************************
//Total IDELA score//
gen idela_total1 = (motor1 + emergentlit + emergentnum + socioemotion)/4
replace idela_total1 =. if motor1==. & emergentlit==. & emergentnum==. & socioemotion==. 
label var idela_total1 "Total % score on IDELA (All 4 domains)"
sum idela_total1, detail

/*
gen idela_total1_1 = (motor1 + emergentlit + emergentnum1 + socioemotion)
replace idela_total1_1 =. if motor1==. & emergentlit==. & emergentnum1==. & socioemotion==. 
label var idela_total1_1 "Total score on IDELA (All 4 domain - emergentnum1)"
sum idela_total1_1, detail
*/
gen idela_total2= (motor2+ emergentlit + emergentnum + socioemotion)/4
replace idela_total2=. if motor2==. & emergentlit==. & emergentnum==. & socioemotion==. 
label var idela_total2 "Total % score on IDELA--without gross motor"
sum idela_total2, detail

/*
gen idela_total2_2 = (motor2+ emergentlit + emergentnum1 + socioemotion)/4
replace idela_total2_2 =. if idela_total2_2==.
label var idela_total2_2 "Total score on IDELA--without gross motor--emergentnum1"
sum idela_total2_2, detail, if idela_total2_2!=.
*/

*Tabulate*
estpost tabstat motor1 motor2 emergentlit emergentnum socioemotion ///
	 idela_total1 idela_total2, ///
    stat(n mean median iqr min max)


********************************Generate standardized scores********************
*****************************Domains scores standardization*********************

egen z_motor1 = std(motor1) //Gross & fine motor development
egen z_motor2 = std(motor2) //Only fine motor development
egen z_emergentlit = std(emergentlit) //Emergent literacy
egen z_emergentnum = std(emergentnum) //Emergent numeracy (excluding Not attempted)

/*egen z_emergentnum1 = std(emergentnum1) //Emergent Numeracyy (NAs set to 0)
*/
egen z_socioemotion = std(socioemotion) //Socio-emotional

egen z_EF1 = std(EF1) //Executive Function (only memory + impulse control)
egen z_EF1nostop = std(EF1nostop) //Executive Function (no stop rule applied)
egen z_EF2 = std(EF2) //All EF tests

egen z_idela_total1 = std(idela_total1)
replace z_idela_total1=. if idela_total1==.
/*
egen z_idela_total1_1 = std(idela_total1_1)
replace z_idela_total1_1 =. if idela_total1_1==.
*/
egen z_idela_total2 = std(idela_total2)
replace z_idela_total2 =. if idela_total2==.
/*
egen z_idela_total2_2 = std(idela_total2_2)
replace z_idela_total2_2=. if idela_total2_2==.
*/

*Tabulate*
estpost tabstat z_motor1 z_motor2 z_emergentlit z_emergentnum z_socioemotion ///
	 z_idela_total1 z_idela_total2, ///
    stat(n mean median iqr min max)
esttab ., ///
    cells("count mean p50 iqr min max") ///
    nomtitle nonumber

/*Checking distribution visually
twoway histogram z_motor1, ///
    freq start(-4) width(0.5) ///
    lcolor(black) lwidth(medthick)

twoway histogram z_motor2, ///
    freq start(-4) width(0.5) ///
    lcolor(black) lwidth(medthick)
	
twoway histogram z_emergentlit, ///
    freq start(-4) width(0.5) ///
    lcolor(black) lwidth(medthick)

twoway histogram z_emergentnum, ///
    freq start(-4) width(0.5) ///
    lcolor(black) lwidth(medthick)
	
twoway histogram z_socioemotion, ///
    freq start(-4) width(0.5) ///
    lcolor(black) lwidth(medthick)

twoway histogram z_idela_total1, ///
    freq start(-4) width(0.5) ///
    lcolor(black) lwidth(medthick)
twoway histogram z_idela_total2, ///
    freq start(-4) width(0.5) ///
    lcolor(black) lwidth(medthick)
*/	

/* 

ssc install table1_mc
table1_mc, ///
vars(pct_correct_pa cont)

*/
**************save the IDELA T1 scores (no ITR)*********************************
save "idela_t1_scored.dta", replace
********************************************************************************
log close
