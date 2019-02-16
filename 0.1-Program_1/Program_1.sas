
/*********************example_1**************************/
Data Parts;
input machine Deviation @@;
datalines;
1 -.0653 1 0.0141 1 -.0702 1 -.0734 1 -.0649 1 -.0601
2 -.0631 2 -.0148 2 -.0731 2 -.0764 2 -.0275 2 -.0497
1 -.0741 1 -.0673 1 -.0573 1 -.0629 1 -.0671 1 -.0246
2 -.0222 2 -.0807 2 -.0621 2 -.0785 2 -.0544 2 -.0511
1 -.0138 1 -.0609 1 0.0038 1 -.0758 1 -.0731 1 -.0455
;
proc univariate data= Parts noprint;
title "Histogram";
Histogram Deviation /normal midpoints=-0.10 to 0.03 by 0.01;
inset skewness = "Skew" (4.2)
	Kurtosis= "Kurtosis" (4.2)/
		Pos=NE
		Height=4;
run;


/*********************import_excel**************************/
DATA inclass;
proc Import out=testfile datafile="/folders/myfolders/data/dataexample.xls" DBMS=xls replace;
sheet="Data";
Getnames=yes;
run;
proc print;
title "import Excel";
run;

/*********************maze_time**************************/
DATA MAZETIME;
INPUT SUBJECT$ 1-4 SEX$ 5 AGE 6-9 TIME 10-11;

DATALINES;
B324M12.571
A712M13.773
H308M13.168
C119F13.375
;
/*PROC SORT;
BY SEX;*/
PROC PRINT DATA=MAZETIME;
Title "Maze Time";
ID Subject;
RUN;

/*********************Program_1_**************************/
DATA program_1_;
/* 
----INITIAL VARIABLES---------------------------
SUBJ 	 -> Subject Number			(Character)
HEIGHT	 -> Height in inches		(Numeric)
WT_INIT	 -> Initial weight in lbs	(Numeric)
WT_FINAL -> Final weight			(Numeric)
------------------------------------------------
*/

input SUBJ$ 1-3 HEIGHT 4-5 WT_INIT 6-8 WT_FINAL 9-11;/*create input variables*/

/*
----CALCULATIONS---------------------------------
BMI_INIT = WT_INIT/((HEIGHT)^2)(BMI stands for body mass index)
BMI_FINAL = WT_FINAL/((HEIGHT)^2)
BMI_DIFF = (BMI_FINAL - BMI_INIT)
WT_kg = (WT_INIT/2.2)
HEIGHT_m = 0.0254Ã—(HEIGHT_in)   
--------------------------------------------------
*/

WT_INIT_kg = (WT_INIT/2.2);
WT_FINAL_kg = (WT_FINAL/2.2);
HEIGHT_m = 0.0254*(HEIGHT);
BMI_INIT = WT_INIT_kg/((HEIGHT_m)**2);/*BMI_INIT in kg/m*/
BMI_FINAL = WT_FINAL_kg/((HEIGHT_m)**2);
BMI_DIFF = BMI_FINAL-BMI_INIT;

drop WT_INIT WT_FINAL WT_INIT_kg WT_FINAL_kg HEIGHT_m ;/*drop convertions output*/

/*DATA INPUT*/
Datalines;
00768155150
00272250240
00563240200
00170345298
;
proc sort;
by SUBJ;*SORT by SUBJ variable;
title "Body Mass Index Calculation";
proc print noobs;*No Observations;
Run;

/*********************program_1_2a**************************/
DATA program_1_2a;
/*
----FILE INFO-----------
FILE: MilitaryService.txt
DATA ORDER: Last Name/First Name/Sex/Military Branch/Years of Service
------------------------
*/
infile "/folders/myfolders/data/militaryservice.txt" dlm='/';*Open and external file militaryservice.txt;
input LAST_NAME$ FIRST_NAME$ GENDER$ MILITARY_BRANCH$ YEARS_IN_SERVICE;*input variables;
proc print;*print all the data from the external file;
title "Military Service List";
run;

