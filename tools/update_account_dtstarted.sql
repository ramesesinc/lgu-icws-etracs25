/*
update 
	waterworks_account aa, ( 
		select a.objid, 
			(
				select min(bb.readingdate) as readingdate  
				from waterworks_billing b 
					inner join waterworks_batch_billing bb on bb.objid = b.batchid 
				where b.acctid = a.objid 
			) as startdate   
		from waterworks_account a 
		where a.dtstarted is null 
	)bb 
set aa.dtstarted = bb.startdate 
where aa.objid = bb.objid 
*/

-- 1. create temporary table 
drop table if exists ztmp_account_startdate 
;
create table ztmp_account_startdate ( 
	objid varchar(50) not null, 
	startdate date null, 
	primary key (objid) 
)
; 

-- 2. insert data  
insert into ztmp_account_startdate ( 
	objid, startdate 
) 
select objid, dtstarted
from waterworks_account 
where dtstarted is null 
;


-- 3. fetch the first reading 
select a.objid, 
	(
		select min(bb.readingdate) as readingdate  
		from waterworks_billing b 
			inner join waterworks_batch_billing bb on bb.objid = b.batchid 
		where b.acctid = a.objid 
	) as startdate   
from ztmp_account_startdate a 
; 

-- 3. update the actual records   
update waterworks_account aa, ztmp_account_startdate bb 
set aa.dtstarted = bb.startdate 
where aa.objid = bb.objid 
;

-- 4. drop temporary table 
drop table ztmp_account_startdate
;
