-- Replace empty strings from PropertyAddress column with null

update portofolio_projects.nashville
set PropertyAddress = null
where PropertyAddress = '';

/* this is a query for my own convenience
select t1.ParcelID, t1.PropertyAddress, t2.ParcelID, t2.PropertyAddress
from portofolio_projects.nashville t1
inner join portofolio_projects.nashville t2
on t1.ParcelID = t2.ParcelID and t1.UniqueID <> t2.UniqueID
where t1.PropertyAddress is null;
*/

-- Populate these null values

update portofolio_projects.nashville t1, portofolio_projects.nashville t2
set t1.PropertyAddress = t2.PropertyAddress
where t1.ParcelID = t2.ParcelID
and t1.UniqueID <> t2.UniqueID
and t1.PropertyAddress is null
and t2.PropertyAddress is not null;


-- Split PropertyAddress to two new columns (address and city)

alter table portofolio_projects.nashville
add Property_address varchar(250) after PropertyAddress,
add Property_city varchar(250) after Property_address;

update portofolio_projects.nashville
set
	Property_address = substring_index(PropertyAddress, ',', 1), 
	Property_city = substring_index(PropertyAddress, ',', -1);

-- Split OwnerAddress to three new columns (address, city, state)

alter table portofolio_projects.nashville
add Owner_address varchar(250) after OwnerAddress,
add Owner_city varchar(250) after Owner_address,
add Owner_state varchar(250) after Owner_city;

update portofolio_projects.nashville
set
	Owner_address = substring_index(OwnerAddress, ',', 1),
    Owner_city = substring_index(substring_index(OwnerAddress, ',', 2), ',', -1),
	Owner_state = substring_index(OwnerAddress, ',', -1);

alter table portofolio_projects.nashville
drop column PropertyAddress,
drop column OwnerAddress;

-- Change Y to Yes and N to No in SoldAsVacant column

update portofolio_projects.nashville
set
	SoldAsVacant = if(SoldAsVacant = 'Y', 'Yes', SoldAsVacant),
	SoldAsVacant = if(SoldAsVacant = 'N', 'No', SoldAsVacant);