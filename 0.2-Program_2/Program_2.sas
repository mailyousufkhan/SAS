/*********************Program_2_1a_**************************/
DATA PATIENT;
INPUT @1 ID$ 3. @4 GENDER$ 1. @5 RACE$ 1. @6 AGE 2.;

DATALINES;
001MW35
002FW41
003MB62
004FB38
005MW44
006FB47
007FW53
008MW58
009FB56
010FB39
;

PROC SORT DATA=PATIENT;
BY RACE;
PROC PRINT DATA=PATIENT;
TITLE "PATIENT";
RUN;

/*********************Program_2_1b_**************************/
DATA PATIENT_VITALS;
INPUT @1 ID$ 3. @4 HR 3. @7 SBP 3. @10 DBP 3. @13 N_PROC 2.;
AVE_BP=DBP+(1/3)*(SBP-DBP);
DATALINES;
00108013008010
00208811007205
00305018810002
004   10806801
00506812208204
006101   07404
00707810406603
00804811207006
00907719011009
01006616410610
;
PROC MEANS  DATA=PATIENT_VITALS MEAN STD CLM MEDIAN NMISS;
VAR SBP DBP AVE_BP;
RUN;

/*********************Program_2_1c_**************************/
DATA MERGE_P_PV;
MERGE PATIENT PATIENT_VITALS;
PROC BOXPLOT DATA=MERGE_P_PV;
PLOT HR*RACE;
RUN;

/*********************Program_2_2a_**************************/
DATA CHIWEATHER;
PROC IMPORT OUT=WORK.WEATHER DATAFILE="/folders/myfolders/data/Weather.xls" DBMS=xls replace;
	Sheet="Sheet 1";
    Getnames=yes;
RUN;
PROC MEANS DATA=WORK.WEATHER MEAN STD VAR CLM;
VAR MaxTemperatureF MeanTemperatureF MinTemperatureF;
TITLE "MAX, MEAN AND MIN TEMPERATURE FOR CHICAGO";
RUN;

/*********************Program_2_2b_**************************/
DATA WINTER;
SET WORK.WEATHER;
WHERE MONTH = "DEC" OR MONTH="JAN" OR MONTH="FEB";
PROC SORT DATA=WINTER;
BY MONTH;
PROC MEANS DATA=WINTER MEAN STD CLM;
VAR MeanTemperatureF;
TITLE "CHICAGO WINTER";
RUN;

/*********************Program_2_2c_**************************/
DATA WEATHER_HISTOGRAMS;
Proc Univariate Data = WORK.WEATHER NOPRINT;
Title "MEAN WIND SPEED MPH";
   histogram MeanWindSpeedMPH /NORMAL;
   inset  	skewness = "Skew" (4.3)  
		 	Kurtosis = "Kurtosis" (4.3)
			mean = "Mean" (4.3)
			std="Std Dev" (4.3)/ 				
			Pos = NE
			Height = 4;
Run;
Proc Univariate Data = WORK.WEATHER NOPRINT;
Title "MAX WIND SPEED MPH";
   histogram MaxWindSpeedMPH /NORMAL;
   inset  	skewness = "Skew" (4.3)  
		 	Kurtosis = "Kurtosis" (4.3)
			mean = "Mean" (4.3)
			std="Std Dev" (4.3)/ 				
			Pos = NE
			Height = 4;
Run;
Proc Univariate Data = WORK.WEATHER NOPRINT;
Title "MAX GUST SPEED MPH";
   histogram MaxGustSpeedMPH /NORMAL;
   inset  	skewness = "Skew" (4.3)  
		 	Kurtosis = "Kurtosis" (4.3)
			mean = "Mean" (4.3)
			std="Std Dev" (4.3)/ 				
			Pos = NE
			Height = 4;
Run;