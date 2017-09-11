declare @psiCodMun smallint, @psiCodigo_Ser smallint, @pbiNumeroDoc_RegNot bit, @pcNumeroGenDoc_RegNot char(18)

select @psiCodMun = 1, @psiCodigo_Ser = 0, @pbiNumeroDoc_RegNot = 0, @pcNumeroGenDoc_RegNot = '909100852800'


         Select Tra.biNumero_Tra,
                 Tra.siTipDid,
                 Tra.cNumDocIdeAdministrado_Tra,
                 (Tra.vApePatAdministrado_Tra + ' ' + Tra.vApeMatAdministrado_Tra + ' ' + Tra.vNomAdministrado_Tra),
                 IsNull(Dom.siCodDep, 1),
                 IsNull(Dom.siCodPro, 1),
                 IsNull(Dom.siCodDis, 1),
                 8,
                 IsNull(Dom.siCodDom, ''),
                 IsNull(Tra.vDomAdministrado_Tra, ''),
                 1, 
				 Count(DeuPytRes.cNumDoc),
                 Sum(DeuPytRes.nSaldo_DeuPytRes),
                 Tra.iCodPer,
                 Tra.iCodigo_NuePer,
                 Tra.vApePatAdministrado_Tra,
                 Tra.vApeMatAdministrado_Tra,
                 Tra.vNomAdministrado_Tra,
                 Tra.vNomAdministrado_Tra,
                 1,
                 DocRes.iNumero_PytRes,
                 TipTra.siCodigoAtencion_Uor
         From dbo.GDMaeDocRespuesta DocRes (NoLock)
         Inner Join dbo.GDMaeTramite Tra (NoLock) On Tra.siCodMun = DocRes.siCodMun And Tra.biNumero_Tra = DocRes.biNumero_Tra
         Inner Join dbo.GDTabTipoTramite TipTra (NoLock) On TipTra.siCodMun = Tra.siCodMun And TipTra.siCodigo_TipTra = Tra.siCodigo_TipTra
         Left Join SIAT001.dbo.RDDomPer Dom (NoLock) On Dom.iCodPer = Tra.iCodPer And Dom.siCodDom = Tra.siCodDom
         Left Join dbo.GDMovDeudaProyRespuesta DeuPytRes (NoLock) On DeuPytRes.siCodMun = DocRes.siCodMun And DeuPytRes.iNumero_PytRes = DocRes.iNumero_PytRes And
                   DeuPytRes.cNumdoc = DeuPytRes.cNumdoc
         Where DocRes.siCodMun = @psiCodMun --And --DocRes.siCodigo_Ser = @psiCodigo_Ser And DocRes.biNumeroDoc_DocRes = @pbiNumeroDoc_RegNot And
             --  DocRes.cNumeroGenDoc_DocRes = @pcNumeroGenDoc_RegNot
         Group By Tra.biNumero_Tra,Tra.siTipDid, Tra.cNumDocIdeAdministrado_Tra, Tra.vApePatAdministrado_Tra, Tra.vApeMatAdministrado_Tra, Tra.vNomAdministrado_Tra,
 Dom.siCodDep, Dom.siCodPro, Dom.siCodDis, Dom.siCodDom, Tra.iCodPer, Tra.iCodigo_NuePer, Tra.vApePatAdministrado_Tra,
                  Tra.vApeMatAdministrado_Tra, Tra.vNomAdministrado_Tra, Tra.vNomAdministrado_Tra, DocRes.iNumero_PytRes, TipTra.siCodigoAtencion_Uor,
                  Tra.vDomAdministrado_Tra
