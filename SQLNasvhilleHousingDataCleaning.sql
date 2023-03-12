/*CLEANING DATA IN SQL
*/

SELECT*
FROM PortfolioProject.dbo.NashvilleHousing

--standardize date format
select saleDateconverted, CONVERT(date, SaleDate)
FROM PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate= CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
add saleDateconverted Date

Update NashvilleHousing
SET saleDateconverted = CONVERT(Date, SaleDate)


--Populate Property Adress data

SELECT PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing
where PropertyAddress is null

select a.ParcelID, a.PropertyAddress,   b.ParcelID, b.PropertyAddress,
ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID= b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
where a.propertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID= b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
where a.propertyAddress is null
---------------------------------------------------------------------------
--Breaking out Address into Individual columns (Address, city, state)
SELECT
SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1) As Address,
SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) As City
FROM PortfolioProject.dbo.NashvilleHousing 

ALTER TABLE NashvilleHousing
add Propertysplitaddress Nvarchar(225)


Update NashvilleHousing
SET Propertysplitaddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1) 


ALTER TABLE NashvilleHousing
add PropertysplitCity Nvarchar(225)

Update NashvilleHousing
SET PropertysplitCity  = SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) 

select*
FROM PortfolioProject.dbo.NashvilleHousing 


------------------propertyowner address-------------
select OwnerAddress
FROM PortfolioProject.dbo.NashvilleHousing 


select OwnerAddress
FROM PortfolioProject.dbo.NashvilleHousing 

Select
PARSENAME(Replace(ownerAddress, ',', '.'),3)
,PARSENAME(Replace(ownerAddress, ',', '.'),2)
,PARSENAME(Replace(ownerAddress, ',', '.'),1)
FROM PortfolioProject.dbo.NashvilleHousing 


ALTER TABLE NashvilleHousing
add OwnersplitAdress Nvarchar(225)

Update NashvilleHousing
SET OwnersplitAdress  = PARSENAME(Replace(ownerAddress, ',', '.'),3)

ALTER TABLE NashvilleHousing
add OwnersplitCity Nvarchar(225)

Update NashvilleHousing
SET OwnersplitCity  = PARSENAME(Replace(ownerAddress, ',', '.'),2)

ALTER TABLE NashvilleHousing
add OwnersplitState Nvarchar(225)

Update NashvilleHousing
SET OwnersplitState  = PARSENAME(Replace(ownerAddress, ',', '.'),1)



---------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to yes and no in "Sold as Vacant " column

SELECT distinct(SoldAsVacant), COUNT(soldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2


Select SoldAsVacant
,Case when SoldAsVacant= 'Y' THEN 'Yes'
	  when SoldAsVacant = 'N' THEN  'No'
	  Else SoldAsVacant
      END
From PortfolioProject.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = Case when SoldAsVacant= 'Y' THEN 'Yes'
	  when SoldAsVacant = 'N' THEN  'No'
	  Else SoldAsVacant
      END
------------------------------------------

-----Remove Duplicates
WITH RowNumCTE AS(
Select*,
ROW_NUMBER() over (
PARTITION by parcelID, 
	PropertyAddress, 
	SalePrice, 
	SaleDate, 
	LegalReference
	ORDER BY
		UniqueID
			) row_num


From PortfolioProject.dbo.NashvilleHousing
)
--order by ParcelID
select*
from RowNumCTE
where row_num > 1
--Order by PropertyAddress


---------------------------------------------------------------------------------------------------------

--Delete unused column




select*

From PortfolioProject.dbo.NashvilleHousing

Alter table PortfolioProject.dbo.NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress