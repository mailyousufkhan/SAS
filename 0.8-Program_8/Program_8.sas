PROC IMPORT OUT=STOCKS_DATA DATAFILE="/folders/myfolders/data/STOCKS_SANDY_OCT_DEC.xlsx" 
DBMS="xlsx" REPLACE; 
SHEET="SAS"; 
GETNAMES=YES; 
RUN;

PROC FORMAT; 
VALUE $STOCKS	JNJ_CLOSE ='Johnson & Johnson (NYSE:JNJ)' 
		HON_CLOSE ='Honeywell International, Inc.(NYSE: HON)' 
		NRG_CLOSE ='NRG Energy, Inc. (NYSE: NRG)' 
		CAR_CLOSE ='Avis Budget Group, Inc.(NASDAQ: CAR)' 
		MRK_CLOSE ='Merck & Co., Inc.(NYSE: MRK)'  
		CPB_CLOSE ='Campbell Soup Company (NYSE: CPB)'
		PRU_CLOSE ='Prudential Financial, Inc.(NYSE: PRU)'
		CB_CLOSE  ='Chubb Corporation (NYSE: CB)' 
		BBBY_CLOSE ='Bed Bath & Beyond Inc.(NASDAQ: BBBY)'
		ADP_CLOSE ='Automatic Data Processing, Inc. (NASDAQ: ADP)' 
		CELG_CLOSE ='Celgene Corp. (NASDAQ: CELG)' 
		DGX_CLOSE ='Quest Diagnostics Inc. (NYSE: DGX)' 
		SEE_CLOSE ='Sealed Air Corp. (NYSE: SEE)' 
		HTZ_CLOSE ='Hertz Global Holdings, Inc. (NYSE: HTZ)' 
		PEG_CLOSE ='Public Service Enterprise Group Inc. (NYSE: PEG)' 
		CTSH_CLOSE ='Cognizant Technology Solns Corp. (NASDAQ: CTSH)' 
		BDX_CLOSE ='Becton, Dickinson and Co. (NYSE: BDX)' ;
RUN; 

DATA STOCKS_SANDY; 
LENGTH HURRICANE_TIME_LINE$ 25 ; 
SET WORK.STOCKS_DATA;

IF DATE  < '20OCT2012'd THEN HURRICANE_TIME_LINE="BEFORE_SANDY"; 
ELSE IF DATE <= '09NOV2012'd THEN HURRICANE_TIME_LINE="DURING_SANDY";  
ELSE IF DATE <= '30NOV2012'd THEN HURRICANE_TIME_LINE="AFTER_SANDY"; 
ELSE IF DATE <= '31DEC2012'd THEN HURRICANE_TIME_LINE="MONTH_AFTER_SANDY";  

PROC SORT DATA=STOCKS_SANDY; 
BY DATE; 
RUN;

ODS graphics on;

Proc npar1way DATA=STOCKS_SANDY; 
class  HURRICANE_TIME_LINE; 
LABEL 	JNJ_CLOSE ='Johnson & Johnson (NYSE:JNJ)' 
	HON_CLOSE ='Honeywell International, Inc.(NYSE: HON)' 
	NRG_CLOSE ='NRG Energy, Inc. (NYSE: NRG)' 
	CAR_CLOSE ='Avis Budget Group, Inc.(NASDAQ: CAR)' 
	MRK_CLOSE ='Merck & Co., Inc.(NYSE: MRK)'  
	CPB_CLOSE ='Campbell Soup Company (NYSE: CPB)'
	PRU_CLOSE ='Prudential Financial, Inc.(NYSE: PRU)'
	CB_CLOSE ='Chubb Corporation (NYSE: CB)' 
	BBBY_CLOSE ='Bed Bath & Beyond Inc.(NASDAQ: BBBY)'
	ADP_CLOSE ='Automatic Data Processing, Inc. (NASDAQ: ADP)' 
	CELG_CLOSE ='Celgene Corp. (NASDAQ: CELG)' 
	DGX_CLOSE ='Quest Diagnostics Inc. (NYSE: DGX)' 
	SEE_CLOSE ='Sealed Air Corp. (NYSE: SEE)' 
	HTZ_CLOSE ='Hertz Global Holdings, Inc. (NYSE: HTZ)' 
	PEG_CLOSE ='Public Service Enterprise Group Inc. (NYSE: PEG)' 
	CTSH_CLOSE ='Cognizant Technology Solns Corp. (NASDAQ: CTSH)' 
	BDX_CLOSE ='Becton, Dickinson and Co. (NYSE: BDX)' ;

VAR 	JNJ_CLOSE HON_CLOSE NRG_CLOSE 
    	CAR_CLOSE MRK_CLOSE CPB_CLOSE 
	PRU_CLOSE CB_CLOSE BBBY_CLOSE
	ADP_CLOSE CELG_CLOSE DGX_CLOSE
	SEE_CLOSE HTZ_CLOSE PEG_CLOSE 
	CTSH_CLOSE BDX_CLOSE;  
*exact wilcoxon; 
TITLE "NONPARAMETRIC TEST OF STOCK PRICE BEFORE, DURING AND AFTER HURRICANE SANDY"; 
run;
ODS graphics off;
QUIT; 
