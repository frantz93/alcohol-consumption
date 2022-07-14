# NB. librairies à installer si non déjà installées
#pip install matplotlib
#pip install pandas
#pip install openpyxl
#pip install statsmodels

#Definition du répertoire de travail
import os
os.chdir("C:/Users/NEW/OneDrive/Dossiers/Approfondissement logiciels\Dossier final")
print(os.getcwd())

#Importation des librairies utiles
import matplotlib.pyplot as plt
import pandas
from matplotlib import style
import statsmodels.formula.api as smf


#Verification de la version de pandas
print(pandas.__version__)


#Chargement et description de la base de données
D = pandas.read_excel("alcohol.xlsx",sheet_name="donnees")
D.info()
D.head()
D.describe()

#Creation de la variable age^2
D = D.assign(AGE1 = D.AGE**2)

#Regression logistique
model = smf.logit(formula='BOIRE ~ TCHO + AGE + AGE1 + EDUC + MARRIED + TOWN + STATUT', data=D).fit()
model.summary()

#Effets marginaux moyens
print(model.get_margeff(at ='overall').summary()) # effets marginaux moyens

