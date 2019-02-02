
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

/*
Do any of the zip codes appear to be food deserts and why?
From the tables  we can see that zipcode 60612 may be a food desert , if we compare 
the frequency in table B and SIC for this zipcode we can see what may be a significance
difference compare with other zipcodes.
  
(i) Compare the years in business variable between the zip codes. 
Does there seem to be an a zip code that is more or less stable.
Looking at the standard deviation of the mean table we can see 
that zipcode 60634 as an smaller standard deviation meaning that businesses in that
zipcode dont change that frequently. 

(ii) Compare the mean sales. Does one zip code look like it generates 
more or less sales than other zip codes. 
Looking at the sales per square feet and overall sales we can see that zipcode
60634 generates more revenues than the others. 
Do these trends (if any exist) persist with sales per square feet.
The same conditions persist for sales per square feet with the only variation that for
zipcode 60622 the spread is larger(IQR) meaning that there is a greater variation 
in the sales per square feet for zipcode 60622.

(i) State the Null and Alternative Hypothesis determine whether there is a 
significant relationship between store (SIC) and zip codes.
*****Null Hypothesis (Ho)*****
There is no difference, association or dependency 
between the type of store (SIC) and the zipcode.
*****Alternative Hypothesis (H1)****
There is a coorelation between the type of store and the zipcode.	 	

(ii) State the test statistic, the p-value and your conclusion.
To answer our hypothesis we can look at the Chi-Square, to find that the 
chi-square test statistic value is 14.3027 and the associated p-value is 0.8148. 
As  chi-squared is larger than the 0.05 (critical point) we have to reject the null 
hypothesis and conclude that there is a correlation between the zipcode and SIC.
 
(iii) Why might the Chi-Square test of independence not be the best hypothesis test?
SAS give us a WARNING: 70% of the cells have expected counts less than 5. Chi-Square may not be a valid test.
In this cases it is better to use the Fisher’s Exact Test taking in count that we need a 2X2 table
where that makes and association between the row and column variables. This test assumes that 
the row and column totals are fixed, and then uses the hypergeometric distribution to compute 
probabilities of possible tables conditional on the observed row and column totals. Fisher’s exact 
test does not depend on any large-sample distribution assumptions, and so it is appropriate 
even for small sample sizes and for sparse tables. 
*/

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

/*

Does there appear to be a trend in this? 
It seems like as the square footage increse sales increase, in the five different 
zipcodes. 
*/

DATA CRIME;

INPUT CRIME$ ALCOHOL$  COUNT;

DATALINES;
ARSON YES 50
ARSON NO 43
RAPE YES 88
RAPE NO 62
VIOLENCE YES 155
VIOLENCE NO 110
STEALING YES 379
STEALING NO 300
COINING YES 18
COINING NO 14
FRAUD YES 63
FRAUD NO 144
;

PROC FREQ DATA=CRIME ORDER=DATA;
TABLES CRIME*ALCOHOL /CHISQ DEVIATION EXPECTED;
WEIGHT COUNT;
RUN;

/*
b. State the Null and Alternative Hypothesis for the Chi-Square test

*****Null Hypothesis (Ho)*****
There is no difference, association or dependency 
between types of crimes and consumption of alcohol.

*****Alternative Hypothesis (H1)*****
There is a coorelation between the consume of alcohol and the type of crime.

c. State the conclusion a 95% confidence level. Include the test statistic 
and p-value in your conclusion.
The chi-square test statistic value is 49.7306 	p-value is less than 0.0001 meaning
that with a 95% confidence we can say that there is not a correlation between the
consumption of alcohol and the type of crime commited that can be determine from this
sample.

d. Based on this data, does it appear that drinkers are more likely to commit crimes? 
Justify your answer. Look for anything unusual in the output.
From this data we cant infer that drinkers are more likely to commit crimes and we
can see an outlier in the fraud crimes where 10.10% were committed by a non-drinker
and just 4.42% by a drinker at of 14.52%
