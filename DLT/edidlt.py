import dlt
import json
import sys
from pathlib import Path
from pyspark.sql.functions import udf, col, current_timestamp, input_file_name
from pyspark.sql.types import StructType, StructField, StringType

from Shared.EDIProcessing import EDIProcessor
from DimMember.EDIProcessing.mapper import Mapper

@udf(returnType=StructType([
    StructField("client_id", StringType(), True),
    StructField("file_id", StringType(), True),
    StructField("layout_id", StringType(), True),
    StructField("parsed_payload", StringType(), True),
    StructField("error_message", StringType(), True)
]))
def parse_edi_raw(raw_text: str):
    if not raw_text or not raw_text.strip():
        return None, None, None, None, "Empty text Content"
    
    try:
        structured_json = EDIProcessor().parse_string(raw_text)
        interchange = structured_json.get('interchange', {})
        client_id = interchange.get('sender_id', '').strip()
        file_id = interchange.get('control_number', '').strip()

        st_segment = (
            structured_json.get('heading', {})
            .get('transaction_set_header_loop', {})
            .get('transaction_set_header_ST', {})
        )

        layout_id = st_segment.get('transaction_set_identifier_code', '834').strip()
        mapped_data = Mapper().map_member(structured_json)
        return client_id, file_id, layout_id, json_dumps(mapped_data), None
    except Exception as e:
        return None, None, None, None, str(e)
    
    @dlt.table(
        comment='Incremental EDI streaming ingestion via Auto Loader',
        table_properties={
            "quality": "bronze"
        }
    )
    def bronze_edi_raw():
        return (
            spark.readStream
            .format("cloudFiles")
            .option("cloudFiles.format", "text")
            .option("wholetext", true)
            .option("cloudFiles.schemaLocation", f"{CHECKPOINT_DIR}/schema")
            .load(SOURCE_LANDING_DIR)
            .select(
                col("value").alias("raw_content"),
                input_file_name().alias("_file_name"),
                current_timestamp().alias("_ingested_at")
            )
            .withColumn("parsed", parse_edi_raw(col("raw_content")))
            .select(
                col("_file_name"),
                col("_ingested_at"),
                col("parsed.client_id").alias("client_id"),
                col("parsed.file_id").alias("file_id"),
                col("parsed.layout_id").alias("layoutid"),
                col("parsed.parsed_payload").alias("parsed_payload"),
                col("parsed.error_message").alias("error_message")
            )
        )