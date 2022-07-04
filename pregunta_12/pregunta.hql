
DROP TABLE IF EXISTS t0;
CREATE TABLE t0 (
    c1 STRING,
    c2 ARRAY<CHAR(1)>, 
    c3 MAP<STRING, INT>
    )
    ROW FORMAT DELIMITED 
        FIELDS TERMINATED BY '\t'
        COLLECTION ITEMS TERMINATED BY ','
        MAP KEYS TERMINATED BY '#'
        LINES TERMINATED BY '\n';
LOAD DATA LOCAL INPATH 'data.tsv' INTO TABLE t0;

DROP TABLE IF EXISTS result_data;
CREATE TABLE result_data AS
SELECT c2_letter, key AS c3_letter, value AS c3_number 
FROM 
    (SELECT c2_letter, c3
    FROM t0
    LATERAL VIEW explode(c2) t0 AS c2_letter) AS t1
LATERAL VIEW explode(c3) t1;

INSERT OVERWRITE LOCAL DIRECTORY './output'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
SELECT c2_letter, c3_letter, COUNT(1) FROM result_data GROUP BY c2_letter, c3_letter ORDER BY c2_letter, c3_letter;
