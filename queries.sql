-- 0.CSV data import: Carriers, USAirports, Flights

LOAD DATA LOCAL INFILE 
'/media/x/Data/Lab/itAcademy/02_SQL/exercises/queries/USFlights/USFlights/data/carriers.csv'
INTO TABLE Carriers
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;


LOAD DATA LOCAL INFILE 
'/media/x/Data/Lab/itAcademy/02_SQL/exercises/queries/USFlights/USFlights/data/airports.csv'
INTO TABLE USAirports
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


LOAD DATA LOCAL INFILE 
'/media/x/Data/Lab/itAcademy/02_SQL/exercises/queries/USFlights/USFlights/data/flights.csv'
INTO TABLE Flights
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(colYear,colMonth,DayOfMonths,DayOfWeek,DepTime,CRSDepTime,
ArrTime,CRSArrTime,UniqueCarrier,FlightNum,TailNum,
ActualElapsedTime,CRSElapsedTime,AirTime,ArrDelay,
DepDelay,Origin,Dest,Distance,TaxiIn,TaxiOut,Cancelled,
CancellationCode,Diverted,@dummy,@dummy,@dummy,@dummy,@dummy);



-- 1.Quantitat de registres de la taula de vols:

SELECT COUNT(*) FROM Flights;



-- 2.Retard promig de sortida i arribada segons l’aeroport origen

SELECT 
    Origin,
    FORMAT(AVG(ArrDelay), 4) AS prom_arribades,
    FORMAT(AVG(DepDelay), 4) AS prom_sortides
FROM
    Flights
GROUP BY Origin
ORDER BY Origin;



-- 3.Retard promig d’arribada dels vols, per mesos i segons l’aeroport origen

SELECT 
    Origin,
    colYear,
    colMonth,
    FORMAT(AVG(ArrDelay), 4) AS prom_arribades
FROM
    Flights
GROUP BY Origin , colYear , colMonth
ORDER BY Origin;



-- 4.Retard promig d’arribada dels vols, per mesos i segons l’aeroport d'origen mostrant el nom de la ciutat

SELECT 
    USAirports.City,
    Flights.colYear,
    Flights.colMonth,
    FORMAT(AVG(Flights.ArrDelay), 4) AS prom_arribades
FROM
    Flights
        JOIN
    USAirports ON Flights.Origin = USAirports.IATA
GROUP BY Flights.Origin , Flights.colYear , Flights.colMonth
ORDER BY Flights.Origin;



-- 5.Les companyies amb més vols cancelats, ordenades de forma que les companyies amb més cancel·lacions apareguin les primeres

SELECT 
    UniqueCarrier,
    colYear,
    colMonth,
    SUM(Cancelled) AS total_cancelled
FROM
    Flights
WHERE
    (Cancelled = 1)
GROUP BY UniqueCarrier , colYear , colMonth
ORDER BY total_cancelled DESC;



-- 6.L’identificador dels 10 avions que més distància han recorregut fent vols

SELECT 
    TailNum, SUM(Distance) AS totalDistance
FROM
    Flights
WHERE
    (Cancelled = 0 AND TailNum != 'NA')
GROUP BY TailNum
ORDER BY totalDistance DESC
LIMIT 10;



-- 7. Companyies amb el seu retard promig només d’aquelles les quals els seus vols arriben al seu destí amb un retràs promig major de 10 minuts

SELECT * FROM
    (SELECT 
        UniqueCarrier, FORMAT(AVG(ArrDelay), 4) AS avgDelay
    FROM
        Flights
    GROUP BY UniqueCarrier
    ORDER BY avgDelay DESC) AS a
WHERE avgDelay > 10;



