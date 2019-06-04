[getReport]
select 
	barangay_objid, barangay_name, 
	sum(res_active) as res_active, sum(com_active) as com_active, 
	sum(ind_active) as ind_active, sum(bulk_active) as bulk_active,
	sum(res_inactive) as res_inactive, sum(com_inactive) as com_inactive, 
	sum(ind_inactive) as ind_inactive, sum(bulk_inactive) as bulk_inactive 
from ( 
	select 
		so.barangay_objid, so.barangay_name, 
		case 
			when wa.classificationid='RESIDENTIAL' and wm.state <> 'DISCONNECTED' then 1 
			when wa.classificationid='RESIDENTIAL' and wa.state = 'ACTIVE' then 1 
			else 0 
		end as res_active, 
		case 
			when wa.classificationid='COMMERCIAL' and wm.state <> 'DISCONNECTED' then 1 
			when wa.classificationid='COMMERCIAL' and wa.state = 'ACTIVE' then 1 
			else 0 
		end as com_active, 
		case 
			when wa.classificationid='INDUSTRIAL' and wm.state <> 'DISCONNECTED' then 1 
			when wa.classificationid='INDUSTRIAL' and wa.state = 'ACTIVE' then 1 
			else 0 
		end as ind_active, 
		case 
			when wa.classificationid='BULK' and wm.state <> 'DISCONNECTED' then 1 
			when wa.classificationid='BULK' and wa.state = 'ACTIVE' then 1 
			else 0 
		end as bulk_active, 
		case 
			when wa.classificationid='RESIDENTIAL' and wm.state = 'DISCONNECTED' then 1 
			when wa.classificationid='RESIDENTIAL' and wa.state = 'INACTIVE' then 1 
			else 0 
		end as res_inactive,  
		case 
			when wa.classificationid='COMMERCIAL' and wm.state = 'DISCONNECTED' then 1 
			when wa.classificationid='COMMERCIAL' and wa.state = 'INACTIVE' then 1 
			else 0 
		end as com_inactive,  
		case 
			when wa.classificationid='INDUSTRIAL' and wm.state = 'DISCONNECTED' then 1 
			when wa.classificationid='INDUSTRIAL' and wa.state = 'INACTIVE' then 1 
			else 0 
		end as ind_inactive,  
		case 
			when wa.classificationid='BULK' and wm.state = 'DISCONNECTED' then 1 
			when wa.classificationid='BULK' and wa.state = 'INACTIVE' then 1 
			else 0 
		end as bulk_inactive  
	from waterworks_account wa  
		inner join waterworks_meter wm on wm.objid = wa.meterid 
		inner join waterworks_stubout_node sn on sn.objid = wa.stuboutnodeid  
		inner join waterworks_stubout so on so.objid = sn.stuboutid 

	union all 

	select 
		so.barangay_objid, so.barangay_name, 
		case 
			when wa.classificationid='RESIDENTIAL' and wa.state = 'ACTIVE' then 1 
			else 0 
		end as res_active, 
		case 
			when wa.classificationid='COMMERCIAL' and wa.state = 'ACTIVE' then 1 
			else 0 
		end as com_active, 
		case 
			when wa.classificationid='INDUSTRIAL' and wa.state = 'ACTIVE' then 1 
			else 0 
		end as ind_active, 
		case 
			when wa.classificationid='BULK' and wa.state = 'ACTIVE' then 1 
			else 0 
		end as bulk_active, 
		case 
			when wa.classificationid='RESIDENTIAL' and wa.state = 'INACTIVE' then 1 
			else 0 
		end as res_inactive,  
		case 
			when wa.classificationid='COMMERCIAL' and wa.state = 'INACTIVE' then 1 
			else 0 
		end as com_inactive,  
		case 
			when wa.classificationid='INDUSTRIAL' and wa.state = 'INACTIVE' then 1 
			else 0 
		end as ind_inactive,  
		case 
			when wa.classificationid='BULK' and wa.state = 'INACTIVE' then 1 
			else 0 
		end as bulk_inactive  
	from waterworks_account wa  
		inner join waterworks_stubout_node sn on sn.objid = wa.stuboutnodeid  
		inner join waterworks_stubout so on so.objid = sn.stuboutid 
	where wa.meterid is null 
)t1 
where barangay_objid is not null ${filters} 
group by barangay_objid, barangay_name 
order by barangay_name 
