SELECT max(tpep_pickup_datetime) , min(tpep_pickup_datetime)   from stg.nyctaxi_yellow


delete from  stg.nyctaxi_yellow
where tpep_pickup_datetime < '2025-01-01' 
or tpep_pickup_datetime > '2025-02-01'

select count(1) from stg.nyctaxi_yellow


alter procedure stg.nyctaxi_yellow_tbl_cleaning
@end_dt DATETIME2,
@strt_dt DATETIME2
AS
delete from  stg.nyctaxi_yellow
where tpep_pickup_datetime < @strt_dt
 or tpep_pickup_datetime > @end_dt ; 








