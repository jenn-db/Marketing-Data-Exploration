-- Checking the number of campaigns 
SELECT DISTINCT Campaignname
FROM BASMA;

-- The daily marketing spent and results by channel and by campaign
SELECT Campaignname, Day, Platform, location,
	 SUM(reach), SUM(impressions), SUM(linkclicks), SUM(UniquePurchases), SUM(uniqueregistrations),
	 SUM(CAST([Amountspent(usd)] AS FLOAT)) AS TotalAmountSpent,
	 ROUND(SUM(CAST(Linkclicks AS FLOAT))/SUM(CAST(Impressions AS FLOAT))*100, 2) AS CTR,
	 ROUND(SUM(CAST(UniquePurchases  AS FLOAT))/SUM(CAST(Linkclicks AS FLOAT))*100,2) AS CR
FROM BASMA
GROUP BY Campaignname, Day, Platform,location;

-- cost and conversion metrics for each campaign
SELECT Campaignname,
	   ROUND(SUM(CAST([Amountspent(usd)]  AS FLOAT))/SUM(CAST(Linkclicks AS FLOAT)), 2) AS CPC,
	   ROUND(SUM(CAST([Amountspent(usd)] AS FLOAT)) / SUM(CAST(UniquePurchases AS FLOAT)), 2) AS CPP,
	   ROUND(SUM(CAST([Amountspent(usd)] AS FLOAT))/SUM(CAST(Impressions AS FLOAT)) ,4) AS CPI,
	   ROUND(SUM(CAST([AmountSpent(usd)] AS FLOAT))/SUM(CAST(UniqueRegistrations AS FLOAT)),2) AS CPR,
	   ROUND(SUM(CAST(Linkclicks AS FLOAT))/SUM(CAST(Impressions AS FLOAT))*100, 2) AS CTR,
	   ROUND(SUM(CAST(UniquePurchases  AS FLOAT))/SUM(CAST(Linkclicks AS FLOAT))*100,2) AS Purchase_Conversion_Rate,
	   SUM(UniquePurchases), SUM(UniqueRegistrations), SUM(linkclicks), SUM(reach), sum(impressions), SUM([AmountSpent(usd)])
FROM BASMA
GROUP BY Campaignname

-- adding a new column with the location
ALTER TABLE BASMA ADD COLUMN Location VARCHAR(3);

-- updating the new column with the first three letters of the Campaignname column
UPDATE BASMA SET Location = SUBSTR(Campaignname, 1, 3);

-- CTR, and Link to Puchase, Link to registration per Platform
SELECT Platform,
	ROUND(SUM(CAST(Linkclicks AS FLOAT))/SUM(CAST(Impressions AS FLOAT))*100, 2) AS CTR,
	SUM([AmountSpent(usd)]),
	ROUND(SUM(CAST(UniqueRegistrations AS FLOAT))/SUM(CAST(Linkclicks AS FLOAT))*100, 2) AS Link_to_Registration,
	 ROUND(SUM(CAST(UniquePurchases  AS FLOAT))/SUM(CAST(Linkclicks AS FLOAT))*100,2) AS Purchase_Conversion_Rate
FROM BASMA
GROUP BY Platform;

————
-- comparing metrics per location (CPC, CR, CTR, CPP, nb of purchases)
SELECT location,
		SUM(impressions), SUM(reach), SUM(linkclicks), SUM([Amountspent(usd)]),
       ROUND(SUM(CAST(UniquePurchases  AS FLOAT))/SUM(CAST(Linkclicks AS FLOAT))*100,2) AS CR,
	    ROUND(SUM(CAST(Linkclicks AS FLOAT))/SUM(CAST(Impressions AS FLOAT))*100, 2) AS CTR,
       ROUND(SUM(CAST([Amountspent(usd)]  AS FLOAT))/SUM(CAST(Linkclicks AS FLOAT)), 2) AS CPC,
	   SUM(UniqueRegistrations) AS Total_Registrations,
	   ROUND(SUM(CAST([Amountspent(usd)] AS FLOAT)) / SUM(CAST(UniquePurchases AS FLOAT)), 2) AS CPP,
	   SUM(UniquePurchases) AS Total_Purchases
FROM BASMA
GROUP BY location;

-- comparing platform per location (which platform got us the best results for each location)
SELECT location, platform, 
	ROUND(SUM(CAST(UniquePurchases  AS FLOAT))/SUM(CAST(Linkclicks AS FLOAT))*100,2) AS CR,
	ROUND(SUM(CAST(Linkclicks AS FLOAT))/SUM(CAST(Impressions AS FLOAT))*100, 2) AS CTR
	FROM BASMA
GROUP BY location, platform;

-- select the platform with the highest reach for each Campaign  
SELECT b.Campaignname, b.Platform, b.reach 
FROM BASMA b
JOIN (
  SELECT Campaignname, MAX(reach) AS max_reach
  FROM BASMA
  GROUP BY Campaignname
) m
ON b.Campaignname = m.Campaignname AND b.reach = m.max_reach;

-- select the platform with the highest Impressions for each Campaign  
SELECT b.Campaignname, b.Platform, b.Impressions 
FROM BASMA b
JOIN (
  SELECT Campaignname, MAX(Impressions) AS max_impressions
  FROM BASMA
  GROUP BY Campaignname
) m
ON b.Campaignname = m.Campaignname AND b.Impressions = m.max_impressions;

-- select the platform with the highest link clicks for each Campaign  
SELECT b.Campaignname, b.Platform, b.Linkclicks 
FROM BASMA b
JOIN (
  SELECT Campaignname, MAX(Linkclicks) AS max_clicks
  FROM BASMA
  GROUP BY Campaignname
) m
ON b.Campaignname = m.Campaignname AND b.Linkclicks = m.max_clicks;
