create database House 
use House 

-------------------------------------------------------------------------------------------------------------------------
select * from Housing_Data 

select distinct dk_ann_infl_rate from Housing_Data
select distinct city,house_id from Housing_Data where city is null
select city,house_id from Housing_Data where house_id = 173270

-------------------------------------------------------------------------------------------------------------------------
-- Update null values in city column 
select distinct city from Housing_Data 
update Housing_Data set city = 'Arsted' where city is null

-------------------------------------------------------------------------------------------------------------------------
-- Update null values in dk_annl_infl column 
select distinct dk_ann_infl_rate from Housing_Data
select max(dk_ann_infl_rate) from Housing_Data

--07:07:00.0000000
update Housing_Data	set dk_ann_infl_rate = '07:07:00.0000000' where dk_ann_infl_rate is null 

-------------------------------------------------------------------------------------------------------------------------
-- Update yield_on_mortgage_credit_bonds column 
select distinct(yield_on_mortgage_credit_bonds) from Housing_Data
-- 10:14:00.0000000
update Housing_Data set yield_on_mortgage_credit_bonds = '10:14:00.0000000' where yield_on_mortgage_credit_bonds is null 

-------------------------------------------------------------------------------------------------------------------------
-- Check another null values 
select * from Housing_Data 


select distinct house_type from Housing_Data where house_type is null


