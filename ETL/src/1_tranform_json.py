import pandas as pd
import json
import os

# List all JSON files in the 'downloads' directory
files = [os.path.abspath(file) for file in os.listdir('downloads') if file.endswith('.json')]

# Define a function to process each JSON file
def process_json_file(file_path):
    try:
        print(f"Importing file: {file_path}")
        with open(file_path, 'r') as file:
            data = json.load(file)
        
        # Extract the list of votes
        votaciones = data.get('votaciones')
        
        # If votaciones is null, skip this file
        if votaciones is None:
            print(f"Skipping file: {file_path} - 'votaciones' is null")
            return None
        
        # Extract individual lists
        informacion = data.get('informacion')
        informacion['votacionesConjuntas'] = None
        informacion_df = pd.DataFrame(informacion)
        
        totales_df = pd.DataFrame(data.get('totales'))
        votaciones_df = pd.DataFrame(votaciones)
        
        # Add common columns (for cross-reference)
        informacion_df['id'] = 1  # Add a common ID
        totales_df['id'] = 1     # Add a common ID
        votaciones_df['id'] = 1  # Add a common ID
        
        # Combine all information into a single DataFrame
        combined_df = pd.merge(pd.merge(informacion_df, votaciones_df, on='id'), totales_df, on='id')
        combined_df.drop(columns=['id'], inplace=True)
        
        print(f"File processing completed: {file_path}")
        return combined_df
    except Exception as e:
        # Error handling: print a message and return None
        print(f"Error processing file: {file_path} - {e}")
        return None

# Create a list to store the processed DataFrames
processed_dfs = [process_json_file(file) for file in files if process_json_file(file) is not None]

# Combine all DataFrames into one
combined_df = pd.concat(processed_dfs, ignore_index=True)

# Show the combined result
combined_df.to_csv('votaciones_raw.csv', index=False)

