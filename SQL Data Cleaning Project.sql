/*

Cleaning Data in SQL 

*/

Select * from NashvilleData

--------------------------------------------------------------------------------------------------------------------------
-- Standardize Date Format

select SaleDate from NashvilleData;
Alter Table NashvilleData alter column SaleDate date;

--------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data


select PropertyAddress,ParcelID from NashvilleData

select ND1.PropertyAddress,ND1.ParcelID,ND2.PropertyAddress,ND2.ParcelID, isnull(ND1.PropertyAddress,ND2.PropertyAddress)
from NashvilleData ND1
JOIN NashvilleData ND2
on ND1.ParcelID=ND2.ParcelID where ND1.[UniqueID ]<>ND2.[UniqueID ] AND ND1.PropertyAddress is null
order by ND2.ParcelID;

Update ND1
Set PropertyAddress=isnull(ND1.PropertyAddress,ND2.PropertyAddress)
from NashvilleData ND1
JOIN NashvilleData ND2
on ND1.ParcelID=ND2.ParcelID where ND1.[UniqueID ]<>ND2.[UniqueID ] AND ND1.PropertyAddress is null;

/* ISNULL(expression, value) expression	is Required. 
Expression -to test whether is NULL
Value- to return if expression is NULL */


--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

select SUBSTRING(PropertyAddress,1, charindex(',',PropertyAddress)-1) as Address, 
SUBSTRING(PropertyAddress,charindex(',',PropertyAddress)+1,len(PropertyAddress)) as city
from NashvilleData ;

Alter Table NashvilleData add Address varchar(50), City varchar(50)

select PropertyAddress,Address,City from NashvilleData

update NashvilleData set Address=SUBSTRING(PropertyAddress,1, charindex(',',PropertyAddress)-1), City=SUBSTRING(PropertyAddress,charindex(',',PropertyAddress)+1,len(PropertyAddress));


Select OwnerAddress From NashvilleData


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From NashvilleData

ALTER TABLE NashvilleData
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleData
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleData
Add OwnerSplitCity Nvarchar(255);

Update NashvilleData
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)


ALTER TABLE NashvilleData
Add OwnerSplitState Nvarchar(255);

Update NashvilleData
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

Select * from NashvilleData
--------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

select distinct SoldAsVacant from NashvilleData;

update NashvilleData set SoldAsVacant='Yes' where SoldAsVacant='Y'
update NashvilleData set SoldAsVacant='No' where SoldAsVacant='N'

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates  Alex Query

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From NashvilleData
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


select distinct ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference from NashvilleData

---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

select * from NashvilleData

alter table NashvilleData
drop column OwnerAddress, TaxDistrict, PropertyAddress


-----------------------------------------------------------------------------------------------