/*********************Program_1_2b**************************/
DATA problem_1_2b;
/*
----FILE INFO-----------
FILE: MilitaryService.txt
DATA ORDER: Last Name/First Name/Sex/Military Branch/Years of Service
------------------------
*/
infile "/folders/myfolders/data/militaryservice.txt" dlm='/';
input LAST_NAME$ FIRST_NAME$ GENDER$ MILITARY_BRANCH$ YEARS_IN_SERVICE;
proc sort data=problem_1_2b;
by MILITARY_BRANCH;*Sort the data by the military branch;
proc print data=problem_1_2b;
title "Military Service List";
var LAST_NAME GENDER YEARS_IN_SERVICE;*Print the data with the last name , gender and years served;
ID MILITARY_BRANCH;*military branch as the identifier;
by MILITARY_BRANCH;*print by military branch;
sum YEARS_IN_SERVICE;*Sum the years of service for each department;
run;

/*********************Program_1_2c**************************/
DATA problem_1_2c;
/*
----FILE INFO-----------
FILE: MilitaryService.txt
DATA ORDER: Last Name/First Name/Sex/Military Branch/Years of Service
------------------------
*/
infile "/folders/myfolders/data/militaryservice.txt" dlm='/';
input LAST_NAME$ FIRST_NAME$ GENDER$ MILITARY_BRANCH$ YEARS_IN_SERVICE;
proc sort data=problem_1_2c;
by MILITARY_BRANCH;*Sort the data by the military branch;
proc print data=problem_1_2c;
title "Military Service List by Branch of Service";
var LAST_NAME GENDER YEARS_IN_SERVICE;*Print the data with the last name , gender and years served;
ID MILITARY_BRANCH;*military branch as the identifier;
by MILITARY_BRANCH;*print by military branch;
proc means;
var YEARS_IN_SERVICE;*Find the average number of years served for each military branch;
run;

/*********************Program_1_2d_i**************************/
DATA problem_1_2d_i;
/*
----FILE INFO-----------
FILE: MilitaryService.txt
DATA ORDER: Last Name/First Name/Sex/Military Branch/Years of Service
------------------------
*/
infile "/folders/myfolders/data/militaryservice.txt" dlm='/';
input LAST_NAME$ FIRST_NAME$ GENDER$ MILITARY_BRANCH$ YEARS_IN_SERVICE;*create input variables;
proc sort data=problem_1_2d_i;
by MILITARY_BRANCH;*Sort the data by the military branch;
proc print data=problem_1_2d_i;
where YEARS_IN_SERVICE>=10 ;*select observations that meet the condition specified;
title "Military Service List";
var LAST_NAME GENDER YEARS_IN_SERVICE;*Print the data with the last name , gender and years served;
ID MILITARY_BRANCH;*military branch as the identifier;
run;

/*********************Program_1_2_d_ii**************************/
DATA problem_1_2d_ii;
/*
----FILE INFO-----------
FILE: MilitaryService.txt
DATA ORDER: Last Name/First Name/Sex/Military Branch/Years of Service
------------------------
*/
infile "/folders/myfolders/data/militaryservice.txt" dlm='/';
input LAST_NAME$ FIRST_NAME$ GENDER$ MILITARY_BRANCH$ YEARS_IN_SERVICE;*create input variables;
proc sort data=problem_1_2d_ii;
by MILITARY_BRANCH;*Sort the data by the military branch;
proc print data=problem_1_2d_ii;
where YEARS_IN_SERVICE >=5 and YEARS_IN_SERVICE<10;*select observations that meet the condition specified >=5 & <10;
title "Military Service List";
var LAST_NAME GENDER YEARS_IN_SERVICE;*Print the data with the last name , gender and years served;
ID MILITARY_BRANCH;*military branch as the identifier;
run;

/*********************Program_1_2_d_iii**************************/
DATA Problem_1_2_d_iii;

/*
---- SET FILE INFO-----------
FILE: problem_1_2c.sas
DATA ORDER: LAST_NAME GENDER YEARS_IN_SERVICE
------------------------
*/
set PROBLEM_1_2C;*read rows and columns from problem_1_2C table;
if MILITARY_BRANCH="Marines";*Only those rows whose value of MILITARY_BRANCH is Marines are output to the new table ;
proc print;
TITLE "MILITARY SERVICE MARINES LIST";
run;


