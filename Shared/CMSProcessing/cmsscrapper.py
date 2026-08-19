import json
import requests
from abc import ABC, abstractmethod
from pyspark.sql import SparkSession, DataFrame

# --- 1. Abstract Interface (SOLID - Dependency Inversion) ---
class BaseIngestionPipeline(ABC):
    def __init__(self, spark: SparkSession):
        self.spark = spark

    @abstractmethod
    def fetch_data(self, url: str) -> list:
        pass

    @abstractmethod
    def run(self, url: str, table_name: str) -> None:
        pass

    # --- 2. Concrete Implementation ---
class CMSCoreSetPipeline(BaseIngestionPipeline):
    """Fetches CMS Core Set public datasets and writes them to Delta Lake."""

    def fetch_data(self, url: str) -> list:
        headers = {'User-Agent': 'Mozilla/5.0'}
        response = requests.get(url, headers=headers, timeout=30)
        response.raise_for_status()
        return response.json()

    def run(self, url: str, table_name: str) -> None:
        print(f"Fetching data from: {url}")
        
        # Extract raw JSON payload
        raw_data = self.fetch_data(url)
        rows = raw_data.get("data", raw_data) if isinstance(raw_data, dict) else raw_data

        # Convert to PySpark DataFrame
        rdd = self.spark.sparkContext.parallelize([json.dumps(row) for row in rows])
        df = self.spark.read.json(rdd)

        # Write to Databricks Delta Table
        df.write.format("delta").mode("overwrite").option("overwriteSchema", "true").saveAsTable(table_name)
        print(f"Successfully saved {df.count()} rows to Delta table '{table_name}'.")

        # --- 3. Execution Entry Point ---
if __name__ == "__main__":
    # Standard Databricks global spark session
    pipeline = CMSCoreSetPipeline(spark)

    # Dataset Endpoints
    DATASETS = {
        "cms_child_core_set": "https://data.cms.gov/data-api/v1/dataset/a62c5c06-1896-410a-a53d-24ecf23ee6d0/data?size=1000",
        "cms_adult_core_set": "https://data.cms.gov/data-api/v1/dataset/8676d5e1-88f6-49a0-97c2-ec061c4d924d/data?size=1000"
    }

    # Execute pipeline for both sets
    for table, endpoint in DATASETS.items():
        try:
            pipeline.run(endpoint, table)
        except Exception as e:
            print(f"Failed to ingest {table}: {e}")
