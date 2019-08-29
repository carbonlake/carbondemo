use ${db_name};

select count(*) from LINEITEM;
select count(*) from SUPPLIER;
select count(*) from PARTSUPP;
select count(*) from CUSTOMER;
select count(*) from NATION;
select count(*) from REGION;
select count(*) from PART;
select count(*) from ORDERS;


-- 商业智能计算测试TPC-H 是美国交易处理效能委员会(TPC,Transaction Processing Performance Council) 组织制定的用来模拟决策支持类应用的一个测试集.目前,在学术界和工业界普遍采用它来评价决策支持技术方面应用的性能. 这种商业测试可以全方位评测系统的整体商业计算综合能力，对厂商的要求更高，同时也具有普遍的商业实用意义，目前在银行信贷分析和信用卡分析、电信运营分析、税收分析、烟草行业决策分析中都有广泛的应用。
-- TPC-H 基准测试是由 TPC-D(由 TPC 组织于 1994 年指定的标准,用于决策支持系统方面的测试基准)发展而来的.TPC-H 用 3NF 实现了一个数据仓库,共包含 8 个基本关系,其数据量可以设定从 1G~3T 不等。TPC-H 基准测试包括 22 个查询(Q1~Q22),其主要评价指标是各个查询的响应时间,即从提交查询到结果返回所需时间.TPC-H 基准测试的度量单位是每小时执行的查询数( QphH@size)，其中 H 表示每小时系统执行复杂查询的平均次数，size 表示数据库规模的大小,它能够反映出系统在处理查询时的能力.TPC-H 是根据真实的生产运行环境来建模的,这使得它可以评估一些其他测试所不能评估的关键性能参数.总而言之,TPC 组织颁布的TPC-H 标准满足了数据仓库领域的测试需求,并且促使各个厂商以及研究机构将该项技术推向极限。

