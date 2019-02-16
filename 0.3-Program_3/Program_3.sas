/*********************Program_3_1a_**************************/
Proc Format;
Value GENDERFT          1 = "MALE"
                        2 = "FEMALE"
                        Other  = "MISCODED";

Value  $SESFT			"L"="LOW"
						"M"="MEDIUM"
						"H"="HIGH";     
   
Value AGEFT  			LOW-20 	= "20 YEARS OLD AND YOUNGER"
		                21-40 	= "BETWEEN 21 AND 40 YEARS OLD"
                        41-HIGH = "41 YEARS OLD AND OLDER";

Run;

Data HEALTHCARE_DRUGS;
LENGTH COST$ 12;
INPUT ID$ GENDER SES$ DRUG$ AGE;

FORMAT 	GENDER 	GENDERFT.
		SES$ 	SESFT.;
LABEL 	SES ="SOCIALECONOMICS" DRUG="DRUG GROUP" AGE = "AGE OF THE SUBJECT";

IF UPCASE(DRUG)= "A" OR UPCASE(DRUG)= "B" OR UPCASE(DRUG)= "C" OR UPCASE(DRUG)= "F" THEN COST="GENERIC";
IF UPCASE(DRUG)= "D" OR UPCASE(DRUG)= "E" OR UPCASE(DRUG)= "G" OR UPCASE(DRUG)= "H" THEN COST="PREMIUN";
IF COST="" THEN COST="MISCODED";

DATALINES;
001 1   L B 15
002 2 M    Z   35
003    2 H  F 76
004 1 L c 21
005 2 H . 58
006 2 L    G 47
007  2 L  D    23
008 1  M E  51
009 1 H    A  32
010   1  H   g  19
;

PROC PRINT DATA= HEALTHCARE_DRUGS NOOBS;
RUN;
PROC SORT DATA=HEALTHCARE_DRUGS;
BY AGE;
PROC FREQ DATA = HEALTHCARE_DRUGS;
TABLES (SES COST )*AGE AGE;
FORMAT AGE AGEFT.;
Run;

/*********************Program_3_2a_**************************/
PROC FORMAT;
			/*Sell Item*/ 
Value AFT 		0="No"
				1="Yes";
Value BFT 	 	0="No"
				1="Yes";
Value CFT 	 	0="No"
				1="Yes";
Value DFT 		0="No"
				1="Yes";
Value EFT 		0="No"
				1="Yes";
Value FFT 		0="No"
				1="Yes";

Value GFT	  	/*restaurant services*/
				0= "No restaurant" 
				1 = "Carry out" 
				2 = "Dine In";

Value SICFT 	/*tax code type of store*/
				52 = "Hardware"
				53 = "General Merchandise"
				54 = "Grocery"
				56 = "Apparel"
				57 = "Furniture"
				59 = "Electronics";

RUN;

DATA URBAND;

PROC IMPORT OUT=URBAND DATAFILE= "/folders/myfolders/data/UrbanDevelopment.xls" 
	DBMS=XLS replace;
	SHEET="Sheet1";
    GETNAMES=yes;
FORMAT A AFT. B BFT. C CFT. D DFT. E EFT. F FFT. G GFT. SIC SICFT.;
PROC PRINT DATA=URBAND;
RUN;

/*********************Program_3_2b_**************************/
DATA URBAN_DEVELOP;
SET WORK.URBAND;
SALES_X_SQF = (SALES)/(SQF);
/* 	LABELS type of items they sell*/
LABEL 		A="Hardware" B="Grocery" C="General Merchandise" D="Furniture"
			E="Electronics"
			F="Video and Music"
			G="Restaurant Services"
			YIB="Years in Business"
			SQF="Square Footage"
			SIC="Standard Industrial Classification";

IF CHAR(ID,1) = "A" THEN ZIPCODE = 60612; 
ELSE IF CHAR(ID,1) = "B" THEN ZIPCODE = 60622;
ELSE IF CHAR(ID,1) = "C" THEN ZIPCODE = 60624;
ELSE IF CHAR(ID,1) = "D" THEN ZIPCODE = 60634;
ELSE IF CHAR(ID,1) = "E" THEN ZIPCODE = 60639;

PROC SORT DATA=URBAN_DEVELOP;
BY ZIPCODE;
PROC FREQ DATA= URBAN_DEVELOP;
TABLES ZIPCODE*(SIC A -- G);
TABLES SIC*ZIPCODE/CHISQ;*Chi-square test on type of store (SIC)per zip codes;
PROC MEANS DATA= URBAN_DEVELOP MEAN STD MEDIAN QRANGE;
BY ZIPCODE;
VAR YIB SALES SALES_X_SQF;
RUN;

/*********************Program_3_2c_**************************/
/*--Set output size--*/
ods graphics / reset width=6.4in height=4.8in imagemap;

/*--SGPLOT proc statement--*/
proc sgplot data=WORK.URBAN_DEVELOP noautolegend;
    /*--TITLE and FOOTNOTE--*/
    title "Sales vs Square Feet";

    /*--Scatter plot settings--*/
    scatter x=SqF y=Sales / group=ZIPCODE markerattrs=(symbol=CircleFilled 
        size=15) transparency=0.4 name='Scatter';
    ;

    /*--X Axis--*/
    xaxis grid;

    /*--Y Axis--*/
    yaxis grid;

    /*--Legend Settings--*/
    keylegend 'Scatter' / title='ZIPCODE:' location=Outside;
run;