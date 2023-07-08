# Stata-fellows

*Materials for Stata introductory course for Cleveland Clinic Children's fellows*

## purpose

a central location for materials related to the introductory Stata course at Cleveland Clinic. All course materials are accessible here. 

## orientation to Github

at the basic level, one can use Github like I'm doing so here. I can upload materials and anyone can download them to their computers. Because MedHub wouldn't support uploads of Stata file types (.dta, .do) I needed somewhere to put the materials that would be easy to access. 

at a higher level, Github is useful for collaborating on projects and version control. Jenny Bryan has some [great resources](https://pages.github.com/) explaining Github. 

note that to use this site properly, some knowledge of Stata files is useful. We especially want to know what Stata certain file extensions mean. 

- **.dta** files indicate a dataset that can be pulled up directly in Stata
- **.do** files are batched code that you can run on your own machine to directly reproduce the results we got in class. You will have to adjust the code slightly to designate particulars of your computer set up; for example, indicate where your working directory is (as opposed to mine).
- **.log** files are output files. Whereas a do file just has code only, a log file has the code + results (with the exception of graphics.) 
 
## session 1 - introduction and basics

first session deals with a general overview of what Stata is and can do. We'll look at **two data sets**:

- *auto.dta* - this is a preloaded teaching data set that comes installed with Stata.
- *SarahsSTATAtest.dta* - this is a Stata file that has been created by [Sarah Worley](https://www.linkedin.com/in/sarah-worley-bba82816/) and [Wei Liu](https://www.linkedin.com/in/wei-liu-2ab97b156/) for purposes of this course. This file contains completely made up data - there are no patient privacy concerns. 

we'll look at one do file, *introduction and basics.do*

there is one log file, *introduction and basics.log*

additionally, Stata has some nice materials taking the user through the auto.dta data set that I shamelessly reused for purposes of our first session. For more on this, pull *getting_started_auto.pdf*. It explains each line of code and provides visual examples of how to access relevant commands via the drop-down boxes (something I don't always remember to do.) 


