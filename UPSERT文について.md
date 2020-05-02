# UPSERT文について

[MERGEでINSERTとUPDATEを1行で実行する  |  ソフトウェア開発日記](https://lightgauge.net/database/sqlserver/2446/)



以下はデータが存在した場合のUPDATE（更新）の例です。

``` sql
CREATE TABLE test_table
(
    no       INT
    ,name    VARCHAR(20)
    ,age     INT
)

INSERT INTO test_table VALUES( 10,'次郎さん',40)

MERGE INTO test_table AS A
    USING (SELECT 10 AS no,'太郎さん' AS name, 30 AS age ) AS B
    ON
    (
       A.no = B.no
    )
    WHEN MATCHED THEN
        UPDATE SET
             name = B.name
            ,age = B.age
    WHEN NOT MATCHED THEN
        INSERT (no,name,age)
        VALUES
        (
             B.no
            ,B.name
            ,B.age
        )
;

SELECT no, name, age FROM test_table ORDER BY no

DROP TABLE test_table
```

上記の実行結果は
```
no    name     age
10   太郎さん   30
```
になります。



``` sql
CREATE TABLE test_tableA
(
    no       INT
    ,name    VARCHAR(20)
    ,age     INT
)
CREATE TABLE test_tableB
(
    no       INT
    ,name    VARCHAR(20)
    ,age     INT
)
 
INSERT INTO test_tableA VALUES( 10,'太郎さんA',100)
INSERT INTO test_tableB VALUES( 10,'太郎さんB',30)
 
MERGE INTO test_tableA AS A
    USING test_tableB AS B
    ON
    (
       A.no = B.no
    )
    WHEN MATCHED THEN
        UPDATE SET
             name = B.name
            ,age = B.age
    WHEN NOT MATCHED THEN
        INSERT (no,name,age)
        VALUES
        (
             B.no
            ,B.name
            ,B.age
        )
;
 
SELECT no, name, age FROM test_tableA ORDER BY no
 
DROP TABLE test_tableA
DROP TABLE test_tableB
```

上記の実行結果は

```
no    name    age
10  太郎さんB  30
```