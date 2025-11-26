# 📈 PI_Loop: Predictive Intelligence Loop

> **Cloud ML. Low-Code, High Impact.**

## Project Overview

The **Predictive Intelligence Loop (PI_Loop)** is a modern, serverless data pipeline designed to transform raw customer activity and marketing spend into **proactive business intelligence**.

Built entirely on **Google Cloud (BigQuery ML)** and **n8n (No-Code/Low-Code)**, the system automatically predicts customer churn risk, providing critical early warnings to optimize retention efforts and ensure profitable customer acquisition. This project demonstrates advanced data modeling and automation skills without relying on complex, costly Python infrastructure.

🏛️ 2. Core Architecture: The PI_Loop
This section explains the Serverless and Low-Code design of the PI_Loop. The system functions as a continuous feedback loop: data is ingested, transformed via complex SQL, modeled with Machine Learning, and then triggers an immediate business action (an alert).

Key Components

| Component | Role in PI_Loop | Methodology |
| :--- | :--- | :--- |
| **Google Cloud Storage (GCS)** | **Data Ingestion:** Secure landing zone for raw customer transactions and marketing spend (`.csv` files). | Cloud Storage |
| **BigQuery (BQ) & SQL** | **ETL & Feature Engineering:** Central data warehouse. Transforms raw data into advanced KPIs (LTV, Recency, Frequency, Churn Label). | **Low-Code** / Declarative SQL |
| **BigQuery ML (BQML)** | **Predictive Engine:** Trains a Logistic Regression model directly on BigQuery data to forecast **Churn Probability**. | Cloud Machine Learning |
| **n8n (Workflows)** | **Orchestration & Action:** Schedules the monthly training and daily prediction runs. Executes the BQ commands and manages the alert logic. | **No-Code** Automation |
| **Slack / Email** | **Alerting:** Sends an immediate, critical notification if the predicted *Average Churn Rate* exceeds a predefined threshold. | Business Action Layer |

💰 3. Business Value and Cost Efficiency
This section highlights the critical return on investment (ROI) and the efficiency of using a serverless architecture.

## 💰 3. Business Value and Cost Efficiency

The PI_Loop shifts the business from reactive reporting to predictive optimization, leading to significant ROI.

### Key Value Proposition

| Metric Optimized | PI_Loop Action | Result |
| :--- | :--- | :--- |
| **Customer Lifetime Value (LTV)** | **Proactive Intervention:** Identifies high-risk customers *before* they churn, allowing targeted retention campaigns. | **Increases LTV** and stabilizes long-term mining revenue. |
| **Customer Acquisition Cost (CAC)** | **Profitability Check:** Continuously monitors LTV vs. CAC to validate which marketing channels are truly profitable. | **Optimizes Marketing Spend** and resource allocation. |

### Low-Code, Low-Cost Advantage

The system is designed for massive scale at minimal cost.

* **Operating Cost:** The base operational cost is estimated near **$5 USD per month** (mainly for the small n8n host/VM), leveraging BigQuery's generous Free Tier (1 TB of processed data/month).
* **Scalability:** The system can handle **Terabytes of data** and highly complex SQL/ML models without requiring custom server maintenance or costly Python environments.

🛠️ 4. Technical Deployment Guide
This guide details the three essential phases required to deploy the PI_Loop system on a modern cloud environment.

Prerequisites
A Google Cloud Project with Billing Enabled.

An operational instance of n8n (self-hosted or cloud service).

Phase 1: Google Cloud Infrastructure & IAM
Execute Setup Script: Run the provided setup.sh script in your local terminal. This script will automatically create the necessary BigQuery Dataset (web3_mining_data) and the GCS Bucket (gs://[YOUR-PROJECT-ID]-pi-loop-data), automating the initial infrastructure setup.

IAM Service Account: Create a dedicated Service Account with the BigQuery Data Editor and Storage Object Viewer roles. Download the JSON key file.

Phase 2: Data & Credential Setup
Upload Data: Upload the two mock data files (customer_transactions.csv and marketing_spend.csv) from the data/ folder into your GCS Bucket.

n8n Credentials: Create a new BigQuery Credential in your n8n instance using the JSON key file downloaded in Phase 1. Also, set up a Slack/Email Credential for the alerting system.

Phase 3: n8n Workflow Deployment
Import Workflows: Import all three JSON files into your n8n instance: 01_Monthly..., 02_Daily... (DQ version), and the 404_Error_Handler_Global.json.

Configure SQL Logic: Open the required BigQuery nodes in the main workflows and paste the corresponding SQL code from the /sql folder:

Monthly Flow: Paste v_kpis_transformed.sql and churn_prediction_model.sql.

Daily Flow: Paste data_health_check.sql and t_churn_predictions.sql.

Link Error Handler (Crucial Step): In the Workflow Settings (⚙️) of both the Monthly and Daily flows, set the "Error Workflow" property to the 404_Error_Handler_Global workflow to ensure resilience.

Activate: Save and activate both the Monthly and Daily workflows.

📂 5. Repository Structure
The project is divided into three main folders to separate automation logic from business logic (SQL) and sample data, ensuring high maintainability.

A. n8n_workflows/ (Automation & Orchestration)
This folder contains the three workflows required to automate the loop.

01_PI_Loop_01_Monthly_Training_ETL.json

Function: Runs monthly to load data from GCS, create the KPI view, and re-train the BQML Churn Model.

02_PI_Loop_02_Daily_Prediction_Alerts.json

Function: Runs daily to execute the prediction (ML.PREDICT) and trigger critical alerts.

404_Error_Handler_Global.json

Function: The dedicated error handler that sends detailed alerts via Slack/Email if any step in the main workflows fails.

B. sql/ (Business Logic & Modeling)
These files contain the declarative Low-Code SQL that defines the core business intelligence and machine learning models within BigQuery.

v_kpis_transformed.sql

Function: Creates the view for Feature Engineering (calculates LTV, Recency, Frequency, and the is_churn label).

churn_prediction_model.sql

Function: Defines and trains the Logistic Regression Model using the KPIs from the transformed view.

t_churn_predictions.sql

Function: Executes the daily Inference (ML.PREDICT) and outputs the final table with churn probabilities for the dashboard.

C. data/ (Sample Input Files)
This folder holds the sample CSV files used for testing the initial data ingestion pipeline.

customer_transactions.csv

Function: Mock customer activity data (revenue, transaction dates).

marketing_spend.csv

Function: Mock data on marketing expenditure and customer acquisition counts.

