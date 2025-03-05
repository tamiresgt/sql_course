/* 1. Utilize o INNER JOIN para trazer os nomes das subcategorias dos produtos, da tabela 
DimProductSubcategory para a tabela DimProduct. */

select 
	DimProduct.*,
	DimProductSubcategory.ProductSubcategoryName
from DimProduct
inner join DimProductSubcategory on DimProduct.ProductSubcategoryKey = DimProductSubcategory.ProductSubcategoryKey



/* 2. Identifique uma coluna em comum entre as tabelas DimProductSubcategory e 
DimProductCategory. Utilize essa coluna para complementar informações na tabela 
DimProductSubcategory a partir da DimProductCategory. Utilize o LEFT JOIN. */

select 
	DimProductSubcategory.*,
	DimProductCategory.ProductCategoryName,
	DimProductCategory.ProductCategoryDescription,
	DimProductCategory.ProductCategoryLabel
from DimProductSubcategory
left join DimProductCategory on DimProductSubcategory.ProductCategoryKey = DimProductCategory.ProductCategoryKey

select * from DimProductCategory


/* 3. Para cada loja da tabela DimStore, descubra qual o Continente e o Nome do País associados 
(de acordo com DimGeography). Seu SELECT final deve conter apenas as seguintes colunas: 
StoreKey, StoreName, EmployeeCount, ContinentName e RegionCountryName. Utilize o LEFT 
JOIN neste exercício. */

select * from DimStore
select * from DimGeography

select 
	DimStore.StoreKey,
	DimStore.StoreName,
	DimStore.EmployeeCount,
	DimGeography.ContinentName,
	DimGeography.RegionCountryName
from DimStore
left join DimGeography on DimStore.GeographyKey = DimGeography.GeographyKey

/* 4. Complementa a tabela DimProduct com a informação de ProductCategoryDescription. Utilize 
o LEFT JOIN e retorne em seu SELECT apenas as 5 colunas que considerar mais relevantes. */

select 
	DimProduct.ProductName,
	DimProduct.BrandName,
	DimProduct.UnitCost,
	DimProduct.UnitPrice,
	DimProductCategory.ProductCategoryDescription
from DimProduct
left join DimProductSubcategory 
	on DimProduct.ProductSubcategoryKey = DimProductSubcategory.ProductSubcategoryKey
		left join DimProductCategory 
			on DimProductSubcategory.ProductCategoryKey = DimProductCategory.ProductCategoryKey

select * from DimProductSubcategory

/* 5. A tabela FactStrategyPlan resume o planejamento estratégico da empresa. Cada linha 
representa um montante destinado a uma determinada AccountKey.  
a) Faça um SELECT das 100 primeiras linhas de FactStrategyPlan para reconhecer a tabela. */

select top 100 * from FactStrategyPlan

/* b) Faça um INNER JOIN para criar uma tabela contendo o AccountName para cada 
AccountKey da tabela FactStrategyPlan. O seu SELECT final deve conter as colunas: 
• StrategyPlanKey 
• DateKey 
• AccountName 
• Amount */

select
	FactStrategyPlan.StrategyPlanKey,
	FactStrategyPlan.Datekey,
	FactStrategyPlan.Amount,
	DimAccount.AccountName
from FactStrategyPlan
inner join DimAccount 
	on FactStrategyPlan.AccountKey = DimAccount.AccountKey


/* 6. Vamos continuar analisando a tabela FactStrategyPlan. Além da coluna AccountKey que 
identifica o tipo de conta, há também uma outra coluna chamada ScenarioKey. Essa coluna 
possui a numeração que identifica o tipo de cenário: Real, Orçado e Previsão. 
Faça um INNER JOIN para criar uma tabela contendo o ScenarioName para cada ScenarioKey 
da tabela FactStrategyPlan. O seu SELECT final deve conter as colunas: 
• StrategyPlanKey 
• DateKey 
• ScenarioName  
• Amount */

select 
	FactStrategyPlan.StrategyPlanKey,
	FactStrategyPlan.Datekey,
	FactStrategyPlan.Amount,
	DimScenario.ScenarioName
from FactStrategyPlan
inner join DimScenario on FactStrategyPlan.ScenarioKey=DimScenario.ScenarioKey



/* 7. Algumas subcategorias não possuem nenhum exemplar de produto. Identifique que 
subcategorias são essas. */

select * from DimProduct
select * from DimProductSubcategory

select 
	DimProductSubcategory.*,
	DimProduct.ProductName
from DimProductSubcategory
left join DimProduct on DimProductSubcategory.ProductSubcategoryKey = DimProduct.ProductSubcategoryKey
where ProductName is null


/* 8. 
A tabela abaixo mostra a combinação entre Marca e Canal de Venda, para as marcas Contoso, 
Fabrikam e Litware. Crie um código SQL para chegar no mesmo resultado. */ 

select
	DISTINCT(DimProduct.BrandName) as 'BrandName',
	DimChannel.ChannelName
from DimProduct
cross join DimChannel 
where BrandName IN ('Contoso', 'Fabrikam', 'Litware')



/* 9. Neste exercício, você deverá relacionar as tabelas FactOnlineSales com DimPromotion. 
Identifique a coluna que as duas tabelas têm em comum e utilize-a para criar esse 
relacionamento. 
Retorne uma tabela contendo as seguintes colunas: 
• OnlineSalesKey 
• DateKey 
• PromotionName 
• SalesAmount 
A sua consulta deve considerar apenas as linhas de vendas referentes a produtos com 
desconto (PromotionName <> ‘No Discount’). Além disso, você deverá ordenar essa tabela de 
acordo com a coluna DateKey, em ordem crescente. */

select top 10 * from FactOnlineSales
select * from DimPromotion

select top(1000)
	FactOnlineSales.OnlineSalesKey,
	FactOnlineSales.DateKey,
	DimPromotion.PromotionName,
	FactOnlineSales.SalesAmount
from FactOnlineSales
left join DimPromotion on FactOnlineSales.PromotionKey = DimPromotion.PromotionKey
where PromotionName <> 'No Discount'
order by DateKey asc

-- 8727716 lines

/* 10. A tabela abaixo é resultado de um Join entre a tabela FactSales e as tabelas: DimChannel, 
DimStore e DimProduct. 
Recrie esta consulta e classifique em ordem decrescente de acordo com SalesAmount. */

select top 10 * from FactSales
select * from DimChannel
select * from DimStore
select * from DimProduct

select top 10
	FactSales.SalesKey,
	DimChannel.ChannelName,
	DimStore.StoreName,
	DimProduct.ProductName,
	FactSales.SalesAmount
from FactSales
left join DimChannel 
	on FactSales.channelKey = DimChannel.ChannelKey
left join DimStore 
	on FactSales.StoreKey = DimStore.StoreKey
left join DimProduct 
	on FactSales.ProductKey = DimProduct.ProductKey
order by SalesAmount desc