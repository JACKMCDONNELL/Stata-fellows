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

## getting help in Stata

in addition to the resources on this course website, there are a number of places to get help using Stata. These include:

-Stata help files. To access, just type **help** (*command name*) in the command prompt of Stata. This only works if you remember the exact command name. Alternately, point your mouse to the "help" option in the Stata drop-down choices.

-if you remember the overall technique you want to use, but not the actual command name in Stata, type **search** (*overall technique*). This pulls information from Stata help files as well as internet sources

-google search. Often, it is just easier to type what you are trying to do and then the word "Stata" in the search bar. 

-[UCLA Stats](https://stats.oarc.ucla.edu/). Great source of information. 

-[Stata YouTube](https://www.youtube.com/@statacorp). Lots of great videos for Stata learners of every level. 

-[Statalist](https://www.statalist.org/). Great source of information and helpful people will answer your questions if you can put them intelligently. Best for questions that can't be addressed with the above methods. 

-[Stata bookstore](https://www.stata.com/bookstore/).

 
## session 1 - introduction and basics

first session deals with a general overview of what Stata is and can do. We'll look at **two data sets**:

- *auto.dta* - this is a preloaded teaching data set that comes installed with Stata.
- *SarahsSTATAtest.dta* - this is a Stata file that has been created by [Sarah Worley](https://www.linkedin.com/in/sarah-worley-bba82816/) and [Wei Liu](https://www.linkedin.com/in/wei-liu-2ab97b156/) for purposes of this course. This file contains completely made up data - there are no patient privacy concerns. 

we'll look at one do file, *introduction and basics.do*

there is one log file, *introduction and basics.log*

there is also one short power point, *introduction_basics_ppt.pptx*

additionally, Stata has some nice materials taking the user through the auto.dta data set that I shamelessly reused for purposes of our first session. For more on this, pull *getting_started_auto.pdf*. It explains each line of code and provides visual examples of how to access relevant commands via the drop-down boxes (something I don't always remember to do). 

## session 2 - data management

the second session deals with data management in Stata. 

we'll look at **two data sets**:

- *medical_specialty_toy_example* - a completely unbiased ranking of pediatric subspecialties that should be considered the gospel truth 
- *SarahsSTATAtest.dta* - fabricated RedCap data. 

we'll look at one do file, *data management.do*. Remember, this is the file that you can ultimately download to your computer and reproduce the analyses. To successfully do this, however, you will have to **change your working directory as detailed in the do file**. 

there is one log file, *data management.log*

there is also one short power point, *data_management.pptx*. This is a powerpoint you should check out, because I screen shot the exact process for data import and export in Stata. I figure you each will have to do this at some point. 

note that this session may feel a bit overwhelming. There was a lot of material to get through and not a lot of time to do so. Remember, the chief value in our sessions is to get used to the concept and figure out a resource for the code (the do file) so that when you have to do this yourself you have everything in place. So don't worry if you didn't get everything the first time. 

## session 3 - workflow

I took most of the materials for this from Chapter 10 of Michael Mitchell's book, *[Data Management Using Stata](https://www.stata.com/bookstore/data-management-using-stata/)*

the main do file is *3_workflow.do*. 

## session 4 - analysis

we are back to the main dataset we have been using so far - SarahsSTATAtest.dta

the do file is *analysis.do*. The log file is *analysis.log*

this do file generates a number of graphics that are saved as pdfs. The name of each is referenced in the do file.

this is the first session where we will be relying heavily on user-written commands (ssc install) 

there were a couple of questions people had in class that I had trouble answering on the spot. I've made slides (analysis mistakes.pptx) going over these, specifically:
 - accessing linear regression with two way factorials from the menu
 - changing the reference level in a regression

## session 5 - graphics

there were a couple of questions people had last week in class that I had trouble answering on the spot. I've made slides (analysis mistakes.pptx) going over these, specifically:
 - accessing linear regression with two way factorials from the menu
 - changing the reference level in a regression

For the graphics, we will be using material from the book [Data Analysis Using Stata: Third Edition](https://www.stata.com/bookstore/data-analysis-using-stata/), specifically the chapter on graphics.

the do file is *5_graphics.do*. The log file is *graphics.log*

this do file generates a number of graphics. To see them you will have to actually run the program on your computer. 


