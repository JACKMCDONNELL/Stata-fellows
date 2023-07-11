log using "/Users/johnmcdonnell/Desktop/Stata fellow training/Data Management.log", replace


* Stata: Data Management

* set working directory - always the first step!

pwd /* print working directory */

cd "/Users/johnmcdonnell/Desktop/Stata fellow training"

************************************************************** READING AND IMPORTING DATA FILES
********************* importing an Excel file - see slides for screen shots

import excel "/Users/johnmcdonnell/Desktop/Stata fellow training/medical specialty toy example.xlsx", sheet ("Sheet1") firstrow case(lower) clear

save medical_specialty_toy_example, replace

browse

********************** importing a Redcap file - more common for CCF users

clear

do SarahsSTATATest_STATA_2023-07-11_1125 /* this is the "do file" we downloaded from Redcap. */

*note that you can nest do-files in other do-files. Here I told Stata to do the file we downloaded. This only works if they are in the same working directory. 

*otherwise, you have to provide a full file path "/Users/You/Desktop/Whatever", etc


************************************************************** EXPORTING DATA FILES
export excel using "/Users/johnmcdonnell/Desktop/Stata fellow training/export_test.xls", replace /* probably simpler to use the export menu option */

************************************************************** MANIPULATING AND CLEANING DATA

use SarahsSTATAtest, clear

* code I used to deliberately mess up Sarah and Wei's data, so that we could talk about strategies for cleaning messy data. You can mostly ignore everything from here to line 69

replace age_years = -5 in 15
replace hemoglobin_a1c=20 in 7
replace non_hdl_cholesterol=300 in 2
replace bp_ord = 4 in 1/50
tostring age_years, generate(age_years_str)
replace age_years_str = " " + age_years_str in 1/60
replace age_years_str = age_years_str + " " in 61/l
replace age_years_str = "unknown" in 5
replace age_years_str = "fifteen" in 100
replace mrn=. in 120
replace hemoglobin_a1c=. in 30/35
replace bp_ord = . in 30/35
replace gender = . in 20/25
generate random_date = /// 
floor((mdy(12,31,2023)-mdy(12,1,2020)+1)*runiform() + mdy(12,1,2020))
generate random_date_1 = /// 
floor((mdy(12,31,1900)-mdy(12,1,1800)+1)*runiform() + mdy(12,1,1800))
expand 2 if !missing(mrn)

************************ quick review of session 1 key commands

describe
summarize
codebook
tabulate med___1
tab1 med* /* if I want a tabulation of all the variables that start with "med" */

********************** looking for duplicates

duplicates report /* this works because all variables are duplicated here */

duplicates report mrn /* this might be more realistic. Here, we ask Stata to count duplicates in terms of MRN only. */

duplicates list mrn, nolabel sepby(mrn)

duplicates drop /* key command for getting rid of duplicates */

duplicates report

browse

********************** checks for data integrity, do the numbers make sense? a useful check for this is the SUMMARIZE command

* continuous variable integrity

summarize age_years hemoglobin_a1c non_hdl_cholesterol /* do these ranges make sense? */

* categorical variable integrity

tabulate bp_ord, plot /* does this breakdown of blood pressures make clinical sense?*/

**********************  converting data to an ANALYZABLE FORMAT

summarize age_years_str /* why can't Stata give us a summary of these ages? */

codebook age_years_str /* it turns out that Stata treats "string" variables as characters and doesn't do math on them, even if the strings are just numbers */
* note the warning here after the codebook command

* Stata has a command for making string variables numeric (see "help destring") and vice versa (see "help tostring")

* lets try to destring this so Stata can analyze the ages

destring age_years_str, replace /* no dice, what happened?*/

list age_years_str

* the issue is that there are some illegal characters blocking Stata from destringing. Stata would like to make a numeric variable but can't because of "unknown" and "invalid" 

* the fix for this isn't difficult, but does require a little knowledge of Stata coding

replace age_years_str = "15" if age_years_str=="fifteen" /* whats with this ==? Stata uses that as a coding equivalent to the word "is", where as the "=" just indicates assigning a new value */

