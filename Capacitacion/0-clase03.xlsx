use siat002
Declare @psiCodMun Smallint, @pcNumDoc Char(13)
Select @psiCodMun = 1, @pcNumDoc = '011201857966'
-- Select * from RDMovDeu 
Set NoCount On

-- Parte 1 - Código optimizado
----------------------------------------------------------------------------------------
Select        Sum(Case b.cTipMov When 'C' Then b.nCuota  Else 0 End)    as nCuota, 
       Isnull(Sum(Case b.cTipMov When 'A' Then b.nCuota  Else 0 End),0) as nCuotaC,
              Sum(Case b.cTipMov When 'C' Then b.nDerEmi Else 0 End)    as nDerEmi, 
       Isnull(Sum(Case b.cTipMov When 'A' Then b.nDeremi Else 0 End),0) as nDerEmiC,
              Sum(Case b.cTipMov When 'C' Then b.nReajus Else 0 End)    as nReajus, 
       Isnull(Sum(Case b.cTipMov When 'A' Then b.nReajus Else 0 End),0) as nReajusC,
              Sum(Case b.cTipMov When 'C' Then b.nIntere Else 0 End)    as nIntere, 
       Isnull(Sum(Case b.cTipMov When 'A' Then b.nIntere Else 0 End),0) as nIntereC,
              Sum(Case b.cTipMov When 'C' Then b.nMora   Else 0 End)    as nMora, 
       Isnull(Sum(Case b.cTipMov When 'A' Then b.nMora   Else 0 End),0) as nMoraC,
              Sum(Case b.cTipMov When 'C' Then b.nMorAcu Else 0 End)    as nMorAcu, 
       Isnull(Sum(Case b.cTipMov When 'A' Then b.nMorAcu Else 0 End),0) as nMorAcuC,
              Sum(Case b.cTipMov When 'C' Then b.nCostas Else 0 End)    as nCostas, 
       Isnull(Sum(Case b.cTipMov When 'A' Then b.nCostas Else 0 End),0) as nCostasC,
              Sum(Case b.cTipMov When 'C' Then b.nGastos Else 0 End)    as nGastos, 
       Isnull(Sum(Case b.cTipMov When 'A' Then b.nGastos Else 0 End),0) as nGastosC
