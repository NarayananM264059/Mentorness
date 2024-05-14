import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# Load the dataset
df = pd.read_csv('Hotel Aggregator dataset.csv')

# Explore the data
#print(df.head())
#print(df.info())
#print(df.describe())
# Check data types
#print(df.dtypes)


# Check for any remaining missing values
missing_values = df.isnull().sum()
print(missing_values)

# Remove rows with missing values


print(df.columns)

print("Ater Clean :")

# Define the columns needed for each objective
geographical_columns = ['neighbourhood', 'latitude', 'longitude']
pricing_availability_columns = ['property_type', 'room_type', 'accommodates', 'price',
                                'availability_30', 'availability_60', 'availability_90', 'availability_365']
host_performance_columns = ['host_is_superhost', 'host_response_time',
                            'host_listings_count', 'host_total_listings_count',
                            'calculated_host_listings_count', 'calculated_host_listings_count_entire_homes',
                            'calculated_host_listings_count_private_rooms', 'calculated_host_listings_count_shared_rooms']
review_scores_columns = ['number_of_reviews', 'review_scores_rating', 'review_scores_accuracy',
                         'review_scores_cleanliness', 'review_scores_checkin', 'review_scores_communication',
                         'review_scores_location', 'review_scores_value', 'reviews_per_month']
property_room_columns = ['property_type', 'room_type']

# Combine all the columns needed for the objectives
relevant_columns = list(set().union(geographical_columns, pricing_availability_columns,
                                    host_performance_columns, review_scores_columns, property_room_columns))

# Filter the DataFrame to keep only the relevant columns
df = df[relevant_columns]

print(df.columns)





# List of numeric columns
numeric_columns = ['reviews_per_month', 'review_scores_accuracy', 'review_scores_cleanliness', 
                   'review_scores_checkin', 'review_scores_communication', 'review_scores_location', 
                   'review_scores_value', 'review_scores_rating', 'latitude', 'longitude', 
                   'host_total_listings_count', 'host_listings_count', 
                   'number_of_reviews']

# Convert values to numeric, ignoring errors
df[numeric_columns] = df[numeric_columns].apply(pd.to_numeric, errors='coerce')

# Impute missing values with median
for column in numeric_columns:
    median_value = df[column].median()
    df[column].fillna(median_value, inplace=True)


# For categorical columns
categorical_columns = ['host_response_time', 'neighbourhood', 'host_is_superhost']

for column in categorical_columns:
    # Replace missing values with the mode
    mode_value = df[column].mode()[0]
    df[column].fillna(mode_value, inplace=True)


# Check for any remaining missing values
missing_values = df.isnull().sum()
print(missing_values)

# Remove Duplicates
df = df.drop_duplicates()



# Save the cleaned dataset to a new CSV file
df.to_csv("cleaned_dataset.csv", index=False)