replace age_years_str = "" if age_years_str=="unknown"

*note that forgetting the == issue will result in an error message, like below:
// replace age_years_str = "" if age_years_str="unknown"

destring age_years_str, replace /* now that we have gotten rid of illegal characters (nonnumerics) the command will work*/

summarize age_years_str /* however, we forgot to fix the -5 age from before. Perhaps we go into Epic and verify the age is actually 5 */
replace age_years_str=5 if age_years_str==-5 /* note the slight change of syntax. Because string variables are characters, Stata requires quotations around them. No quotations are allowed for numerics */

*  if we try this, it won't work because Stata now recognizes age_years_str as a numeric, not a string  
// replace age_years_str="5" if age_years_str=="-5"

* this may seem arcane and technical, but a lot of the misery of data cleaning comes from issues like this. Luckily, Redcap does help us out by only letting users fill in data with predetermined formats. So, it shouldn't even be possible for the user to put in "fifteen" instead of "15" if the Redcap is set up correctly

********************** generating indicator/dummy variables

* there will be times where the user might want to generate an indicator variable (0/1). For example, maybe we want a variable to look specifically at subjects with multiple metabolic risk factors. We accomplish this with the "generate" command and appropriate "if" statements

generate multiple_metabolic_risk = 0 /* create a new numeric variable in everyone */
replace multiple_metabolic_risk = 1 if overweight == 1 & hemoglobin_a1c >= 5.7 & bp_ord >= 2

* now we have a variable corresponding to 0 in subjects without multiple metabolic risk factors, and 1 in subjects with these risk factors

* we could then look at these subjects specifically

browse if multiple_metabolic_risk == 1

* note that Stata will accept many different variations of "if" statements --> >, <, >=, <=, !=, ==, missing() 
* for example:

list mrn if age_years > 10
list bp_ord if hemoglobin_a1c < 5
browse if gender != 0 
browse if missing(mrn)

********************** missing values

* as mentioned before, Stata indicates missing values as a "." for numerics, for strings missingness will be indicated by "" 

* it is important to keep a close eye on missing values, because Stata will often pretend that they don't exist. This is annoying

* for example:

count 
summarize /* look specifically at hemoglobin_a1c here, although others have missing data, too. The fact that there are 114 observations here is our only clue that something is potentially wrong */

inspect hemoglobin_a1c /* we get a little more detail if we use the "inspect" command */

* in fact, I sometimes just use "inspect" by itself (as opposed to putting a variable name by it) to look at all the variables in the dataset

inspect

* you need to look at missingness in categorical variables, too. it looks like we are missing some data in bp_ord and gender

* the missing data may not be obvious if we run this command:

tabulate bp_ord
tabulate gender

* we may have to actually remember that the complete data set has 120 observations to realize there is missingness here. If we type this instead:

tabulate bp_ord, missing
tabulate gender, missing

* it becomes easier to see

* note that we can look at missingness for cross-tabulations, where we are comparing two variables together

tabulate bp_ord gender /* in this case our number of has decreased considerably to 108. This is because the cross-tab is only including patients with complete data in both bp_ord and gender. We may MISS this if we aren't paying attention (pun intended) */

* it is much easier to see what is going on if we type this instead:

tabulate bp_ord gender, missing

* personally, I find the missing data in tables to be the biggest issue when it comes time to complete a "table 1", and things aren't adding up properly

* in general, for most of the research you will be doing here, it is probably better to just note the missing data and/or go into Epic and figure out what is missing (if possible)

* however, be aware that Stata has a number of more sophisticated methods for dealing with this issue, including multiple imputation. You should see a statistician for help with this


********************** intelligent labeling of variables

describe

* one issue we brought up in session 1 was the noninformative labelling of the med___ variables

* however, because RedCap allowed us to import the labels right into Stata, we can at least see what these variables are supposed to mean

describe med* /* hot tip: if you apply the "*" after a variable name, it will give you every variable that starts with those letters */

rename med___1  ACEi
rename med___2  ARB
rename med___3  CCB
rename med___4  BB
rename med___5  AB
rename med___9  Other_antihypertensive

