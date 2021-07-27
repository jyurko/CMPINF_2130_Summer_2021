import streamlit as st
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

import seaborn as sns

import statsmodels.api as sm

iris = sm.datasets.get_rdataset('iris').data

"""
# Iris explore

This app lets the user to explore the `iris` data set.  

Please select the `x` and `y` variables display in the scatter plot using the sidebar to the left.
"""

### identify the numeric variables to include the x-axis drop down list
var_names = iris.select_dtypes(include='number').columns.tolist()

user_x = st.sidebar.selectbox(
  "Select x-axis variable:",
  var_names,
  0
)

### make a new list of names which remove the x-selected variable
var_y_names = iris.drop(columns = user_x).copy().select_dtypes(include='number').columns.tolist()

user_y = st.sidebar.selectbox(
  "Select y-axis variable:",
  var_y_names,
  0
)

### include a check box to color by species

g_nocolor = sns.relplot(data = iris, x=user_x, y=user_y)

g_wcolor = sns.relplot(data = iris, x=user_x, y=user_y, hue='Species')

user_color = st.sidebar.checkbox('Color by Species?')

if user_color:
  st.pyplot(g_wcolor)
else:
  st.pyplot(g_nocolor)

###
