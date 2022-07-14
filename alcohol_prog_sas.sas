/* Importation de la base de donn�es */
PROC IMPORT 
	DATAFILE="C:\Users\NEW\OneDrive\Dossiers\Approfondissement logiciels\Dossier final\alcohol.xlsx"
	OUT=work.alcohol
	DBMS=xlsx
	REPLACE;
	SHEET="donnees";
	GETNAMES=yes;
RUN;

/* V�rification de la structure des donn�es */
proc print data=alcohol (obs=10);
run;

proc contents data=alcohol;
run;

/* V�rification de la structure de la variable age et cr�ation de la variable age^2 */
proc univariate data=alcohol;
var age;
run;

data alcohol1;
set alcohol;
AGE1=age**2;
label age1="age au carr�";
run;

proc print data=alcohol1 (obs=10); * on affiche les 2 variables age et age1;
var age age1;
run;


/* Regressions */

* ************* Mod�le de s�lection Stepwise ************;
proc logistic data=alcohol1;
model boire (event='1') = tcho age age1 educ married town statut
/ selection=stepwise slentry=0.05 slstay=0.05 details lackfit;
output out=logitout p=p;
title 'Mod�le de s�lection des variables';
run;

* ************* Regression logistique *******************;
proc qlim data=alcohol1 outest=estim method=quanew;			
model boire = tcho age age1 educ married town statut / discrete(d=logit);
output out=logitout2 proball xbeta marginal;
title 'Estimations Logit';
run;


/* Calcul des effets margininaux moyen */

proc print data=logitout2 (obs=20); *observation des donn�es de sortie de la r�gression logistique;
run;

data logitout3; *isolement des effets marginaux;
set logitout2;
keep Meff_P2_TCHO Meff_P2_AGE Meff_P2_age1 Meff_P2_EDUC Meff_P2_MARRIED 
Meff_P2_TOWN Meff_P2_STATUT;
rename Meff_P2_TCHO=mTCHO Meff_P2_AGE=mAGE Meff_P2_age1=mAGE1 Meff_P2_EDUC=mEDUC 
Meff_P2_MARRIED=mMARRIED Meff_P2_TOWN=mTOWN Meff_P2_STATUT=mSTATUT;
run;

proc means data=logitout3 maxdec=5; *affichage des moyennes des effets marginaux;
title 'Probabilit�s et effets marginaux moyens';
run;


* **************************** FIN DU PROGRAMME ********************************;
