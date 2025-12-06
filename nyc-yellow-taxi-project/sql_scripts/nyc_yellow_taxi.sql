CREATE SCHEMA stg;
GO
CREATE PROCEDURE
    stg.nyctaxi_yellow_tbl_cleaning
    @end_dt DATETIME2,
    @strt_dt DATETIME2
    AS
        DELETE FROM
            stg.nyctaxi_yellow
        WHERE
            tpep_pickup_datetime < @strt_dt
            OR
                tpep_pickup_datetime > @end_dt;
GO
CREATE SCHEMA metadata;
GO


CREATE TABLE
    metadata.processing_log (
        pipeline_run_id VARCHAR (255),
        processed_tbl_name VARCHAR (255),
        rows_processed INT,
        latest_processed_pickup DATETIME2 (6),
        processed_datetime DATETIME2 (6)
    );
GO


CREATE PROCEDURE
    metadata.insert_staging_metadata
    @pipeline_run_id VARCHAR (255),
    @tbl_name VARCHAR (255),
    @process_date AS DATE
AS
    INSERT INTO
        metadata.processing_log (
            pipeline_run_id,processed_tbl_name,rows_processed,latest_processed_pickup,processed_datetime)
        SELECT
            @pipeline_run_id AS pipeline_run_id,
            @tbl_name AS processed_tbl_name,
            count (1)
            AS rows_processed,
            MAX (tpep_pickup_datetime) AS latest_processed_pickup,
            @process_date AS processed_datetime
        FROM
            stg.nyctaxi_yellow ;
GO

CREATE TABLE dbo.nyctaxi_yellow
(
	vendor varchar(50),
	tpep_pickup_datetime date,
	tpep_dropoff_datetime date,
	pu_borough varchar(100),
	pu_zone varchar(100),
	do_borough varchar(100),
	do_zone varchar(100),
	payment_method varchar(50),
	passenger_count int,
	trip_distance FLOAT,
	total_amount FLOAT
);
GO


CREATE PROCEDURE
    metadata.insert_presentation_metadata
    @pipeline_run_id VARCHAR (255),
    @tbl_name VARCHAR (255),
    @process_date AS DATE
AS
    INSERT INTO
        metadata.processing_log (
            pipeline_run_id,processed_tbl_name,rows_processed,latest_processed_pickup,processed_datetime)
        SELECT
            @pipeline_run_id AS pipeline_run_id,
            @tbl_name AS processed_tbl_name,
            count (1)
            AS rows_processed,
            MAX (tpep_pickup_datetime) AS latest_processed_pickup,
            @process_date AS processed_datetime
        FROM
            dbo.nyctaxi_yellow ;
GO

CREATE PROCEDURE
    dbo.insert_nyctaxi_yellow
AS
    INSERT INTO
        dbo.nyctaxi_yellow (
	vendor ,tpep_pickup_datetime,tpep_dropoff_datetime 	,pu_borough 	,pu_zone ,do_borough 	,do_zone 	
    ,payment_method ,passenger_count ,trip_distance ,total_amount )
        SELECT
            case when [VendorID]= 1 then 'Creative Mobile Technologies'
             when [VendorID]= 2 then 'Curb Mobility'
             when [VendorID]= 6 then 'Myle Technologies Inc'
             when [VendorID]= 7 then 'Helix'
            else 'Unknown' end    as vendor ,
            CAST ( [tpep_pickup_datetime] as Date ) AS tpep_pickup_datetime,
			cast ( [tpep_dropoff_datetime] as Date ) As tpep_dropoff_datetime ,
            nycl.[Borough] as pu_borough , 
            nycl.[Zone] as pu_zone , 
            nycl2.[Borough] as bo_borough ,
            nycl2.[Zone] as bo_zone ,
			case when [payment_type] = 0 then 'Flex Fare trip' 
                when [payment_type] = 1 then 'Credit card' 
                when [payment_type] = 2 then 'Cash' 
                when [payment_type] = 3 then 'No charge' 
                when [payment_type] = 4 then 'Dispute' 
                when [payment_type] = 5 then 'Unknown'
                when [payment_type] = 6 then 'Voided trip'
            else 'Unknown' end as payment_method , 
            [passenger_count] , 
            [trip_distance],
			[total_amount]
FROM [stg].[nyctaxi_yellow ] nycy 
       left join  [stg].[nyctaxi_zone_lkp] nycl on nycy.[PULocationID]= nycl.[LocationID]
        left join    [stg].[nyctaxi_zone_lkp] nycl2 on nycy.[DOLocationID]= nycl2.[LocationID];
GO

-- ##############################################

-- select * from dbo.nyctaxi_yellow

--     SELECT * FROM metadata.processing_log

--         SELECT * FROM stg.nyctaxi_yellow

--         SELECT distinct VendorID FROM stg.nyctaxi_yellow
-- SELECT * from stg.nyctaxi_zone_lkp

-- SELECT top 1 latest_processed_pickup
-- from metadata.processing_log
-- where processed_tbl_name = 'stg.nyctaxi_yellow'
-- ORDER by latest_processed_pickup desc


-- SELECT MAX(tpep_pickup_datetime) , MIN(tpep_pickup_datetime) from stg.nyctaxi_yellow 

-- SELECT MAX(tpep_pickup_datetime) , MIN(tpep_pickup_datetime) from dbo.nyctaxi_yellow 
