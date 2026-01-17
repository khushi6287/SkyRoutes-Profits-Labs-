-- 1. Top 10 Most Frequent Routes
SELECT 
    RouteCode,
    COUNT(*) as NumberOfFlights
FROM AirlineRoutes
GROUP BY RouteCode
ORDER BY NumberOfFlights DESC
LIMIT 10;

-- 2. Add Revenue/Profit Calculations
-- Create a simple revenue table
CREATE TABLE RouteProfits AS
SELECT 
    FlightID,
    RouteCode,
    -- Estimate revenue: Base fare × number of passengers
    BaseFareUSD * 150 as EstimatedRevenue,
    -- Estimate cost: 70% of revenue + distance cost
    (BaseFareUSD * 150 * 0.7) + (DistanceKM * 0.08) as EstimatedCost
FROM AirlineRoutes;

-- Add profit column
ALTER TABLE RouteProfits 
ADD COLUMN EstimatedProfit DECIMAL(10,2);

UPDATE RouteProfits 
SET EstimatedProfit = EstimatedRevenue - EstimatedCost
WHERE FlightID IS NOT NULL;  

-- averages
SELECT 
    RouteCode,
    COUNT(*) as NumberOfFlights,
    ROUND(AVG(EstimatedRevenue), 2) as AvgRevenue,
    ROUND(AVG(EstimatedCost), 2) as AvgCost,
    ROUND(AVG(EstimatedProfit), 2) as AvgProfit
FROM RouteProfits
GROUP BY RouteCode
ORDER BY AvgProfit DESC
LIMIT 15;

-- 3. Find Losing Routes (Negative Profit)
SELECT 
    RouteCode,
    ROUND(AVG(EstimatedProfit), 2) as AverageProfit,
    COUNT(*) as FlightsOnThisRoute
FROM RouteProfits
GROUP BY RouteCode
HAVING AVG(EstimatedProfit) < 0  -- Only show routes with negative profit
ORDER BY AverageProfit ASC;  -- Worst losses first

-- 4. 	Calculate Seat Occupancy
-- Add seat capacity based on typical aircraft
ALTER TABLE AirlineRoutes 
ADD COLUMN SeatCapacity INT;

-- Update with typical values
-- 3. Update SeatCapacity
UPDATE AirlineRoutes 
SET SeatCapacity = 
    CASE 
        WHEN FlightDurationMin < 120 THEN 180
        WHEN FlightDurationMin BETWEEN 120 AND 300 THEN 250
        ELSE 300
    END
WHERE FlightID IS NOT NULL;

-- 4. Calculate everything on the fly - NO UPDATES NEEDED!
SELECT 
    RouteCode,
    Airline,
    FlightDurationMin,
    -- Calculate seat capacity
    CASE 
        WHEN FlightDurationMin < 120 THEN 180
        WHEN FlightDurationMin BETWEEN 120 AND 300 THEN 250
        ELSE 300
    END as SeatCapacity,
    -- Calculate passengers (70-95% full)
    ROUND(
        CASE 
            WHEN FlightDurationMin < 120 THEN 180
            WHEN FlightDurationMin BETWEEN 120 AND 300 THEN 250
            ELSE 300
        END * (0.70 + (RAND() * 0.25)), 
    0) as EstimatedPassengers,
    -- Calculate occupancy percentage
    ROUND(
        (ROUND(
            CASE 
                WHEN FlightDurationMin < 120 THEN 180
                WHEN FlightDurationMin BETWEEN 120 AND 300 THEN 250
                ELSE 300
            END * (0.70 + (RAND() * 0.25)), 
        0) * 100.0) /
        CASE 
            WHEN FlightDurationMin < 120 THEN 180
            WHEN FlightDurationMin BETWEEN 120 AND 300 THEN 250
            ELSE 300
        END,
    1) as OccupancyPercent
FROM AirlineRoutes
ORDER BY RouteCode
LIMIT 10;

-- 5. Create Monthly Data Table
-- Step 1: Create a simple months table
CREATE TABLE Months (
    MonthID INT PRIMARY KEY,
    MonthName VARCHAR(20)
);

-- Step 2: Insert months
INSERT INTO Months VALUES
(1, 'January'), (2, 'February'), (3, 'March'),
(4, 'April'), (5, 'May'), (6, 'June'),
(7, 'July'), (8, 'August'), (9, 'September'),
(10, 'October'), (11, 'November'), (12, 'December');

-- Step 3: Generate monthly profit data
SELECT 
    ar.RouteCode,
    m.MonthName,
    -- Calculate monthly profit (with some variation)
    ROUND(AVG(ar.BaseFareUSD * 150) * 
          (0.8 + (0.4 * m.MonthID / 12)), 2) as EstimatedProfit
FROM AirlineRoutes ar
CROSS JOIN Months m  -- Combine every route with every month
GROUP BY ar.RouteCode, m.MonthID, m.MonthName
HAVING ar.RouteCode IN ('BOM-DEL', 'JFK-LHR', 'DXB-LHR')  -- Just show a few
ORDER BY ar.RouteCode, m.MonthID;

-- 6. Domestic vs International Profitability Comparison
SELECT 
    CASE 
        WHEN DepartureCountry = ArrivalCountry 
        THEN 'Domestic' 
        ELSE 'International' 
    END as FlightType,
    COUNT(*) as NumberOfFlights,
    ROUND(AVG(BaseFareUSD), 2) as AvgTicketPrice,
    ROUND(AVG(DistanceKM), 0) as AvgDistance
FROM AirlineRoutes
GROUP BY FlightType;

-- 7. Rank Routes by Revenue per Minute
SELECT 
    RouteCode,
    DepartureCity,
    ArrivalCity,
    ROUND(AVG(FlightDurationMin), 0) as AvgFlightMinutes,
    ROUND(AVG(BaseFareUSD), 2) as AvgTicketPrice,
    -- Revenue per minute: (Ticket price × passengers) / minutes
    ROUND(AVG((BaseFareUSD * 150) / FlightDurationMin), 2) as RevenuePerMinute
FROM AirlineRoutes
WHERE FlightDurationMin > 0  -- Avoid division by zero
GROUP BY RouteCode, DepartureCity, ArrivalCity
ORDER BY RevenuePerMinute DESC
LIMIT 15;