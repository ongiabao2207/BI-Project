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
	LSET DATETIME NOT NULL DEFAULT '1900-01-01', -- initial value
	CET DATETIME NOT NULL DEFAULT '1900-01-01'
);

INSERT INTO ETL_Metadata (SourceName) VALUES
    ('Stage_Airline'),
    ('Stage_Airport'),
    ('Stage_Flight'),
	('DDS_Airline'),
    ('DDS_Airport'),
    ('DDS_Flight');
--update ETL_Metadata set lset = '1900-01-01', CET = '1900-01-01' where SourceName like 'DDS_%'


select * from ETL_Metadata;
--(CREATED >= @[User::LSET_Flight] || MODIFIED >= @[User::LSET_Flight]) && (CREATED < @[User::CET_Flight] || MODIFIED < @[User::CET_Flight])


CREATE TABLE Flight_ETL_ErrorLog (
    ErrorLog_ID BIGINT IDENTITY(1,1) PRIMARY KEY,
    
    -- 1. Thông tin định danh chuyến bay bị lỗi (để truy vết)
    Date DATE,
    Flight_number VARCHAR(10),
    Scheduled_departure VARCHAR(10),
    Origin_Airport CHAR(3),
    Dest_Airport CHAR(3),
    Source_ID INT,
    
    -- 2. Thông tin chi tiết về lỗi
    Error_Column VARCHAR(50) NULL,      -- Trường bị lỗi (ví dụ: 'Canceled_Reason', 'Departure_delay')
    Error_Description NVARCHAR(512) NOT NULL, -- Chi tiết mô tả lỗi
    Error_Value VARCHAR(200) NULL, -- Lưu trữ giá trị gây lỗi
    
    -- 3. Thời gian và quá trình
    SSIS_Package VARCHAR(100) NULL, -- Tên package trong SSIS gây ra lỗi
    Error_Timestamp DATETIME NOT NULL DEFAULT GETDATE()
);

select * from Flight_ETL_ErrorLog;




CREATE TABLE RuleType (
	Rule_Type_ID CHAR(1) PRIMARY KEY,
	Rule_Type_Name VARCHAR(10)
)

INSERT INTO RuleType VALUES
('E', 'Errors'),
('W', 'Warning');




CREATE TABLE DQ_Rules (
	Rule_ID INT IDENTITY(1,1) PRIMARY KEY,
	Rule_Name VARCHAR(50),
	Description VARCHAR(200),
	Rule_Type_ID CHAR(1),
	Created DATETIME NOT NULL DEFAULT GETDATE(),
	Modified DATETIME NOT NULL DEFAULT GETDATE()
)

ALTER TABLE DQ_Rules ADD CONSTRAINT FK_RULETYPE FOREIGN KEY (Rule_Type_ID) REFERENCES RuleType(Rule_Type_ID);

INSERT INTO DQ_Rules (Rule_Name, Description, Rule_Type_ID)
VALUES 
-- Luật 1: Kiểm tra tính tồn tại của mã lý do hủy chuyến
(
    'The cancellation reason scope', 
    'Cancellation reason is undefined.', 
    'E'
),
-- Luật 2: Kiểm tra tính toàn vẹn của khóa tự nhiên (Natural Key)
(
    'The integrity of the flight natural key', 
    'Missing in the natural key of the flight.', 
    'E'
);

select * from DQ_Rules;