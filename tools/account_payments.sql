
set @acctid = 'WA-83cca693b6810fea628c4fa776542777' 
;

select * 
from ( 
	select wpi.parentid as paymentid 
	from waterworks_payment_item wpi 
		inner join waterworks_payment wp on (wp.objid = wpi.parentid and wp.reftype <> 'creditpayment') 
		inner join waterworks_consumption wc on wc.objid = wpi.refid 
	where wc.acctid = @acctid 
	group by wpi.parentid 
)t1 
	inner join waterworks_payment wp on wp.objid = t1.paymentid  
order by wp.refdate 
;

select * from waterworks_credit 
where acctid = @acctid 
order by refdate 
;
