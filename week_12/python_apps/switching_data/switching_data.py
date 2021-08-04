import streamlit as st
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

import seaborn as sns

import statsmodels.api as sm

### allow a user to dynamically switch between 3 possible data set
penguins = sns.load_dataset("penguins")

iris = sm.datasets.get_rdataset('iris').data

planets = sns.load_dataset('planets')

"""
# Dynamically select data sets

This app demonstrates how to allow a user to dynamically select a data set. Several approaches are shown:  
  * Dynamically select from objects in the environment
  * Dynamically select data from a dictionary  

The user can select one of the three following data sets:  
  * `penguins` data loaded via Seaborn
  * `iris` data loaded via statsmodels
  * `planets` data loaded via Seaborn

## Approach 1

The radio buttons below allow a user to select one of three possible data sets. The selected data set `.info()` method is printed to the screen below.  
"""

user_select_1 = st.radio("Select data set:", options=('penguins', 'iris', 'planets'), index=0)

if user_select_1 == 'penguins':
  df1 = penguins.copy()
elif user_select_1 == "iris":
  df1 = iris.copy()
else:
  df1 = planets.copy()

df1

"""
## Approach 2

In the second approach, the three data sets are stored as values within a dictionary.  

The user selects a name from the select input box below. That name is provided as the KEY of a dictionary to identify the data set of interest.  

Please note that a select box is used in this example, but a radio button is also a valid choice.  
"""

df_options = {'penguins': penguins, 'iris': iris, 'planets': planets}

user_select_2 = st.selectbox("Select data set from list below:", options=('penguins', 'iris', 'planets'), index=0)

df2 = df_options[user_select_2]

df2
