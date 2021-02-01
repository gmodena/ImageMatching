-- DDL to create an external table that exposes samples of the raw tsv output of
-- extract_medata_from_candidates.ipynb.
-- The default HDFS location and Hive database are relative to a developer's.
-- username. Example hdfs://analytics-hadoop/user/gmodena/imagerec/data.
--
-- Data is expected to be partitioned by
-- * wiki_db: the wiki language for the target dataset
-- * snapshot: time period on which data was aggregated (YYYY-MM)
--
-- The paritioned HDFS path for 2020-12 arwiki datasets will look like:
-- hdfs://analytics-hadoop/user/gmodena/imagerec/data/wiki_db=arwiki/snapshot=2020-12
--
-- The dataset will be available at https://superset.wikimedia.org/superset/sqllab via the 
-- `presto_analytics` database.
--
-- Execution
-- hive -hiveconf username=<username> -f external_imagerec.hql

USE ${hiveconf:username};

CREATE EXTERNAL TABLE IF NOT EXISTS `imagerec`(
  `pandas_idx` string,
  `item_id` string,
  `page_id` string,
  `page_title` string,
  `selected` string,
  `notes` string,
  `descriptions` string,
  `captions` string,
  `categories` string,
  `depicts` string,
  `size` string,
  `copyright` string,
  `date` string,
  `user` string,
  `image_type` string)
PARTITIONED BY (
  `wiki_db` string,
  `snapshot` string)
ROW FORMAT SERDE
  'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'
WITH SERDEPROPERTIES (
  'field.delim'='\t',
  'serialization.format'='\t')
STORED AS INPUTFORMAT
  'org.apache.hadoop.mapred.TextInputFormat'
OUTPUTFORMAT
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  'hdfs://analytics-hadoop/user/${hiveconf:username}/imagerec/data';

-- Update partition metadata
MSCK REPAIR TABLE `imagerec`;
