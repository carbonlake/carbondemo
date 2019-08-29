HOST=carbon15
TPCH_DATA_PATH=/Users/jacky/code/tpch-osx/dbgen/tpch_data

# $SPARK_HOME/bin/beeline -u jdbc:hive2://$HOST:10000 -f ./create_csv_table.sql --hivevar tpch_data_path=$TPCH_DATA_PATH 2>&1 |tee test/create_csv.log

# # carbon no sort
# $SPARK_HOME/bin/beeline -u jdbc:hive2://$HOST:10000 -f ./create_carbon.sql  2>&1 |tee test/load_carbon.log
# $SPARK_HOME/bin/beeline -u jdbc:hive2://$HOST:10000 -f ./load_carbon.sql --hivevar carbon_db_name=tpchcarbon --hivevar tpch_data_path=$TPCH_DATA_PATH 2>&1 |tee test/load_carbon.log

# carbon no sort zstd
# $SPARK_HOME/bin/beeline -u jdbc:hive2://$HOST:10000 -f ./create_carbon_zstd.sql  2>&1 |tee test/load_carbon_zstd.log
# $SPARK_HOME/bin/beeline -u jdbc:hive2://$HOST:10000 -f ./load_carbon.sql --hivevar carbon_db_name=tpchcarbon_zstd --hivevar tpch_data_path=$TPCH_DATA_PATH   2>&1 |tee test/load_carbon_zstd.log

# carbon local sort
$SPARK_HOME/bin/beeline -u jdbc:hive2://$HOST:10000 -f ./create_carbon_ls.sql  2>&1 |tee test/load_carbon_ls.log
$SPARK_HOME/bin/beeline -u jdbc:hive2://$HOST:10000 -f ./load_carbon.sql --hivevar carbon_db_name=tpchcarbon_ls --hivevar tpch_data_path=$TPCH_DATA_PATH  2>&1 |tee test/load_carbon_ls.log

# # parquet
# $SPARK_HOME/bin/beeline -u jdbc:hive2://$HOST:10000 -f ./create_parquet.sql  2>&1 |tee test/load_parquet.log
# $SPARK_HOME/bin/beeline -u jdbc:hive2://$HOST:10000 -f ./load_parquet.sql  2>&1 |tee test/load_parquet.log

# # parquet partition
# $SPARK_HOME/bin/beeline -u jdbc:hive2://$HOST:10000 -f ./create_parquet_partition.sql  2>&1 |tee test/load_parquet_partition.log
# $SPARK_HOME/bin/beeline -u jdbc:hive2://$HOST:10000 -f ./load_parquet_partition.sql  2>&1 |tee test/load_parquet_partition.log
