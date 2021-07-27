import streamlit as st
import numpy as np
import pandas as pd

### include comments just like always

# st.title("My first streamlit app")
# 
# st.write("Here is a string printed to screen.")
# 
# ### st.write() it works with just about anything...
# 
# st.write( pd.DataFrame({
#   'x1': [1, 2, 3, 4],
#   'x2': [10, 20, 30, 40]
# }))
# 
# df = pd.DataFrame({
#   'x1': [1, 2, 3, 4]
# })
# 
# df['x2'] = df.x1 * 10
# 
# st.write("another dataframe")
# st.write(df)

### we can use magic commands "special notation" within streamlit
### to "streamline" making the app

"""
# My first streamlit app

## a section header

### sub header

Here's a dataframe.  
"""

df = pd.DataFrame({
  'x1': [1, 2, 3, 4],
  'x2': [10, 20, 30, 40]
})

df
