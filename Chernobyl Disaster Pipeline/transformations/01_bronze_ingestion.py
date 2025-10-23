from pyspark import pipelines as dp
from pyspark.sql.functions import col


# This file defines a sample transformation.
# Edit the sample below or add new transformations
# using "+ Add" in the file browser.


@dp.table
def Chernobyl_Disaster_Air_Concentration():
    return (
        spark.read.table("Projects.Data.chernobyl_data")
    )

@dp.table
def weather_conditions():
    return (
        spark.read.table("Projects.Data.1986_weather")
    )