#!/bin/bash

# --- Configuration ---
# Project resources are named according to the README.md

# Dataset name for BigQuery (where all tables/models will reside)
BQ_DATASET_NAME="web3_mining_data"

# Bucket name is based on the Project ID for uniqueness
# You can adjust the region if needed (us-central1 is standard)
GCS_BUCKET_REGION="us-central1"

# --- Setup Execution ---

# 1. Ask the user for the Google Cloud Project ID
echo "Enter your Google Cloud Project ID:"
read PROJECT_ID

if [ -z "$PROJECT_ID" ]; then
    echo "ERROR: Project ID cannot be empty. Exiting."
    exit 1
fi

# Define the final bucket name
GCS_BUCKET_NAME="${PROJECT_ID}-pi-loop-data"

echo "--- Starting PI_Loop Infrastructure Setup ---"
echo "Project ID: ${PROJECT_ID}"
echo "Dataset:    ${BQ_DATASET_NAME}"
echo "Bucket:     gs://${GCS_BUCKET_NAME}"

# 2. Set the active gcloud project configuration
echo ""
echo "Setting gcloud configuration..."
gcloud config set project "${PROJECT_ID}"

# 3. Create the BigQuery Dataset
echo ""
echo "Creating BigQuery Dataset: ${BQ_DATASET_NAME}..."
# The -f flag forces creation even if it exists, preventing errors
bq mk --dataset --force "${PROJECT_ID}:${BQ_DATASET_NAME}"

if [ $? -eq 0 ]; then
    echo "SUCCESS: BigQuery Dataset created or already exists."
else
    echo "ERROR: Failed to create BigQuery Dataset. Check permissions."
    exit 1
fi

# 4. Create the GCS Bucket
echo ""
echo "Creating GCS Bucket: gs://${GCS_BUCKET_NAME}..."
# The -c flag sets the storage class (standard) and -l sets the location
# The -p flag sets the project owner (not strictly needed but good practice)
gsutil mb -p "${PROJECT_ID}" -c STANDARD -l "${GCS_BUCKET_REGION}" "gs://${GCS_BUCKET_NAME}"

if [ $? -eq 0 ]; then
    echo "SUCCESS: GCS Bucket created or already exists."
else
    echo "ERROR: Failed to create GCS Bucket. Check if the name is globally unique."
    exit 1
fi

# 5. Final Instructions
echo ""
echo "--- SETUP COMPLETE ---"
echo "Next steps: "
echo "1. Upload your CSV files to gs://${GCS_BUCKET_NAME}/"
echo "2. Create the IAM Service Account as described in the README."