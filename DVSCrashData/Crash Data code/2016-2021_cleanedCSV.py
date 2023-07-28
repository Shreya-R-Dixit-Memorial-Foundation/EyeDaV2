import pandas as pd
import glob
import numpy as np

# Define the relevant fields
relevant_fields = ['XCOORD', 'YCOORD', 'FATAL']

# Initialize a list to hold dataframes
dfs = []

# Read all the ACC files from 2016 to 2021
for year in range(2016, 2022):
    filepath = f"C:\\Users\\Theya\\OneDrive - MNSCU\\Desktop\\EyeDaV2\\DVSCrashData\\MN Crash Data {year}\\mn-{year}-acc.txt"
    df = pd.read_csv(filepath, delimiter='\t')
    df = df[relevant_fields]
    
    # Convert FATAL to a binary field
    df['FATAL'] = df['FATAL'].apply(lambda x: 1 if x != "2" else 0)
    
    # Exclude records with missing coordinates
    df = df[(df['XCOORD'] != ".") & (df['YCOORD'] != ".")]
    
    dfs.append(df)

# Concatenate all the dataframes
df_all = pd.concat(dfs, ignore_index=True)

# Save the combined dataframe to a new CSV file
df_all.to_csv("C:\\Users\\Theya\\OneDrive - MNSCU\\Desktop\\EyeDaV2\\DVSCrashData\\mn-2016-2021-acc-cleaned.csv", index=False)
