/*********************Program_7_1_**************************/
DATA CAR_BRANDS;
INFILE "/folders/myfolders/data/CarBrands.txt" dlm=' ';
LENGTH BRAND1 - BRAND4$ 12;
INPUT SUBJECT$ BRAND1 - BRAND4;
PROC PRINT DATA=CAR_BRANDS noobs;
RUN;

DATA restructure;
set WORK.CAR_BRANDS;
ARRAY BRAND[4]BRAND1 - BRAND4;
DO i=1 TO 4;
	BRAND_TYPE=BRAND[i];
	IF BRAND_TYPE ne "XX" THEN OUTPUT;
END;
DROP i BRAND1 - BRAND4;
proc print data=restructure;
TITLE "CAR SURVEY NUMBER OF CARS PER HOUSEHOLD BY BRAND";
run;
PROC FREQ data=restructure ORDER=FREQ;
TABLES BRAND_TYPE /NOROW NOCOL NOFREQ NOCUM; 
RUN;

/*********************Program_7_2_**************************/
PROC IMPORT OUT=Flushot
            DATAFILE="/folders/myfolders/data/FluShot.xlsx"
            DBMS="xlsx" REPLACE;
        SHEET="Sheet1";
        GETNAMES=YES;
RUN;

DATA Health;
        SET Flushot;


ods graphics / reset width=6.4in height=4.8in imagemap;
proc sgplot data=WORK.HEALTH noautolegend;

        scatter x=Age y=FluShot / transparency=0.00 name='Scatter';
        xaxis grid;
        yaxis grid; 
run;
ods graphics off;

PROC LOGISTIC DESCENDING;
MODEL FluShot=age/ RISKLIMITS pprob=1 outroc=ROCData ;
OUTPUT OUT=LOG_FLU_OUT PREDICTED=Pre_FluShot;
title "FIRST MODEL FLUSHOT=AGE";
RUN;

PROC SORT;
BY AGE;

proc sgplot data=LOG_FLU_OUT;
scatter x=Pre_FluShot y=age;
run;


PROC LOGISTIC DESCENDING;
MODEL FluShot=age HealthAwareness HealthIns/ RISKLIMITS lackfit pprob=1 outroc=ROCData ;
OUTPUT OUT=fulllogfluout PREDICTED=full_flu;
title "FIRST MODEL FLUSHOT=AGE HealthAwareness HealthIns";
RUN;
quit;

PROC SORT;
BY AGE;
proc sgplot data=fulllogfluout;
scatter x=full_flu y=age;
run;

PROC LOGISTIC DESCENDING;
MODEL FluShot=age HealthAwareness HealthIns/ selection=forward ;
OUTPUT OUT=fulllogfluout PREDICTED=full_flu;
title "FIRST MODEL FLUSHOT = AGE HealthAwareness HealthIns FORWARD";
RUN;
quit;   

/*********************Program_7_3_**************************/

DATA BETTLE;
INPUT CS KILLED;

DATALINES;
50 11
54 13
58 18
62 23
66 43
70 53
74 57
78 60
;

proc sgplot data=BETTLE;
scatter x=CS y=KILLED;
run;

PROC Nlin;
PARAMETERS K=60 Yo=0.01 R=0.01 TO 0.5 by 0.15;
MODEL KILLED = K/(1+((K-Yo)/Yo)*exp(-r*cs));
OUTPUT OUT=BETTLE_KILLED P=PREDY R=PREDR;
RUN;
QUIT;

proc sgplot data=BETTLE_KILLED;
scatter x=PREDR y=KILLED;
run;

