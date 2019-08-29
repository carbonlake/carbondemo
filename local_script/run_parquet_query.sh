$SPARK_HOME/bin/beeline -u jdbc:hive2://carbon15:10000 -f ./parquet_queries.sql 2>&1 | tee test/parquet.log

grep seconds test/parquet.log | sed '1,9d' | sed '15d' | sed '16d' | awk '{print substr($4, 2)}' > report/parquet-time.txt
grep seconds test/parquet.log | sed '1,9d' | sed '15d' | sed '16d' | awk '{print $1}' > report/parquet-result.txt


$SPARK_HOME/bin/beeline -u jdbc:hive2://carbon15:10000 -f ./parquet_queries_par.sql 2>&1 | tee test/parquet_par.log

grep seconds test/parquet_par.log | sed '1,9d' | sed '15d' | sed '16d' | awk '{print substr($4, 2)}' > report/parquet_par-time.txt
grep seconds test/parquet_par.log | sed '1,9d' | sed '15d' | sed '16d' | awk '{print $1}' > report/parquet_par-result.txt

