Declare @psdFecEmi smalldatetime, @sdFecIBLe smalldatetime,
        @bSelPub bit, @siSitDoc smallint, 
        @siCodEst_1 smallint, @siCodEst_2 smallint, 
        @psiCodMun smallint
--
drop table #tmp_1
select @bSelPub = 0, @siSitDoc = 3, @siCodEst_1 = 1, @siCodEst_2 = 2 , @psiCodMun = 1, @sdFecIBLe = '01/03/2017', @psdFecEmi = getdate()
-- Select top 100000 a.siCodMun, a.iLotNot,a.iNumGru, a.iCodPer,a.cNumCar, a.siEstDRe,siEstNot,sdFecNot
Select a.siCodMun, a.iLotNot,a.iNumGru, a.iCodPer,a.cNumCar, a.siEstDRe,siEstNot,sdFecNot,   a.siSitDoc, a.siCodEst, a.bSelPub
into #tmp_1
From NoMaeCar a (NoLock)
Inner Join RDMaePer b (NoLock) On a.iCodPer= b.iCodPer 
Where a.siCodMun  = @psiCodMun    
	and a.sdFecNot  >= @sdFecIBLe and a.sdFecNot  <= @psdFecEmi 
	and a.siSitDoc  =  @siSitDoc  
	and (a.siCodEst =  @siCodEst_1 or a.siCodEst = @siCodEst_2) 
	and a.bSelPub   = @bSelPub 
	and (b.siTipCPe =  1 or b.siTipCPe = 2)
--
drop table #tmp_2
Select a.siCodMun, a.iLotNot,a.iNumGru, a.iCodPer,a.cNumCar, a.siEstDRe,siEstNot,sdFecNot
into #tmp_2
From NoMaeCar a (NoLock)
Inner Join RDMaePer b (NoLock) On a.iCodPer = b.iCodPer 
Where a.siCodMun  = @psiCodMun    
	and a.sdFecNot  >= @sdFecIBLe and a.sdFecNot  <= @psdFecEmi 
	and a.siSitDoc  =  3  
	and (a.siCodEst =  1 or a.siCodEst = 2) 
	and a.bSelPub   <> 1 
	and (b.siTipCPe =  1 or b.siTipCPe = 2)