Libname finalepi "\\blender\homes\t\y\tyraflenoy\nt\AccountSettings\Desktop\finalepi";
proc contents data=project.combined2;
RUN;

proc surveyfreq data=finalepi.combined2;
stratum sdmvstra;
cluster sdmvpsu;
weight wtmec2yr;
table depression*ageperiod / chisq row cl;
run;

*Create Table 1: Characteristics of US Women between the ages 20 - 80> Categorized by Depressive symtoms (PHQ9);

proc surveyfreq data=finalepi.combined2;
stratum sdmvstra;
cluster sdmvpsu;
weight wtmec2yr;
table depression*(ageperiod BMI_cat DMDEDUC2 DMDMARTL RIDRETH1 agecurrent) / chisq row cl;
run;
*Create Table 2: Characteristics of US Women between the ages 20 - 80> Categorized by Age of Menarche;
proc surveyfreq data=finalepi.combined2;
stratum sdmvstra;
cluster sdmvpsu;
weight wtmec2yr;
table ageperiod*(depression BMI_cat DMDEDUC2 DMDMARTL RIDRETH1 agecurrent) / chisq row cl;
run;
*Table 3: unadjusted OR;
proc surveylogistic data=finalepi.combined2;
stratum sdmvstra;
cluster sdmvpsu;
weight wtmec2yr;
class  BMI_cat DMDEDUC2 DMDMARTL RIDRETH1 agecurrent ageperiod(REF="normal");
model depression(ref='1') = ageperiod BMI_cat DMDEDUC2 RIDRETH1 agecurrent;
lsmeans depression*ageperiod depression*BMI_cat depression*DMDEDUC2 depression*RIDRETH1 depression*agecurrent /oddsratio;
run; 
*adjusted OR;
proc surveylogistic data=finalepi.combined2;
stratum sdmvstra;
cluster sdmvpsu;
weight wtmec2yr;
class BMI_cat DMDEDUC2  RIDRETH1  ageperiod(ref="normal") ;
model depression(ref='1') = ageperiod BMI_cat DMDEDUC2 RIDRETH1;

*Examine Possible Confounders; 
proc surveylogistic data=finalepi.combined2;
stratum sdmvstra;
cluster sdmvpsu;
weight wtmec2yr;
class ageperiod (ref='normal')  ;
model depression (ref='1') = ageperiod  ;

proc surveylogistic data=finalepi.combined2;
stratum sdmvstra;
cluster sdmvpsu;
weight wtmec2yr;
class bmi_cat  ;
model depression (ref='1') = bmi_cat  ;


proc surveylogistic data=finalepi.combined2;
stratum sdmvstra;
cluster sdmvpsu;
weight wtmec2yr;
class DMDEDUC2 ;
model depression (ref='1') =  DMDEDUC2 ;

proc surveylogistic data=finalepi.combined2;
stratum sdmvstra;
cluster sdmvpsu;
weight wtmec2yr;
class DMDMARTL ;
model depression (ref='1') =  DMDMARTL ;

proc surveylogistic data=finalepi.combined2;
stratum sdmvstra;
cluster sdmvpsu;
weight wtmec2yr;
class RIDRETH1 ;
model depression (ref='1') =  RIDRETH1 ;

proc surveylogistic data=finalepi.combined2;
stratum sdmvstra;
cluster sdmvpsu;
weight wtmec2yr;
class agecurrent ;
model depression (ref='1') =  agecurrent ;


proc contents data=finalepi.combined2;

*Select final model;
proc logistic data=finalepi.combined2 DESCENDING;
class depression  BMI_cat DMDEDUC2 DMDMARTL RIDRETH1 agecurrent ageperiod(REF="normal");
model depression  = ageperiod BMI_cat DMDEDUC2 RIDRETH1 agecurrent
/selection=backward;

run;

proc logistic data=finalepi.combined2  DESCENDING;
class BMI_cat DMDEDUC2  RIDRETH1  ageperiod (ref="early");
model depression(ref='1') = ageperiod BMI_cat DMDEDUC2 RIDRETH1;

proc means data=finalepi.combined2;

proc power; 
  onesamplemeans test=t 
  mean = 12.7345877 
  stddev = 1.8250506 
  ntotal = 2498 
  power = .; 
run;
