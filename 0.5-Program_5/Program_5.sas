/*********************Program_5_1_**************************/
DATA RANDOM_SAMPLE;
INPUT BLOOD_TYPE$ OBSERVED;
DATALINES;
A 89
B 18
AB 12
0 81
;
PROC FREQ DATA=RANDOM_SAMPLE ORDER=DATA;
TABLES BLOOD_TYPE/ CHISQ TESTP=(41 10 4 45);
WEIGHT OBSERVED;
TITLE "Blood Phenotype Random Sample ";
RUN;

/*********************Program_5_2_a_b_**************************/

PROC IMPORT OUT=URBAND DATAFILE= "/folders/myfolders/data/UrbanDevelopment.xls" 
	DBMS=XLS replace;
	SHEET="Sheet1";
    GETNAMES=yes;
FORMAT A AFT. B BFT. C CFT. D DFT. E EFT. F FFT. G GFT. SIC SICFT.;
PROC PRINT DATA=URBAND;
RUN;
PROC IMPORT OUT=URBAND DATAFILE= "/folders/myfolders/data/UrbanDevelopment.xls" 
	DBMS=XLS replace;
	SHEET="Sheet1";
    GETNAMES=yes;
FORMAT A AFT. B BFT. C CFT. D DFT. E EFT. F FFT. G GFT. SIC SICFT.;
PROC PRINT DATA=URBAND;
RUN;


/*********************Program_5_3_a_b_**************************/

PROC IMPORT OUT=HAYNAS DATAFILE="/folders/myfolders/data/BCHD.xls"
			DBMS= "xls" REPLACE;
			SHEET="SHEET1";
			GETNAMES=YES;
RUN;


DATA HAYNAS_DATA_LINEAR;
SET WORK.HAYNAS;
PROC REG DATA=HAYNAS_DATA_LINEAR;
MODEL SEJ=MA;
/*PLOT SEJ*MA/PRED;*/
TITLE "Linear Regression - Evolution of the skull structure of bone-cracking hypercarnivores(HAYNAS)";
RUN;
QUIT;

/*********************Program_5_3_c_**************************/
DATA HAYNAS_DATA;
SET WORK.HAYNAS;
MASQ=MA**2;
PROC REG DATA=HAYNAS_DATA;
MODEL SEJ=MA MASQ;
TITLE "Quadratic Regression - Evolution of the skull structure of bone-cracking hypercarnivores(HAYNAS)";
RUN;
QUIT;

/*********************Program_5_3_d_e_**************************/
DATA HAYNAS_NONLINEAR;
SET WORK.HAYNAS;
ODS GRAPHICS ON;

PROC Nlin PLOTS=DIAGNOSTICS(STATS=ALL);
PARAMETERS 	a=2 TO 8 BY 2 
			b=0.150 TO 0.275 BY 0.025;
MODEL SEJ = a*exp(b*MA);
RUN;
QUIT;
ODS GRAPHICS OFF;