describe ACEi ARB CCB BB AB Other_antihypertensive /* this looks better, but I hate the variable labels on the right */

label variable ACEi "patient on ACE inhibitor"
label variable ARB "patient on angiotensin receptor blocker"
label variable CCB "patient on calcium channel blocker"
label variable BB "patient on beta blocker"
label variable AB "patient on alpha blocker"
label variable Other_antihypertensive "patient on other antihypertensive"

describe ACEi ARB CCB BB AB Other_antihypertensive /* this looks much better */

tab1 ACEi ARB CCB BB AB Other_antihypertensive /* however, our data still looks messy. a lot of this has to do with the "checked" v "unchecked" distinction from RedCap */
* hot tip: putting tab1 followed by a list of variables enables you to get serial tabulation commands

/* so, */ tab1 ACEi ARB CCB BB AB Other_antihypertensive /* is equivalent to the following: */

tab ACEi 
tab ARB
tab CCB
tab BB
tab AB
tab Other_antihypertensive

* note also: I'm getting lazy and starting to abbreviate command names. You can do this, too, so long as you include sufficient characters for Stata to recognize a unique command

* hot tip: Stata will tell you the minimum number of characters required for a given command in the help section for that command. Look for what is underlined for the commands

help describe

d
su
ins

* there may be benefit to typing more of the command out, however, especially if you are new to Stata and forget what the abbreviations mean!

* turning back to these ugly labels

labelbook /* direct command to see all the labels in your data */

* simpler alternative: use the menu. Personally, I normally use the menu for label issues and graphics as opposed to free texting. Notice that whether you use the menu or not, Stata still gives you the code in the Command History box. 

* in this case, follow Data > Data utilities > Label utilities > Manage value labels

label drop med___1_
label drop med___2_
label drop med___3_
label drop med___4_
label drop med___5_
label drop med___9_

tab1 ACEi ARB CCB BB AB Other_antihypertensive 

* rechecking our data cleaning process so far:

describe record_id-my_first /* the only thing I see that I don't really like is the my_first_instrument_complete variable, which is incomplete for everyone. So, we know that this variable is not adding any value to our analysis */

drop my_first_instrument_complete

describe record_id-htn_relative


********************** dates in Stata 

* before we conclude, lets have a brief word about how Stata handles dates. Warning: it is kind of vexxing (but so are the other statistical programs out there)

list random_date /* we seem to have dates in here, but they don't make sense. This is because the dates are not in a "human readable format" */

* it turns out that Stata stores dates as the number of days from January 1, 1960. This is completely arbitrary, however computationally useful because it makes it easier to do fast math with the dates. 

* it is RELATIVELY easy to convert these to dates we can understand, but it requires a trip to the help files. Even for me. Every. Single. Time.

gen random_date_intelligible = random_date
format random_date_intelligible %td

list random_date random_date_intelligible in 1/10

* this makes the dates make much more sense, although all that has changed is the format Stata uses to present the date to our eyes. The actual data are encoded as dates from January 1, 1960, as before. 


* there is a whole lot more to say about dates but not at this point. For now, it is just important to remember that there is a way to deal with dates in Stata. 

* what if I want to make a variable corresponding to the number of days between two date variables, random_date and random_date_1? it is easy

generate delta_date = random_date-random_date_1

list random_date_1 random_date delta_date

* if I am not a computer, I may prefer the following

format random_date %td
format random_date_1 %td

list random_date_1 random_date delta_date

* note that we still don't have delta_date in a format that is immediately accessible, because it is giving us the number of days in between the two points in time. We may find it easier to think in terms of years. 

replace delta_date = floor(delta_date/365.25) /* no one here is expected to come up with this code on their own */

list random_date_1 random_date delta_date /* looks better */


********************** putting it all together (plus a bit more), and assuming we went back to the data and figured the missing valuees we are left with the following:

use SarahsSTATAtest, clear

notes: these data were downloaded from RedCap on July 11, 2023
notes

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

drop my_first_instrument_complete

describe

capture log close



