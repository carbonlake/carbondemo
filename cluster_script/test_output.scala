

3 * 4 cores
scale 10

					hash
no_sort:	75		145
local_sort:	98		178

newcompact 138.541 142



local sort 111
range no sort  59


| == CarbonData Profiler ==
Table Scan on dd
 - total: 9 blocks, 27 blocklets
 - filter: (col039 <> null and col039 = 18600055555)
 - pruned by Main DataMap
    - skipped: 0 blocks, 0 blocklets




explain select * from lineitem_no_sort where l_orderkey = 123456;
Table Scan on lineitem_no_sort
 - total: 42 blocks, 43 blocklets
 - filter: (l_orderkey <> null and l_orderkey = 123456)
 - pruned by Main DataMap
    - skipped: 41 blocks, 42 blocklets

explain select * from lineitem_hash_no_sort where l_orderkey = 123456;
Table Scan on lineitem_hash_no_sort
 - total: 40 blocks, 50 blocklets
 - filter: (l_orderkey <> null and l_orderkey = 123456)
 - pruned by Main DataMap
    - skipped: 30 blocks, 37 blocklets

explain select * from lineitem_hash_local where l_orderkey = 123456;
Table Scan on lineitem_hash_local
 - total: 40 blocks, 50 blocklets
 - filter: (l_orderkey <> null and l_orderkey = 123456)
 - pruned by Main DataMap
    - skipped: 30 blocks, 40 blocklets

explain select * from lineitem where l_orderkey = 123456;
Table Scan on lineitem
 - total: 13 blocks, 39 blocklets
 - filter: (l_orderkey <> null and l_orderkey = 123456)
 - pruned by Main DataMap
    - skipped: 8 blocks, 26 blocklets

@蔡强 david 测试结果：
造数据：1千万记录，手机号基数10万
LOCAL SORT入库1批，2批，3批分别测试
每次入库产生数据：每节点生成一个文件
查询explain select count(*) from dd where col039 = '18600055555';  一个block都过滤不掉。
和我们预期相符




ALTER TABLE T1 COMPACT WHERE SEGMENT.ID IN (0,1) AUTO PARTITIONED BY (C1)
ALTER TABLE T1 COMPACT 'PARTITION' WHEREE SEGMENT.ID IN (0,1) BY COLUMN C1
ALTER TABLE T1 AUTO PARTITIONED BY (C1) WHEREE SEGMENT.ID IN (0,1)


