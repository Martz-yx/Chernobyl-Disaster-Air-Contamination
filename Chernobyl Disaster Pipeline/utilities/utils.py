from pyspark.sql.functions import udf
from pyspark.sql.types import FloatType

@udf(returnType=FloatType())
def fix_values(value):
    """Converts non-numeric values (?, NA, Empty, None) to NULL to avoid conflicts on numeric columns"""
    try:
        if value is None:
            return None
        if isinstance(value, (int, float)):
            return float(value)
        value_str = str(value).strip()
        if value_str in ("", "?", "NA", "None"):
            return None
        return float(value_str)
    except Exception:
        return None
