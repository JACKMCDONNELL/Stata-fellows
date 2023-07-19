log using "/Users/johnmcdonnell/Desktop/Stata fellow training/analysis.log", replace


* Stata: analysis

* set working directory - always the first step!

pwd /* print working directory */

cd "/Users/johnmcdonnell/Desktop/Stata fellow training"

use SarahsSTATAtest, clear /* version up to date as of July 12, 2023 */

rename med___1  ACEi
rename med___2  ARB
rename med___3  CCB
rename med___4  BB
rename med___5  AB
rename med___9  Other_antihypertensive


label variable ACEi "patient on ACE inhibitor"
label variable ARB "patient on angiotensin receptor blocker"
label variable CCB "patient on calcium channel blocker"
label variable BB "patient on beta blocker"
label variable AB "patient on alpha blocker"
label variable Other_antihypertensive "patient on other antihypertensive"


label drop med___1_
label drop med___2_
label drop med___3_
label drop med___4_
label drop med___5_
label drop med___9_


* 1. suppose you have a clinical question - does the poor control of diabetes predict non-HDL cholesterol after adjusting for weight

* outcome variable non-HDL cholesterol (non_hdl_cholesterol)
* study variable A1C (hemoglobin_a1c)
* confounding variable overweight (overweight)

twoway (scatter non_hdl_cholesterol hemoglobin_a1c) // scatter 1

twoway (scatter non_hdl_cholesterol hemoglobin_a1c), by(overweight) // scatter 2

* simple statistics

corr hemoglobin_a1c non_hdl_cholesterol

graph box non_hdl_cholesterol, by(overweight) // box 1
ttest non_hdl_cholesterol, by(overweight)

graph box hemoglobin, by(age_gt_12) // box 2
ttest non_hdl_cholesterol, by(age_gt_12) /* this seems important */
ranksum non_hdl_cholesterol, by(age_gt_12)

tab overweight age_gt
tab overweight age_gt, chi

* linear regression models

regress non_hdl_cholesterol hemoglobin_a1c overweight

regress non_hdl_cholesterol hemoglobin_a1c ib0.overweight /* uses overweight==0 as the reference level */
regress non_hdl_cholesterol hemoglobin_a1c ib1.overweight /* uses overweight==1 as the reference level */


* does this association differ between younger and older children?

regress non_hdl_cholesterol i.overweight i.age_gt_12##c.hemoglobin_a1c /* note: I am specifying hemoglobin_a1c as a continuous variable */

twoway (scatter non_hdl_cholesterol hemoglobin_a1c), by(age_gt_12) /* you can see the interaction here */ // scatter 3

* margins

margins age_gt, at(hemoglobin_a1c=(6(0.5)15)) vsquish

marginsplot // margins 1

* 2. suppose you owant to evaluate whether overweight patients are more likely to have elevated BP and/or be treated with antihypertensive medication

* what do we consider elevated BP?

tab bp_ord
tab bp_ord, nolabel

recode bp_ord (min/1=0) (2/max=1), generate(bp_elevated)

tab bp_ord bp_elevated /* sanity check */

gen any_BP_med = 0 if bp_elevated==1
replace any_BP_med = 1 if ACEi==1 | ARB==1 | CCB==1 | BB==1 | AB==1 | Other_antihypertensive==1

table1_mc, by(overweight) ///
vars( ///
gender bin %4.0f \ ///
age_years conts %4.0f \ ///
hemoglobin_a1c conts %4.0f \ ///
bp_elevated cate %4.0f \ ///
any_BP_med bin %4.0f \ ///
) ///
nospace percent_n onecol missing total(before)

* if we don't like the medians

table1_mc, by(overweight) ///
vars( ///
gender bin %4.0f \ ///
age_years contn %4.0f \ ///
hemoglobin_a1c contn %4.0f \ ///
bp_elevated cate %4.0f \ ///
any_BP_med bin %4.0f \ ///
) ///
nospace percent_n onecol missing total(before)

* resource https://blog.uvm.edu/tbplante/2019/07/11/make-a-table-1-in-stata-in-no-time-with-table1_mc/

* modeling - logistic. looking at elevated BP as the outcome

logistic bp_elevated overweight non_hdl_cholesterol age_gt_12 /* do we believe these odds ratios? they seem high. Why is that? */

lroc /* gives C statistic */ // roc 1

// ssc install coefplot
coefplot /* note: we don't really trust this, do we? */ // coefplot 1

* modeling - logistic. looking at any_BP_med as the outcome

logistic any_BP_med overweight non_hdl_cholesterol age_gt_12 /* can you figure out why Stata is freaking out and dropping variables? */

capture log close


