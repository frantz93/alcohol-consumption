/* Importation de la base de données */
PROC IMPORT 
	DATAFILE="C:\Users\NEW\OneDrive\Dossiers\Approfondissement logiciels\Dossier final\alcohol.xlsx"
	OUT=work.alcohol
	DBMS=xlsx
	REPLACE;
	SHEET="donnees";
	GETNAMES=yes;
RUN;

/* Vérification de la structure des données */
proc print data=alcohol (obs=10);
run;

proc contents data=alcohol;
run;

/* Vérification de la structure de la variable age et création de la variable age^2 */
proc univariate data=alcohol;
var age;
run;

data alcohol1;
set alcohol;
AGE1=age**2;
label age1="age au carré";
run;

proc print data=alcohol1 (obs=10); * on affiche les 2 variables age et age1;
var age age1;
run;


/* Regressions */

* ************* Modèle de sélection Stepwise ************;
proc logistic data=alcohol1;
model boire (event='1') = tcho age age1 educ married town statut
/ selection=stepwise slentry=0.05 slstay=0.05 details lackfit;
output out=logitout p=p;
title 'Modèle de sélection des variables';
run;

* ************* Regression logistique *******************;
proc qlim data=alcohol1 outest=estim method=quanew;			
model boire = tcho age age1 educ married town statut / discrete(d=logit);
output out=logitout2 proball xbeta marginal;
title 'Estimations Logit';
run;


/* Calcul des effets margininaux moyen */

proc print data=logitout2 (obs=20); *observation des données de sortie de la régression logistique;
run;

data logitout3; *isolement des effets marginaux;
set logitout2;
keep Meff_P2_TCHO Meff_P2_AGE Meff_P2_age1 Meff_P2_EDUC Meff_P2_MARRIED 
Meff_P2_TOWN Meff_P2_STATUT;
rename Meff_P2_TCHO=mTCHO Meff_P2_AGE=mAGE Meff_P2_age1=mAGE1 Meff_P2_EDUC=mEDUC 
Meff_P2_MARRIED=mMARRIED Meff_P2_TOWN=mTOWN Meff_P2_STATUT=mSTATUT;
run;

proc means data=logitout3 maxdec=5; *affichage des moyennes des effets marginaux;
title 'Probabilités et effets marginaux moyens';
run;


* **************************** FIN DU PROGRAMME ********************************;