-- Q01 统计查询
-- Q02 WHERE条件中，使用子查询(=)
-- Q03 多表关联统计查询，并统计(SUM)
-- Q04 WHERE条件中，使用子查询(EXISTS)，并统计(COUNT)
-- Q05 多表关联查询(=)，并统计(SUM)
-- Q06 条件(BETWEEN AND)查询，并统计(SUM)
-- Q07 带有FROM子查询，从结果集中统计(SUM)
-- Q08 带有FROM多表子查询，从结果集中的查询列上带有逻辑判断(WHEN THEN ELSE)的统计(SUM)
-- Q09 带有FROM多表子查询，查询表中使用函数(EXTRACT)，从结果集中统计(SUM)
-- Q10 多表条件查询(>=, <，并统计(SUM)
-- Q11 在GROUP BY中使用比较条件(HAVING >)，比较值从子查询中查出
-- Q12 带有逻辑判断(WHEN AND/ WHEN OR)的查询，并统计(SUM)
-- Q13 带有FROM子查询，子查询中使用外联结
-- Q14 使用逻辑判断(WHEN ELSE)的查询
-- Q15 使用视图和表关联查询
-- Q16 在WHERE子句中使用子查询，使用IN/ NOT IN判断条件，并统计(COUNT)
-- Q17 在WHERE子句中使用子查询，使用<比较，使用了AVG函数
-- Q18 在WHERE子句中使用IN条件从子查询结果中比较
-- Q19 多条件比较查询
-- Q20 WHERE条件子查询(三层)
-- Q21 在WHERE条件中使用子查询，使用EXISTS和NOT EXISTS判断
-- Q22 在WHERE条件中使用判断子查询、IN、NOT EXISTS，并统计(SUM、COUNT)查询结果

-- Q01 统计查询
select l_returnflag, l_linestatus, sum(l_quantity) as sum_qty, sum(l_extendedprice) as sum_base_price, sum(l_extendedprice*(1-l_discount)) as sum_disc_price, sum(l_extendedprice*(1-l_discount)*(1+l_tax)) as sum_charge, avg(l_quantity) as avg_qty, avg(l_extendedprice) as avg_price, avg(l_discount) as avg_disc, count(*) as count_order from lineitem where l_shipdate <= date('1998-09-02') group by l_returnflag, l_linestatus order by l_returnflag, l_linestatus;

-- Q02 WHERE条件中，使用子查询(=)
select s_acctbal, s_name, n_name, p_partkey, p_mfgr, s_address, s_phone, s_comment from part, supplier, partsupp, nation, region where p_partkey = ps_partkey and s_suppkey = ps_suppkey and p_size = 15 and p_type like '%BRASS' and s_nationkey = n_nationkey and n_regionkey = r_regionkey and r_name = 'EUROPE' and ps_supplycost = ( select min(ps_supplycost) from partsupp, supplier,nation, region where p_partkey = ps_partkey and s_suppkey = ps_suppkey and s_nationkey = n_nationkey and n_regionkey = r_regionkey and r_name = 'EUROPE' ) order by s_acctbal desc, n_name, s_name, p_partkey limit 100;

-- Q03 多表关联统计查询，并统计(SUM)
select l_orderkey, sum(l_extendedprice * (1 - l_discount)) as revenue, o_orderdate, o_shippriority from customer, orders, lineitem where c_mktsegment = 'BUILDING' and c_custkey = o_custkey and l_orderkey = o_orderkey and o_orderdate < date('1995-03-15') and l_shipdate > date('1995-03-15') group by l_orderkey, o_orderdate, o_shippriority order by revenue desc, o_orderdate limit 10;

-- Q04 WHERE条件中，使用子查询(EXISTS)，并统计(COUNT)
select o_orderpriority, count(*) as order_count from orders where o_orderdate >= date('1993-07-01') and o_orderdate < date('1993-10-01') and exists ( select * from lineitem where l_orderkey = o_orderkey and l_commitdate < l_receiptdate ) group by o_orderpriority order by o_orderpriority;

-- Q05 多表关联查询(=)，并统计(SUM)
select n_name, sum(l_extendedprice * (1 - l_discount)) as revenue from customer, orders, lineitem, supplier, nation, region where c_custkey = o_custkey and l_orderkey = o_orderkey and l_suppkey = s_suppkey and c_nationkey = s_nationkey and s_nationkey = n_nationkey and n_regionkey = r_regionkey and r_name = 'ASIA' and o_orderdate >= date('1994-01-01') and o_orderdate < date('1995-01-01') group by n_name order by revenue desc;

-- Q06 条件(BETWEEN AND)查询，并统计(SUM)
select sum(l_extendedprice * l_discount) as revenue from lineitem where l_shipdate >= date('1994-01-01') and l_shipdate < date('1995-01-01') and l_discount between 0.05 and 0.07 and l_quantity < 24;

-- Q07 带有FROM子查询，从结果集中统计(SUM)
select supp_nation, cust_nation, l_year, sum(volume) as revenue from ( select n1.n_name as supp_nation, n2.n_name as cust_nation, year(l_shipdate) as l_year, l_extendedprice * (1 - l_discount) as volume from supplier,lineitem,orders,customer,nation n1,nation n2 where s_suppkey = l_suppkey and o_orderkey = l_orderkey and c_custkey = o_custkey and s_nationkey = n1.n_nationkey and c_nationkey = n2.n_nationkey and ( (n1.n_name = 'FRANCE' and n2.n_name = 'GERMANY') or (n1.n_name = 'GERMANY' and n2.n_name = 'FRANCE') ) and l_shipdate between date('1995-01-01') and date('1996-12-31') ) as shipping group by supp_nation, cust_nation, l_year order by supp_nation, cust_nation, l_year;

-- Q08 带有FROM多表子查询，从结果集中的查询列上带有逻辑判断(WHEN THEN ELSE)的统计(SUM)
select o_year, sum(case when nation = 'BRAZIL' then volume else 0 end) / sum(volume) as mkt_share from (select year(o_orderdate) as o_year, l_extendedprice * (1-l_discount) as volume, n2.n_name as nation from part,supplier,lineitem,orders,customer,nation n1,nation n2,region where p_partkey = l_partkey and s_suppkey = l_suppkey and l_orderkey = o_orderkey and o_custkey = c_custkey and c_nationkey = n1.n_nationkey and n1.n_regionkey = r_regionkey and r_name = 'AMERICA' and s_nationkey = n2.n_nationkey and o_orderdate between date('1995-01-01') and date('1996-12-31') and p_type = 'ECONOMY ANODIZED STEEL' ) as all_nations group by o_year order by o_year;

-- Q09 带有FROM多表子查询，查询表中使用函数(EXTRACT)，从结果集中统计(SUM)
select nation, o_year, sum(amount) as sum_profit from ( select n_name as nation, year(o_orderdate) as o_year, l_extendedprice * (1 - l_discount) - ps_supplycost * l_quantity as amount from part, supplier, lineitem, partsupp, orders, nation where s_suppkey = l_suppkey and ps_suppkey = l_suppkey and ps_partkey = l_partkey and p_partkey = l_partkey and o_orderkey = l_orderkey and s_nationkey = n_nationkey and p_name like '%green%' ) as profit group by nation, o_year order by nation, o_year desc;

-- Q10 多表条件查询(>=, <，并统计(SUM)
select c_custkey, c_name, sum(l_extendedprice * (1 - l_discount)) as revenue, c_acctbal, n_name, c_address, c_phone, c_comment from customer, orders, lineitem, nation where c_custkey = o_custkey and l_orderkey = o_orderkey and o_orderdate >= date('1993-10-01') and o_orderdate < date('1994-01-01') and l_returnflag = 'R' and c_nationkey = n_nationkey group by c_custkey, c_name, c_acctbal, c_phone, n_name, c_address, c_comment order by revenue desc limit 20;

-- Q11 在GROUP BY中使用比较条件(HAVING >)，比较值从子查询中查出
select ps_partkey, sum(ps_supplycost * ps_availqty) as value from partsupp, supplier, nation where ps_suppkey = s_suppkey and s_nationkey = n_nationkey and n_name = 'GERMANY' group by ps_partkey having sum(ps_supplycost * ps_availqty) > ( select sum(ps_supplycost * ps_availqty) * 0.0001000000 s from partsupp, supplier, nation where ps_suppkey = s_suppkey and s_nationkey = n_nationkey and n_name = 'GERMANY' ) order by value desc;

-- Q12 带有逻辑判断(WHEN AND/ WHEN OR)的查询，并统计(SUM)
select l_shipmode, sum(case when o_orderpriority = '1-URGENT' or o_orderpriority = '2-HIGH' then 1 else 0 end) as high_line_count, sum(case when o_orderpriority <> '1-URGENT' and o_orderpriority <> '2-HIGH' then 1 else 0 end) as low_line_count from orders, lineitem where o_orderkey = l_orderkey and l_shipmode in ('MAIL', 'SHIP') and l_commitdate < l_receiptdate and l_shipdate < l_commitdate and l_receiptdate >= date('1994-01-01') and l_receiptdate < date('1995-01-01') group by l_shipmode order by l_shipmode;

-- Q13 带有FROM子查询，子查询中使用外联结
select c_count, count(*) as custdist from (select c_custkey, count(o_orderkey) as c_count from customer left outer join orders on ( c_custkey = o_custkey and o_comment not like '%special%requests%' ) group by c_custkey ) as c_orders group by c_count order by custdist desc, c_count desc;

-- Q14 使用逻辑判断(WHEN ELSE)的查询
select 100.00 * sum(case when p_type like 'PROMO%' then l_extendedprice * (1 - l_discount) else 0 end) / sum(l_extendedprice * (1 - l_discount)) as promo_revenue from lineitem, part where l_partkey = p_partkey and l_shipdate >= date('1995-09-01') and l_shipdate < date('1995-10-01');

-- Q15 使用视图和表关联查询
create view revenue (supplier_no, total_revenue) as select l_suppkey, sum(l_extendedprice * (1 - l_discount)) from lineitem where l_shipdate >= date('1996-01-01') and l_shipdate < date('1996-04-01') group by l_suppkey;
select s_suppkey, s_name, s_address, s_phone, total_revenue from supplier,revenue where s_suppkey = supplier_no and total_revenue = ( select max(total_revenue) from revenue ) order by s_suppkey;
drop view revenue;

-- Q16 在WHERE子句中使用子查询，使用IN/ NOT IN判断条件，并统计(COUNT)
select p_brand, p_type, p_size, count(distinct ps_suppkey) as supplier_cnt from partsupp, part where p_partkey = ps_partkey and p_brand <> 'Brand#45' and p_type not like 'MEDIUM POLISHED%' and p_size in (49, 14, 23, 45, 19, 3, 36, 9) and ps_suppkey not in ( select s_suppkey from supplier where s_comment like '%Customer%Complaints%' ) group by p_brand, p_type, p_size order by supplier_cnt desc, p_brand, p_type, p_size;

-- Q17 在WHERE子句中使用子查询，使用<比较，使用了AVG函数
select sum(l_extendedprice) / 7.0 as avg_yearly from lineitem,part where p_partkey = l_partkey and p_brand = 'Brand#23' and p_container = 'MED BOX' and l_quantity < ( select 0.2 * avg(l_quantity) from lineitem where l_partkey = p_partkey );

-- Q18 在WHERE子句中使用IN条件从子查询结果中比较
select c_name, c_custkey, o_orderkey, o_orderdate, o_totalprice, sum(l_quantity) from customer, orders, lineitem where o_orderkey in ( select l_orderkey from lineitem group by l_orderkey having sum(l_quantity) > 300 ) and c_custkey = o_custkey and o_orderkey = l_orderkey group by c_name, c_custkey, o_orderkey, o_orderdate, o_totalprice order by o_totalprice desc, o_orderdate;

-- Q19 多条件比较查询
select sum(l_extendedprice* (1 - l_discount)) as revenue from lineitem, part where ( p_partkey = l_partkey and p_brand = 'Brand#12' and p_container in ('SM CASE', 'SM BOX', 'SM PACK', 'SM PKG') and l_quantity >= 1 and l_quantity <= 1 + 10 and p_size between 1 and 5 and l_shipmode in ('AIR', 'AIR REG') and l_shipinstruct = 'DELIVER IN PERSON' ) or ( p_partkey = l_partkey and p_brand = 'Brand#23' and p_container in ('MED BAG', 'MED BOX', 'MED PKG', 'MED PACK') and l_quantity >= 10 and l_quantity <= 10 + 10 and p_size between 1 and 10 and l_shipmode in ('AIR', 'AIR REG') and l_shipinstruct = 'DELIVER IN PERSON' ) or ( p_partkey = l_partkey and p_brand = 'Brand#34' and p_container in ('LG CASE', 'LG BOX', 'LG PACK', 'LG PKG') and l_quantity >= 20 and l_quantity <= 20 + 10 and p_size between 1 and 15 and l_shipmode in ('AIR', 'AIR REG') and l_shipinstruct = 'DELIVER IN PERSON' );

-- Q20 WHERE条件子查询(三层)
select s_name, s_address from supplier, nation where s_suppkey in ( select ps_suppkey from partsupp where ps_partkey in ( select p_partkey from part where p_name like 'forest%' ) and ps_availqty > ( select 0.5 * sum(l_quantity) from lineitem where l_partkey = ps_partkey and l_suppkey = ps_suppkey and l_shipdate >= date('1994-01-01') and l_shipdate < date('1995-01-01') ) ) and s_nationkey = n_nationkey and n_name = 'CANADA' order by s_name;

-- Q21 在WHERE条件中使用子查询，使用EXISTS和NOT EXISTS判断
select s_name, count(*) as numwait from supplier, lineitem l1, orders, nation where s_suppkey = l1.l_suppkey and o_orderkey = l1.l_orderkey and o_orderstatus = 'F' and l1.l_receiptdate > l1.l_commitdate and exists ( select * from lineitem l2 where l2.l_orderkey = l1.l_orderkey and l2.l_suppkey <> l1.l_suppkey ) and not exists ( select * from lineitem l3 where l3.l_orderkey = l1.l_orderkey and l3.l_suppkey <> l1.l_suppkey and l3.l_receiptdate > l3.l_commitdate ) and s_nationkey = n_nationkey and n_name = 'SAUDI ARABIA' group by s_name order by numwait desc, s_name;

-- Q22 在WHERE条件中使用判断子查询、IN、NOT EXISTS，并统计(SUM、COUNT)查询结果
select cntrycode, count(*) as numcust, sum(c_acctbal) as totacctbal from ( select substring(c_phone,1 ,2) as cntrycode, c_acctbal from customer where substring(c_phone ,1,2) in ('13','31','23','29','30','18','17') and c_acctbal > ( select avg(c_acctbal) from customer where c_acctbal > 0.00 and substring(c_phone,1,2) in ('13', '31', '23', '29', '30', '18', '17') ) and not exists ( select * from orders where o_custkey = c_custkey ) ) as custsale group by cntrycode order by cntrycode;

select count(L_ORDERKEY) , count(L_PARTKEY) , count(L_SUPPKEY), count(L_LINENUMBER), count(L_QUANTITY), count(L_EXTENDEDPRICE), count(L_DISCOUNT), count(L_TAX), count(L_RETURNFLAG), count(L_LINESTATUS), count(L_SHIPDATE), count(L_COMMITDATE), count(L_RECEIPTDATE), count(L_SHIPINSTRUCT), count(L_SHIPMODE), count(L_COMMENT) from lineitem;

