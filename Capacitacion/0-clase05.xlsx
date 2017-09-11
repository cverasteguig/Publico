declare @sicodmun smallint
declare @sitipedo smallint
declare @dt_fec1 datetime

select @sicodmun = 1, @sitipedo = 3

/*

select * 
from rdmaedeu a with (nolock)
where sicodmun = @sicodmun
  and cnumdoc = '132132132'
*/
select @dt_fec1 = getdate()
----------------------------
select count(1)
from rdmaedeu a with (nolock) --, readuncommitted)
where sicodmun = @sicodmun --and a.inumafe = a.inumafe
  and sitipedo = @sitipedo
----------------------------------
select getdate() - @dt_fec1 as dt_tiempo
