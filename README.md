# Airline Route Profitability Dashboard

## 📌 Project Overview
This project focuses on analyzing airline route performance using Power BI.  
The objective is to identify profitable and loss-making routes by comparing revenue, cost, and profit metrics, and to derive actionable business insights through interactive visualizations.

---

## 📂 Dataset Description
The dataset contains airline route–level information with the following key attributes:
- RouteCode
- AircraftType
- Airline
- Alliance
- Departure & Arrival Airports, Cities, and Countries
- BaseFareUSD
- DistanceKM
- FlightDurationMin
- Stops
- WeeklyFrequency

Since direct cost, revenue, and occupancy values were not available, these metrics were derived using industry-based assumptions.

---

## 🧮 Key Calculations
- **Revenue**: Estimated using base fare and weekly frequency  
- **Cost**: Derived from distance and flight duration  
- **Profit**: Revenue minus cost  
- **Average Occupancy**: Estimated using number of stops as a proxy

These calculated measures enable meaningful profitability analysis.

---

## 📊 Dashboard Components
The Power BI dashboard includes:
- KPI Cards for Total Revenue, Total Cost, and Total Profit
- Bar Chart showing Top 10 Most Profitable Routes
- Origin–Destination Route Map
- Stacked Column Chart comparing Cost vs Revenue per Route
- Line Chart showing Profit Trend by Weekly Frequency
- Donut Chart displaying Average Occupancy by Aircraft Type
- Interactive slicers for Aircraft Type, Airline, and Route Code

---

## 💡 Key Insights
- Some routes generate high revenue but have low profit due to high operational costs.
- Long-haul routes earn more revenue but are not always more profitable than short-haul routes.
- Profitability peaks at moderate flight frequencies, indicating optimal demand levels.
- Certain aircraft types perform better on specific routes, highlighting the need for optimized aircraft allocation.

---

## 🛠 Tools Used
- Power BI Desktop
- DAX for calculated columns and measures

---

## 📁 Files Included
- `RouteProfitDashboard.pbix` – Power BI dashboard file  
- `SkyRoutesAnalysis.sql` – SQL queries (Part 1)  
- `RouteInsights.txt` – Summary of analytical insights  
- `README.md` – Project documentation  

---

## ✅ Conclusion
This dashboard provides a comprehensive view of airline route profitability and supports data-driven decision-making for route planning, cost optimization, and aircraft deployment.

