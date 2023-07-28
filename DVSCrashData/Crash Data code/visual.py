import pandas as pd
import folium

# Load the cleaned accident data
df = pd.read_csv('C:\\Users\\Theya\\OneDrive - MNSCU\\Desktop\\EyeDaV2\\DVSCrashData\\mn-2016-2021-acc-cleaned.csv')

# Convert coordinates to float
df['XCOORD'] = df['XCOORD'].astype(float)
df['YCOORD'] = df['YCOORD'].astype(float)

# Create a map centered around Minnesota
m = folium.Map(location=[46.4419, -93.3650], zoom_start=6)

# Add a small red circle marker for each accident
for idx, row in df.iterrows():
    folium.CircleMarker([row['YCOORD'], row['XCOORD']], radius=1, color='red').add_to(m)

# Save it to a file
m.save('C:\\Users\\Theya\\OneDrive - MNSCU\\Desktop\\EyeDaV2\\DVSCrashData\\accidents_map.html')
