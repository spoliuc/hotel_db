--Sebastian Poliuc
--INSY 3304
--Project 3, Spring 2021

spool 'C:\Users\sebas\iCloudDrive\Documents\project3_sap.txt'
set echo on

start C:\Users\sebas\Downloads\project2_sap-1.sql

--Formatting

SET LINESIZE 150
SET PAGESIZE 50
COLUMN CustType FORMAT a15
COLUMN RateType FORMAT a15
COLUMN AgentType FORMAT a15
COLUMN RoomType FORMAT a15

--Problem 1

UPDATE RESDETAIL_sap
   SET RateAmt = 110, RoomNum = 321
 WHERE ResNum = 1010 ;
 
UPDATE RESERVATION_sap
   SET RateType = 'C'
 WHERE ResNum = 1010 ;

UPDATE RESERVATION_sap
   SET CheckOut = '8-SEP-2020'
 WHERE ResNum = 1001 ;
 
--Problem 2
 
UPDATE CUSTOMER_sap
   SET LoyaltyID = 403, CustPhone = '2145551000'
 WHERE CustID = 120 ;

UPDATE RESERVATION_sap
   SET CheckIn = '8-OCT-2020', CheckOut = '11-OCT-2020'
 WHERE ResNum = 1011 ;
 
--Problem 3
 
INSERT INTO ROOM_sap
VALUES (301, 'D') ;
INSERT INTO ROOM_sap
VALUES (303, 'DS') ;
INSERT INTO ROOM_sap
VALUES (304, 'KS') ;

--Problem 4

INSERT INTO RESDETAIL_sap
VALUES (1005, 303, 139) ;
INSERT INTO RESDETAIL_sap
VALUES (1005, 304, 149) ;

UPDATE RESERVATION_sap
   SET GuestCount = 2
 WHERE ResNum = 1005 ;
 
--Problem 5
 
INSERT INTO CUSTOMER_sap
VALUES ((SELECT (MAX(CustID)+1) FROM CUSTOMER_sap), 'Susan', 'White', 2145552020, 'C', NULL) ;

--Problem 6

COMMIT ;

--Problem 7

SELECT CustID, CustFName, CustLName
FROM CUSTOMER_sap
WHERE CustPhone IS NULL 
ORDER BY CustID ;

--Problem 8

SELECT AVG(RateAmt) AS "AvgRate" 
FROM RESDETAIL_sap ;

--Problem 9

SELECT COUNT ( DISTINCT RoomNum ) AS "RoomResCount"
FROM RESDETAIL_sap ; 

--Problem 10

SELECT RoomType AS "RoomType", COUNT(RoomNum) AS "RoomCount"
FROM ROOM_sap
GROUP BY RoomType ;

--Problem 11

SELECT A.ResNum AS "ResNum", CheckIn AS "CheckIn", CheckOut AS "CheckOut", COUNT(RoomNum) AS "RoomCount"
FROM RESERVATION_sap A, RESDETAIL_sap B
WHERE A.ResNum = B.ResNum
GROUP BY A.ResNum, CheckIn, CheckOut
ORDER BY A.ResNum ;

--Problem 12

SELECT A.CustID, CustFName || ' ' || CustLName AS "CustName", COUNT(ResNum) AS "ResCount"
FROM CUSTOMER_sap A, RESERVATION_sap B
WHERE A.CustID = B.CustID
GROUP BY A.CustID, CustFName, CustLName
ORDER BY "ResCount" DESC, A.CustID;

--Problem 13

SELECT ResNum AS "ResNum", RoomNum AS "RmNum", RateAmt AS "RateAmt"
FROM RESDETAIL_sap
ORDER BY ResNum, RoomNum ;

--Problem 14

SELECT A.RateType AS "RateType", RateDesc AS "Description", COUNT(RoomNum) AS "ResCount"
FROM RATETYPE_sap A, RESERVATION_sap B, RESDETAIL_sap C
WHERE A.RateType = B.RateType AND 
	C.ResNum = B.ResNum
GROUP BY A.RateType, RateDesc
ORDER BY "ResCount" DESC ;

--Problem 15

SELECT CustID AS "Customer_ID", CustFName AS "First_Name", CustLName AS "Last_Name", ('(' || SUBSTR(CustPhone, 1,3) || ')' || ' ' || SUBSTR(CustPhone, 4, 3) || '-' || SUBSTR(CustPhone, 7, 4)) AS "CustPhone" 
FROM CUSTOMER_sap
ORDER BY CustID ;

--Problem 16

