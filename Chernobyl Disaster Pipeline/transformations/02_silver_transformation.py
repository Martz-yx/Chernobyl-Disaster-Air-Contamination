from pyspark import pipelines as dp
from pyspark.sql.functions import col, sum, when, to_timestamp, to_date, date_format, expr
from utilities import utils


@dp.table
def Chernoclean():
    country_map = {
        'AU': 'Austria',
        'BE': 'Belgium',
        'CH': 'Switzerland',
        'CZ': 'Czechoslovakia',
        'DE': 'Germany',
        'ES': 'Spain',
        'F': 'France',
        'FI': 'Finland',
        'GR': 'Greece',
        'HU': 'Hungary',
        'IR': 'Ireland',
        'IT': 'Italy',
        'NL': 'Netherlands',
        'NO': 'Norway',
        'SE': 'Sweden',
        'UK': 'United Kingdom'
    }
    df = (
        spark.read.table("Chernobyl_Disaster_Air_Concentration")
        .withColumn("iodine_131", utils.fix_values(col("I_131_Bqm3")))
        .withColumn("caesium_134", utils.fix_values(col("Cs_134_Bqm3")))
        .withColumn("caesium_137", utils.fix_values(col("Cs_137_Bqm3")))
        .withColumn(
            "Date",
            to_date(
                date_format(
                    to_timestamp(col("Date"), "yy/MM/dd").alias("parsed_date") - expr("INTERVAL 100 YEARS"),
                    "yyyy-MM-dd"
                ),
                "yyyy-MM-dd"
            )
        )
        .drop("I_131_Bqm3", "Cs_134_Bqm3", "Cs_137_Bqm3","End_of_sampling","Duration")
    )
    pays_col = col("PAYS")
    for code, country in country_map.items():
        df = df.withColumn("PAYS", when(pays_col == code, country).otherwise(col("PAYS")))
        pays_col = col("PAYS")
    df = (
        df
        .withColumnRenamed("PAYS", "Country")
        .withColumnRenamed("Ville", "City")
        .withColumnRenamed("X", "lattitude")
        .withColumnRenamed("Y", "longitude")
    )
    return df

@dp.table
def weatherclean():
    df = (
        spark.read.table("weather_conditions")
        .drop("PRCP_ATTRIBUTES", "SNOW_ATTRIBUTES", "Cs_137_Bqm3","End_of_sampling","Duration")

        .withColumnRenamed("PRCP", "Precipitation")
        .withColumnRenamed("Ville", "City")
        .withColumnRenamed("X", "lattitude")
        .withColumnRenamed("Y", "longitude")
    )
    return df