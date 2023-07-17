pwd
cd "/Users/johnmcdonnell/Desktop/Stata fellow training/workflow files"

* source: Data Management Using Stata: A Practical Handbook, Chapter 10
* author: Michael N. Mitchell
* EXECUTING DO FILES

type example1.do /* to see what is inside a do file you have made */

do example1.do /* to actually run the do file */

doedit 3_workflow

* perhaps one thing that isn't great about this do file is the fact that it does not save the results permanently. 
* we can permanently save the results using a log file 
* the difference between do files and log files is that do files save code, log files save results

type example2.do

do example2.do

type example2.smcl

* or, perhaps even better . . . 

view example2.smcl

* smcl stands for Stata Markup and Control Language. If I am creating a log file for myself, I use this format. If I care about creating a log file to show someone who doesn't use Stata, however, I translate to plain text (.log)

type example3.do 

do example3

type example3.log

* if we want to directly create a log file, instead of using the translate command, it is easy. 

log using example3.log, replace /* I had to use the ,replace because Stata refuses to overwrite my previously created log file unless I do */
use wws2, clear
summarize age wage hours
tabulate married
log close

view example3.log

* there is also a way to generate a PDF file from a SMCL file

* first, some fancy (and not strictly necessary) code to set PDF in dimensions of legal paper in landscape mode (14" by 8.5")
translator set smcl2pdf pagesize custom
translator set smcl2pdf pagewidth 14
translator set smcl2pdf pageheight 8.5

translate example2.smcl example2.pdf, replace /* now we can go to the working directory and look at this pdf - example2.pdf */

* AUTOMATIC DATA CHECKING

* we know how to look at variables to make sure that they make sense manually. There are some nice features to automate this process

import delimited using wws.csv, clear

tabulate race /* we look at race, which was supposed to be coded as 1, 2, or 3. The choice 4 was not supposed to be an option. note that if you are just running do files without looking closely, you might miss this mistake */

// assert inlist(race,1,2,3) 
* an advantage to running this in a do file is the false assertion will stop the do file entirely and force us to confront the reality that the data are not coded the way we expected

* from this false assertion, we know there is 1 observation that failed the assertion, but we don't know which one. Below we can zoom in on this observation

list idcode race age married if !inlist(race,1,2,3)

* we could fix this if we like, either directly in RedCap or in Stata. I prefer the second method, because there is a record of what I did in the do-file, but if you are doing a project with multiple other people or using data that future researchers might use the first method is preferred. 

* if we fix it in Stata, it is good to include annotated code for who made the fix and when

import delimited using wws.csv, clear
replace race = 1 if idcode == 543 // Data entry error, fixed by JM 7/13/23 
assert inlist(race,1,2,3) // note that the assertion is true this time 

* if we want to check another variable . . . 

// assert (age >= 21) & (age <= 50)

list idcode age if ! ((age >= 21) & (age <= 50))

* we could then go and fix this pretty easily

replace age = 38 if idcode == 51 // Data entry error, fixed by JM 7/13/23
replace age = 45 if idcode == 80 // Data entry error, fixed by JM 7/13/23
assert (age >= 21) & (age <= 50)

* COMBINING DO FILES

type mastermini.do
type mkwwsmini.do /* look at some of these commands. What does "version" do? What does "capture" do? */
type anwwsmini.do

do mkwwsmini
do anwwsmini

* an adjunct to this nested do file approach is to make better use of the project manager

* STATA MACROS

* if you find yourself doing the same thing over and over, it may be helpful to use a macro

use wws2, clear
regress wage age married
regress hours age married

* it is ok typing this twice, but what if we were doing it 10+ times

use wws2, clear
local preds age married /* makes a local macro called "preds" containing the words age and married */
regress wage `preds'

* now, not so much typing. All we did was make a stand-in for "age and married" called preds

local preds age married 
display "The contents of preds is `preds'"

* note: you need `' to call this macro

* if we want to overwrite a macro it is easy:
local preds age married currexp
regress wage `preds'
regress hours `preds'

* we can use a macro for anything. here we will make one for regression options that we like - in this case - standardized regression coefficients and no header

local preds age married currexp
local regopts noheader beta
regress wage `preds', `regopts'

* note that these are "local" macros. They cease to exist when the current do file is exercised. that's why I have to keep typing them in again. 
* an alternative is a "global" macro, which will keep living as long as a Stata session is running 

* LOOPING OVER VARIABLES AND NUMBERS

* sometimes it is useful to loop over things, to avoid typing
* note: in real life you don't want to just mindlessly run models like this

regress wage age married
regress hours age married
regress prevexp age married
regress currexp age married
regress yrschool age married
regress uniondues age married

* vs. 

foreach y of varlist wage hours prevexp currexp yrschool uniondues {
	regress `y' age married
}

* you can go even crazier if you want with nested loops

use wws2, clear
foreach y of varlist wage hours prevexp currexp yrschool uniondues {
	foreach x of varlist age married south metro {
		regress `y' `x'
	}
}

* you can use foreach loops with data management tasks, too 

use cardio1, clear
describe

* want to create an indicator variable for bp high (130 or over)
recode bp1 (min/129=0) (130/max=1), generate(hipb1)
recode bp2 (min/129=0) (130/max=1), generate(hipb2)
recode bp3 (min/129=0) (130/max=1), generate(hipb3)
recode bp4 (min/129=0) (130/max=1), generate(hipb4)
recode bp5 (min/129=0) (130/max=1), generate(hipb5)

* it is faster as 

foreach v of varlist bp1 bp2 bp3 bp4 bp5 {
	recode `v' (min/129=0) (130/max=1), generate(hi`v')
}

* you can also loop over numbers

use gaswide, clear
list

* gives data from four contries with price of gas per gallon from 1974 to 1976, with measures of inflation to bring into today's dollars

* if we want the price of gas in 1974 translated into today's dollars

generate gascur1974 = gas1974 * inf1974

* similarly

generate gascur1975 = gas1975 * inf1975
generate gascur1976 = gas1976 * inf1976

drop gascur*

* this gets old, however

foreach yr of numlist 1974/1976 {
	generate gascur`yr' = gas`yr' * inf`yr'
}