SELECT RS.ResNum AS "ResNum", RD.RoomNum AS "RmNum", RO.RoomType AS "RmType", RT.RoomDesc AS "RmDesc", RS.RateType AS "RateType", RA.RateDesc AS "RateDesc", TO_CHAR(RateAmt, '$999.99') AS "RateAmt"
FROM RESERVATION_sap RS, RESDETAIL_sap RD, ROOMTYPE_sap RT, RATETYPE_sap RA, ROOM_sap RO
WHERE RS.ResNum = RD.ResNum AND RO.RoomNum = RD.RoomNum AND RO.RoomType = RT.RoomType AND RS.RateType = RA.RateType AND (RS.ResNum, RD.RateAmt) IN (SELECT ResNum, MIN(RateAmt) FROM RESDETAIL_sap GROUP BY ResNum)
GROUP BY RS.ResNum, RD.RoomNum, RO.RoomType, RT.RoomDesc, RS.RateType, RA.RateDesc, RD.RateAmt
ORDER BY RD.RateAmt DESC ;

--Problem 17

SELECT RD.RoomNum, RO.RoomType, RT.RoomDesc, R.RateType, RD.RateAmt 
FROM RESERVATION_sap R, RESDETAIL_sap RD, ROOM_sap RO, ROOMTYPE_sap RT 
WHERE R.ResNum = RD.ResNum AND RD.RoomNum = RO.RoomNum AND RO.RoomType = RT.RoomType
ORDER BY RD.RoomNum, RD.RateAmt;

--Problem 18

SELECT C.CustType "CustType", CustDesc AS "Description", COUNT(CustID) AS "Count"
FROM CUSTOMER_sap C, CUSTTYPE_sap CT
WHERE C.CustType= CT.CustType
GROUP BY C.CustType,CustDesc
ORDER BY "Count" DESC;

--Problem 19 

SELECT ResNum, RD.RoomNum, RO.RoomType, RoomDesc, TO_CHAR(RateAmt,'$999.00') AS "RateAmt"
FROM RESDETAIL_sap RD, ROOM_sap RO, ROOMTYPE_sap RT
WHERE RD.RoomNum = RO.RoomNum AND RO.RoomType = RT.RoomType AND RateAmt <=119
ORDER BY RateAmt DESC, RD.RoomNum ASC;

--Problem 20

SELECT RE.ResNum, TO_CHAR(CheckIn,'mm-dd-yyyy') AS "CheckIn", TO_CHAR(CheckOut,'mm-dd-yyyy') AS "CheckOut", RE.CustID, CustFName, CustLName, count(RoomNum) AS "RoomCount"
FROM RESERVATION_sap RE, CUSTOMER_sap CU, RESDETAIL_sap RD
WHERE RE.CustID=CU.CustID
AND RE.ResNum=RD.ResNum
GROUP BY RE.ResNum, CheckIn, CheckOut, RE.CustID,CustFName,CustLName
ORDER BY ResNum;

--Problem 21

SELECT RD.ResNum, RD.RoomNum AS "RmNum", RoomDesc AS "RmType", RateDesc AS "RateType", TO_CHAR(RateAmt,'$000.00') AS "RateAmt"
FROM RESERVATION_sap R, RESDETAIL_sap RD, RATETYPE_sap RT, ROOM_sap RO, ROOMTYPE_sap RX
WHERE R.ResNum = RD.ResNum AND RD.RoomNum = RO.RoomNum AND R.RateType = RT.RateType AND RX.RoomType = RO.RoomType AND RateAmt in (SELECT MAX(RateAmt) FROM RESDETAIL_sap WHERE ResNum=1005) AND RD.ResNum=1005;

--Problem 22

SELECT AG.AgentType AS "AgentType", AgentDesc AS "Desc", COUNT(DISTINCT AG.AgentID) AS "Count"
FROM AGENT_sap AG, AGENTTYPE_sap AT, RESERVATION_sap RE
WHERE AG.AgentID = RE.AgentID AND AG.AgentType = AT.AgentType
GROUP BY AG.AgentType, AgentDesc;

--Problem 23

SELECT RD.ResNum, RD.RoomNum, RoomDesc, RateDesc, RateAmt
FROM RESERVATION_sap RE, RESDETAIL_sap RD, RATETYPE_sap RT, ROOM_sap RO, ROOMTYPE_sap RX
WHERE RE.ResNum = RD.ResNum AND RD.RoomNum = RO.RoomNum AND RE.RateType = RT.RateType AND RX.RoomType = RO.RoomType AND RateAmt > (SELECT AVG(RateAmt) FROM RESDETAIL_sap)
ORDER BY RoomNum;

--Problem 24

