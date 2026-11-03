create database Housing
use Housing 

select top 100 * from Housing_Data 

-----------------------------------------------
select * into test from Housing_Data
select * from test

-----------------------------------------------

select sales_type,AVG(cast(purchase_price as Bigint)) from test
group by sales_type

update test 
set sqm = 100 
where no_rooms = 3

select distinct sqm from test where no_rooms = 3

---------------------------------------------------
select * from test
update test set dk_ann_infl_rate = 0 where dk_ann_infl_rate is null

------------------------------------------------------
ALTER TABLE test ADD infl_new DECIMAL(10,2), yield_new DECIMAL(10,2);

UPDATE test SET
    infl_new  = DATEPART(HOUR, dk_ann_infl_rate)  + DATEPART(MINUTE, dk_ann_infl_rate)/100.0,
    yield_new = DATEPART(HOUR, yield_on_mortgage_credit_bonds) + DATEPART(MINUTE, yield_on_mortgage_credit_bonds)/100.0;

ALTER TABLE test DROP COLUMN dk_ann_infl_rate, yield_on_mortgage_credit_bonds;
EXEC sp_rename 'test.infl_new', 'dk_ann_infl_rate', 'COLUMN';
EXEC sp_rename 'test.yield_new', 'yield_on_mortgage_credit_bonds', 'COLUMN';

UPDATE test SET dk_ann_infl_rate = 0 WHERE dk_ann_infl_rate IS NULL;
update test set yield_on_mortgage_credit_bonds = 0 where yield_on_mortgage_credit_bonds is null
update test set nom_interest_rate = 3.1 where nom_interest_rate = 3.09999990463257
ALTER TABLE test ALTER COLUMN nom_interest_rate DECIMAL(10,2);

SELECT COLUMN_NAME, DATA_TYPE, NUMERIC_PRECISION, NUMERIC_SCALE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'test'
  AND COLUMN_NAME IN ('nom_interest_rate', 'dk_ann_infl_rate', 'yield_on_mortgage_credit_bonds');