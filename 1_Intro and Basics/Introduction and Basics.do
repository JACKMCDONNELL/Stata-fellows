log using "/Users/johnmcdonnell/Desktop/Stata fellow training/Introduction and Basics.log", replace


* Stata: Introduction and Basics
* reference: Getting Started with Stata (Mac) - gsm.pdf


* set working directory

cd "/Users/johnmcdonnell/Desktop/Stata fellow training"

* open a sample file

sysuse auto, clear

* examine the file, how is this dataset constructed?

describe

* looks like there is a note in there, what is this all about?

notes

browse

summarize

* what if you want to learn more about a particular variable?

codebook price

codebook make

codebook rep78 /* what does this "." mean? */

* drilling down missing data

browse if missing(rep78)

list make if missing(rep78)

* lets look deeper at the "price" variable

summarize price, detail

list if price > 13000

* what about variables that are categorical - yes/no, foreign/domestic, etc

tabulate foreign

tabulate rep78 /* we don't really know, but we'll assume that 1 is a poor repair record and 5 is good */

* what about repair record for foreign versus domestic cars?

tabulate rep78 foreign
tabulate rep78 foreign, row
tabulate rep78 foreign, col

* what if you want to examine a continuous variable by category?

by foreign, sort: summarize mpg

* simple hypothesis testing

ttest mpg, by(foreign)

* what if we are not sure we want this type of t test?

help ttest

* descriptive statistics: correlation matrices

correlate mpg weight

by foreign, sort: correlate mpg weight

* simple graphics 

twoway (scatter mpg weight)

twoway (scatter mpg weight), by(foreign, total)


* simple regression modelling

* from the graphs, we want to fit a regression model predicting MPG from the weight and type of car
* we have reason to think that this may not be a linear relationship, and may be better to consider weight as a quadratic

generate wtsq = weight ^ 2

list weight wtsq in 1/10

regress mpg weight wtsq foreign

* what if we want to plot the predicted values on top of the scatterplots for each of the origins of cars

predict mpghat

twoway (scatter mpg weight) (line mpghat weight, sort), by(foreign)


generate gp100m = 100/mpg
label variable gp100m "Gallons per 100 miles"
twoway (scatter gp100m weight), by(foreign, total)

regress gp100m weight foreign

********************************************************************************************************************************

use SarahsSTATAtest, clear

* overall description
describe

* look at continuous variables. notice how the command doesn't really know how to deal with character variables
summarize 

* so, what do these character variables really look like?
browse

codebook
* what are potential problems with how this is set up?


	* PROBLEM 1: record_id is a numeric

summarize record_id, detail /* note that Stata is smart but not smart enough to save us from ourselves. If we want to do something stupid and meaningless like calculate percentiles for the record_id variable, it is only to happy to comply */

	* PROBLEM 2: mrn is a numeric. this is the same issue as record_id

	* PROBLEM 3: variables med___1 med___2 med___3 med___4 med___5 med___9. These variable names are uninformative (although the variable labels help us a little). 
	* Additionally, the value labels are a bit unhelpful as well. Who wants to see "Checked" and "Unchecked"?
	
* ALL of these problems have fairly easy solutions that we will come back to at a later class. For now, let's look into the data a bit more

summarize age
summarize age, detail

by gender, sort: summarize age_years

histogram age_years, by(gender)

tabulate overweight gender, row
tabulate overweight gender, col

* whats with this age > 12 variable? Is it correct?
list age_years age_gt_12

count if age_years <= 12 & age_gt_12 == "yes" /* our first error message, what happened? note that following the r(109) code gives us a clue*/

* note: some of Stata's most persnickety behavior comes from this issue, so it is worth getting into it further . . . 

codebook age_gt_12 /* the issue is that Stata really wants us to realize that this variable is really a 0/1 binary. It just happens to have a label corresponding to "yes" and "no". Stata takes the == VERY literally in this case */

tabulate age_gt_12
tabulate age_gt_12, nolabel

count if age_years <= 12 & age_gt_12 == 1 
count if age_years > 12 & age_gt_12 == 0 

by overweight,sort: summarize hemoglobin_a1c /* this doesn't seem right, does it? */

ttest hemoglobin_a1c, by(overweight)

capture log close



