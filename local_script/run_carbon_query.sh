
$SPARK_HOME/bin/beeline -u jdbc:hive2://carbon15:10000 -f ./tpch_queries.sql --hivevar db_name=tpchcarbon 2>&1 | tee test/query_carbon.log
grep seconds test/query_carbon.log | sed '1,9d' | sed '15d' | sed '16d' | awk '{print substr($4, 2)}' > report/carbon-time.txt
grep seconds test/query_carbon.log | sed '1,9d' | sed '15d' | sed '16d' | awk '{print $1}' > report/carbon-result.txt

$SPARK_HOME/bin/beeline -u jdbc:hive2://carbon15:10000 -f ./tpch_queries.sql --hivevar db_name=tpchcarbon_zstd 2>&1 | tee test/query_carbon_zstd.log
grep seconds test/query_carbon_zstd.log | sed '1,9d' | sed '15d' | sed '16d' | awk '{print substr($4, 2)}' > report/carbon_zstd-time.txt
grep seconds test/query_carbon_zstd.log | sed '1,9d' | sed '15d' | sed '16d' | awk '{print $1}' > report/carbon_zstd-result.txt

$SPARK_HOME/bin/beeline -u jdbc:hive2://carbon15:10000 -f ./tpch_queries.sql --hivevar db_name=tpchcarbon_ls 2>&1 | tee test/query_carbon_ls.log
grep seconds test/query_carbon_ls.log | sed '1,9d' | sed '15d' | sed '16d' | awk '{print substr($4, 2)}' > report/carbon_ls-time.txt
grep seconds test/query_carbon_ls.log | sed '1,9d' | sed '15d' | sed '16d' | awk '{print $1}' > report/carbon_ls-result.txt

$SPARK_HOME/bin/beeline -u jdbc:hive2://carbon15:10000 -f ./tpch_queries.sql --hivevar db_name=tpchcarbon_gd 2>&1 | tee test/query_carbon_gd.log
grep seconds test/query_carbon_gd.log | sed '1,9d' | sed '15d' | sed '16d' | awk '{print substr($4, 2)}' > report/carbon_gd-time.txt
grep seconds test/query_carbon_gd.log | sed '1,9d' | sed '15d' | sed '16d' | awk '{print $1}' > report/carbon_gd-result.txt
