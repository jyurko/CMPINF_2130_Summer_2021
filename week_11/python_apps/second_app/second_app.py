import streamlit as st
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

import seaborn as sns

"""
# My second streamlit app
## Some basic plots
Use the first Anscombe data set, as the primary example.  

The dataset is printed as a reminder below.
"""

anscombe = sns.load_dataset('anscombe')

a1 = anscombe.loc[ anscombe.dataset == "I", : ]

a1

"""
## Scatter plot with matplotlib
"""

fig, ax = plt.subplots(figsize=(12, 8))

ax.plot( a1.x, a1.y, 'ko' )

ax.set_xlabel('x')
ax.set_ylabel('y')

st.pyplot(fig)

"""
## Scatter plot with Seaborn
### Figure level function
"""

gf = sns.relplot(data = a1, x='x', y='y', kind='scatter', aspect=1.75)

st.pyplot( gf )

"""
## Scatter plot with Seaborn
### Axis level function
"""

fig, ax = plt.subplots(figsize=(12, 8))

sns.scatterplot(data = a1, x='x', y='y', ax=ax)

st.pyplot(fig)

"""
## Basic chart in `streamlit`  
`streamlit` has some plotting capabilities as well. I prefer to use `Seaborn` and `matplotlib`.  
I feel it's easier to be surprised with the behavior of the streamlit plots than what we know we will get with either `matplotlib` or `Seaborn`.  
"""

st.line_chart( a1.loc[:, ['x', 'y']].copy() )

"""
## Facet with Seaborn

We can use the figure level functions to facet just like we normally do.  
"""

g = sns.relplot(data = anscombe, x='x', y='y', col='dataset', col_wrap=2)

st.pyplot(g)

"""
Or, we can include a trend line via `sns.lmplot()`.  
"""

g = sns.lmplot(data = anscombe, x='x', y='y', hue='dataset', col='dataset', col_wrap=2)

st.pyplot(g)

"""
# Add reactivity
Let's check the summary stats for the `x` and `y` variables:
"""
st.write( anscombe.describe() )

"""
Allow the user to decide to show summary stats per `dataset` with a checkbox.  
"""

if st.checkbox('Show variable summary stats per group?'):
  a_group = anscombe.groupby(['dataset']).describe()
  
  a_group


"""
Next, let's calculate the correlation coefficient between `x` and `y`:
"""
st.write( anscombe.corr() )

if st.checkbox('Show correlation coefficient per group?'):
  st.write( anscombe.groupby(['dataset']).corr() )


"""
# Select input
Like Shiny, we can provide drop down menus for users to make selections from.  
For example, let's let the user decide which `dataset` to print to the screen.
"""

user_display = st.selectbox(
  'Which dataset do you want to display below?',
  anscombe.dataset.unique().tolist()
)

st.write( anscombe.loc[ anscombe.dataset == user_display, ['x', 'y']].copy() )

st.write("Or, we can show the filtered data set as a plot.")

a_filtered = anscombe.loc[ anscombe.dataset == user_display ].copy()

st.pyplot( sns.relplot(data = a_filtered, x='x', y='y', aspect=1.75) )



