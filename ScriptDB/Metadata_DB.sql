use master
DROP DATABASE IF EXISTS Project_Metadata_DB;
go

create database Project_Metadata_DB
go
use Project_Metadata_DB
go


--DROP TABLE ETL_Metadata
CREATE TABLE ETL_Metadata(
  SourceName VARCHAR(50) PRIMARY KEY,
  LSET DATETIME NOT NULL DEFAULT '1900-01-01' -- initial value    
);

INSERT INTO ETL_Metadata (SourceName) VALUES
    ('Airline'),
    ('Airport'),
    ('Flight');


select * from ETL_Metadata;
--(CREATED >= @[User::LSET_Flight] || MODIFIED >= @[User::LSET_Flight]) && (CREATED < @[User::CET_Flight] || MODIFIED < @[User::CET_Flight])