/* 
Pregunta
===========================================================================

Para resolver esta pregunta use el archivo `data.tsv`.

Escriba una consulta que devuelva los cinco valores diferentes más pequeños 
de la tercera columna.

Apache Hive se ejecutará en modo local (sin HDFS).

Escriba el resultado a la carpeta `output` de directorio de trabajo.

        >>> Escriba su respuesta a partir de este punto <<<
*/

DROP TABLE IF EXISTS source_data;
DROP TABLE IF EXISTS result_data;
CREATE TABLE source_data
        (col_a STRING,
        col_b STRING,
        col_c INT)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
TBLPROPERTIES ("skip.header.line.count"="0");

LOAD DATA LOCAL INPATH "data.tsv" OVERWRITE INTO TABLE source_data;

CREATE TABLE result_data AS 
SELECT DISTINCT col_c AS valores 
FROM source_data 
ORDER BY col_c
LIMIT 5;

INSERT OVERWRITE LOCAL DIRECTORY './output'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
SELECT * FROM result_data;

