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


-- ##############################################

select * from dbo.nyctaxi_yellow

    SELECT * FROM metadata.processing_log

        SELECT * FROM stg.nyctaxi_yellow

        SELECT distinct VendorID FROM stg.nyctaxi_yellow
SELECT * from stg.nyctaxi_zone_lkp

SELECT top 1 latest_processed_pickup
from metadata.processing_log
where processed_tbl_name = 'stg.nyctaxi_yellow'
ORDER by latest_processed_pickup desc


SELECT MAX(tpep_pickup_datetime) , MIN(tpep_pickup_datetime) from stg.nyctaxi_yellow 
