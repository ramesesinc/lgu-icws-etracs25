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