SELECT DISTINCT RD.RoomNum AS "RmNum", RoomDesc AS "RmType", RateDesc AS "RateType", TO_CHAR(RateAmt,'$000.00') AS "RateAmt"
FROM RESERVATION_sap RE, RESDETAIL_sap RD, RATETYPE_sap RT, ROOM_sap RO, ROOMTYPE_sap RX
WHERE RD.ResNum = RE.ResNum AND RD.RoomNum = RO.RoomNum AND RE.RateType = RT.RateType AND RX.RoomType = RO.RoomType AND RateAmt>115
ORDER BY "RateAmt" DESC;

--Problem 25

SELECT RO.RoomNum, RO.RoomType, COUNT(RD.RoomNum) AS "ResCount"
FROM RESDETAIL_sap RD FULL OUTER JOIN ROOM_sap RO ON RD.RoomNum = RO.RoomNum, ROOMTYPE_sap RT
WHERE RT.RoomType = RO.RoomType
GROUP BY RO.RoomNum, RO.RoomType
ORDER BY COUNT(ResNum);

--Problem 26

SELECT CustID AS "CustID", CustFName AS "FirstName", CustLName AS "LastName", '(' || SUBSTR(CUSTPHONE,1,3) || ')-' || SUBSTR(CUSTPHONE,4,3) || '-' || SUBSTR(CUSTPHONE,7,4) AS "Phone"
FROM CUSTOMER_sap
WHERE LoyaltyID IS NOT NULL;

--Problem 27

SELECT RD.RoomNum AS "Room", RoomDesc AS "RoomType", RateDesc AS "RateType", TO_CHAR(RateAmt,'$999.00') AS "Amt"
FROM RESERVATION_sap RE, RESDETAIL_sap RD, RATETYPE_sap RT, ROOM_sap RO, ROOMTYPE_sap RX
WHERE RE.ResNum = RD.ResNum AND RD.RoomNum = RO.RoomNum AND RE.RateType = RT.RateType 
AND RX.RoomType = RO.RoomType AND RateAmt IN (SELECT MAX(RateAmt) FROM RESDETAIL_sap WHERE ResNum=1005) 
AND RD.ResNum=1005;

--Problem 28

SELECT RE.ResNum, CheckIn, CheckOut, RE.CustID, CustLName, RE.AgentID, AgentLName
FROM RESERVATION_sap RE, AGENT_sap AG, CUSTOMER_sap CU
WHERE RE.CustID = CU.CustID AND RE.AgentID = AG.AgentID AND CheckIn <= '26-SEP-2020'
ORDER BY CheckIn, ResNum;

--Problem 29

SELECT RD.RoomNum, RO.RoomType, RoomDesc, RateAmt
FROM RESDETAIL_sap RD, ROOM_sap RO, ROOMTYPE_sap RT
WHERE RD.RoomNum = RO.RoomNum AND RT.RoomType = RO.RoomType AND RateAmt > (SELECT AVG(RateAmt) FROM RESDETAIL_sap)
ORDER BY RateAmt DESC, RoomNum ASC;

--Problem 30

SELECT COUNT(CustID) AS "LoyaltyCount"
FROM CUSTOMER_sap
WHERE LoyaltyID IS NOT NULL ;

--Problem 31

SELECT RE.AgentID AS "AgentID", AgentFName || ' ' || AgentLName AS "Agent", COUNT(ResNum) AS "ResCount"
FROM RESERVATION_sap RE, AGENT_sap AG
WHERE RE.AgentID = AG.AgentID
GROUP BY RE.AgentID, AgentFName, AgentLName
ORDER BY "ResCount" DESC;

--Problem 32

SELECT RE.AgentID AS "AgentID", AgentFName AS "FirstName", AgentLName AS "LastName", COUNT(ResNum) AS "ResCount"
FROM RESERVATION_sap RE, AGENT_sap AG
WHERE RE.AgentID= AG.AgentID
GROUP BY RE.AgentID, AgentFName, AgentLName
HAVING COUNT(ResNum)>1
ORDER BY "ResCount" DESC, RE.AgentID ASC ;

--Problem 33

SELECT CustID AS "Customer_ID", CustFName AS "First_Name", CustLName AS "Last_Name"
FROM CUSTOMER_sap
WHERE CustFName LIKE 'W%' OR CustLName LIKE 'W%'
ORDER BY "Last_Name";

--Problem 34

SELECT CustID AS "CustID", CustFName AS "FirstName", CustLName AS "LastName"
FROM CUSTOMER_sap
WHERE CustID NOT IN (SELECT CustID FROM RESERVATION_sap);

--Problem 35

SELECT RE.ResNum AS ResNum, RD.RoomNum, (CheckOut-CheckIn)*RateAmt AS Total
FROM RESERVATION_sap RE, RESDETAIL_sap RD
WHERE RE.ResNum = RD.ResNum AND RE.ResNum = 1005;

COMMIT ;



spool off
set echo off