From RDMaeDeu a
Inner Join RDMovDeu b On (a.siCodMun = b.siCodMun And a.cNumDoc = b.cNumDoc)
Where a.siCodMun = @psiCodMun And a.cNumdoc = @pcNumDoc
Group by a.siCodMun, a.cNumdoc
--
-- Parte 2 - Código existente en los SP
--
----------------------------------------------------------------------------------------
Select nCuota   = (Select Sum(nCuota)  from RdMovDeu a (NoLock) Where a.sicodMun = @psiCodMun and a.cNumdoc = @pcNumDoc and a.cTipMov = 'C' Group by a.cTipMov),
		 nCuotaC  = (Case When Not Exists (Select Sum(nCuota)  from  RdMovDeu a (NoLock) Where a.sicodMun = @psiCodMun and a.cNumdoc = @pcNumDoc and a.cTipMov = 'A' Group by a.cTipMov ) Then 0 Else (Select Sum(nCuota)  from RdMovDeu a (NoLock) Where a.sicodMun = @psiCodMun and a.cNumdoc = @pcNumDoc and a.cTipMov = 'A' Group by a.cTipMov) End),
		 nDerEmi  = (Select Sum(nDerEmi) from RdMovDeu a (NoLock) Where a.sicodMun = @psiCodMun and a.cNumdoc = @pcNumDoc and a.cTipMov = 'C'  Group by a.cTipMov ),
		 nDerEmiC = (Case When Not Exists (Select Sum(nDeremi) from  RdMovDeu a (NoLock) Where a.sicodMun = @psiCodMun and a.cNumdoc = @pcNumDoc and a.cTipMov = 'A' Group by a.cTipMov ) Then 0 Else (Select Sum(nDeremi) from RdMovDeu a (NoLock) Where a.sicodMun = @psiCodMun and a.cNumdoc = @pcNumDoc and a.cTipMov = 'A' Group by a.cTipMov) End),
		 nReajus  = (Select Sum(nReajus) from RdMovDeu a (NoLock) Where a.sicodMun = @psiCodMun and a.cNumdoc = @pcNumDoc and a.cTipMov = 'C'  Group by a.cTipMov ),
		 nReajusC = (Case When Not Exists (Select Sum(nReajus) from  RdMovDeu a (NoLock) Where a.sicodMun = @psiCodMun and a.cNumdoc = @pcNumDoc and a.cTipMov = 'A' Group by a.cTipMov ) Then 0 Else (Select Sum(nReajus) from RdMovDeu a (NoLock) Where a.sicodMun = @psiCodMun and a.cNumdoc = @pcNumDoc and a.cTipMov = 'A' Group by a.cTipMov) End),
		 nIntere  = (Select Sum(nIntere) from RdMovDeu a (NoLock) Where a.sicodMun = @psiCodMun and a.cNumdoc = @pcNumDoc and a.cTipMov = 'C'  Group by a.cTipMov ),
		 nIntereC = (Case When Not Exists (Select Sum(nIntere) from  RdMovDeu a (NoLock) Where a.sicodMun = @psiCodMun and a.cNumdoc = @pcNumDoc and a.cTipMov = 'A' Group by a.cTipMov ) Then 0 Else (Select Sum(nIntere) from RdMovDeu a (NoLock) Where a.sicodMun = @psiCodMun and a.cNumdoc = @pcNumDoc and a.cTipMov = 'A' Group by a.cTipMov) End),
		 nMora 	  = (Select Sum(nMora)   from RdMovDeu a (NoLock) Where a.sicodMun = @psiCodMun and a.cNumdoc = @pcNumDoc and a.cTipMov = 'C'  Group by a.cTipMov ),
		 nMoraC   = (Case When Not Exists (Select Sum(nMora) from    RdMovDeu a (NoLock) Where a.sicodMun = @psiCodMun and a.cNumdoc = @pcNumDoc and a.cTipMov = 'A' Group by a.cTipMov ) Then 0 Else (Select Sum(nMora)   from RdMovDeu a (NoLock) Where a.sicodMun = @psiCodMun and a.cNumdoc = @pcNumDoc and a.cTipMov = 'A' Group by a.cTipMov) End),
		 nMorAcu  = (Select Sum(nMorAcu) from RdMovDeu a (NoLock) Where a.sicodMun = @psiCodMun and a.cNumdoc = @pcNumDoc and a.cTipMov = 'C'  Group by a.cTipMov ),
		 nMorAcuC = (Case When Not Exists (Select Sum(nMorAcu) from  RdMovDeu a (NoLock) Where a.sicodMun = @psiCodMun and a.cNumdoc = @pcNumDoc and a.cTipMov = 'A' Group by a.cTipMov ) Then 0 Else (Select Sum(nMorAcu) from RdMovDeu a (NoLock) Where a.sicodMun = @psiCodMun and a.cNumdoc = @pcNumDoc and a.cTipMov = 'A' Group by a.cTipMov) End),
		 nCostas  = (Select Sum(nCostas) from RdMovDeu a (NoLock) Where a.sicodMun = @psiCodMun and a.cNumdoc = @pcNumDoc and a.cTipMov = 'C'  Group by a.cTipMov ),
		 nCostasC = (Case When Not Exists (Select Sum(nCostas) from  RdMovDeu a (NoLock) Where a.sicodMun = @psiCodMun and a.cNumdoc = @pcNumDoc and a.cTipMov = 'A' Group by a.cTipMov ) Then 0 Else (Select Sum(nCostas) from RdMovDeu a (NoLock) Where a.sicodMun = @psiCodMun and a.cNumdoc = @pcNumDoc and a.cTipMov = 'A' Group by a.cTipMov) End),
		 nGastos  = (Select Sum(nGastos) from RdMovDeu a (NoLock) Where a.sicodMun = @psiCodMun and a.cNumdoc = @pcNumDoc and a.cTipMov = 'C'  Group by a.cTipMov ),
		 nGastosC = (Case When Not Exists (Select Sum(nGastos) from  RdMovDeu a (NoLock) Where a.sicodMun = @psiCodMun and a.cNumdoc = @pcNumDoc and a.cTipMov = 'A' Group by a.cTipMov ) Then 0 Else (Select Sum(nGastos) from RdMovDeu a (NoLock) Where a.sicodMun = @psiCodMun and a.cNumdoc = @pcNumDoc and a.cTipMov = 'A' Group by a.cTipMov) End)
-----------------------------------------------------------------------------------------------------------------------
