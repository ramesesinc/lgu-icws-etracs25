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
update 
	waterworks_account aa, ( 
		select t1.objid, min(bb.readingdate) as readingdate 
		from ( select objid from ztmp_account_startdate limit 5000,1000 )t1  
			inner join waterworks_billing b on b.acctid = t1.objid 
			inner join waterworks_batch_billing bb on bb.objid = b.batchid 
		group by t1.objid 
	)bb 
set aa.dtstarted = bb.readingdate 
where aa.objid = bb.objid 
;

-- 4. update the actual records   
update waterworks_account aa, ztmp_account_startdate bb 
set aa.dtstarted = bb.startdate 
where aa.objid = bb.objid 
;

-- 5. drop temporary table 
drop table ztmp_account_startdate
;
