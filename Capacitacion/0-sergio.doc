drop table #tmpDeuda2

  Create Table #tmpDeuda2         
   (  iCorrel    Int    Identity, cConcepto   Char(50)     , cNumDoc      Char(20)     ,        
      cNumOri    Char(20)       , siReclamo   smallint     , vReferencia  Varchar(150) , cPlaca     Char(20)    ,         
      cPeriodo   Char(10)       , nTotal      Numeric(11,2),        
      siPerAfe   SmallInt       , sdFecEmi    SmallDatetime,        
      sdFecVen   SmallDatetime  , sdFecVenA   SmallDatetime, nCuota       Numeric(11,2), nSaldo     Numeric(11,2),         
      iCodPer    Int            , sicodcre    SmallInt     , nImporte     Numeric(11,2), nInteres   Numeric(11,2),         
      vPersona   VarChar(120)   , nImpori     Numeric(11,2), nDeremi      Numeric(11,2), nReinci    Numeric(11,2),         
      nReajuste  Numeric(11,2)  , nCostas     Numeric(11,2), nGastos      Numeric(11,2), nIntere    Numeric(11,2),        
      nIntereDIf Numeric(11,2)  , nMora       Numeric(11,2), nMorAcu      Numeric(11,2), nCuotaCob  Numeric(11,2),         
      nDerEmiCob Numeric(11,2)  , nReinciCob  Numeric(11,2), nReajusCob   Numeric(11,2), nIntereCob Numeric(11,2),         
      nMoraCob   Numeric(11,2)  , nMorAcuCob  Numeric(11,2), nCostasCob   Numeric(11,2), nGastosCob Numeric(11,2),        
      nCuotaEmi  Numeric(11,2)  , nDerEmiEmi  Numeric(11,2), nReinciEmi   Numeric(11,2), nReajusEmi Numeric(11,2),         
      nIntereEmi Numeric(11,2)  , nMoraEmi    Numeric(11,2), nMorAcuEmi   Numeric(11,2), nCostasEmi Numeric(11,2),         
      nGastosEmi Numeric(11,2)  , siCodGEm    SmallInt     , siCodMun     SmallInt     , nDescue   Numeric(11,2),         
      siTipEdo   SmallInt       , siAnoAfe    SmallInt     , sdFecInt     SmallDatetime,         
      sdFecEnv   SmallDatetime  , cPendiente  Char(10)     , iNumAfe      Int          , siCodPag   SmallInt     ,        
      cMarca     Char(50)       , nMorDIf     Numeric(11,2), nTotConDscto Numeric(11,2), cLP        Char(50)     ,        
      cPJ        Char(50)       , cSE         Char(50)     , cImp         Char(1)    , siTipTram Char(10)  ,
      nMontoCompensado Numeric(11,2)
	  ---
	  , iNumCor int
	  --
	  , siUniAfe smallint, siUniIna smallint
   )        


insert into #tmpDeuda2 
 Select 
[cConcepto] = 'update por tmp', --(Select vDeaCre From sgTabCre (NOLOCK) Where siCodEst=1 And siCodCRe = Md.siCodCRe), 
[cNumDoc] = Md.cNumDoc, 
[cNumOri] = Md.cNumOri,  
[siReclamo] =  dbo.fnSGD_NumDoc_VerificarSiDeudaReclamada(1, Md.cNumDoc),
[vReferencia] = 'updae por tmp',
/*
IsNull(Case 
                          When Md.siCodCre = 145 Then (Select Top 1 Case 
						                                               When Af.siUniAfe + Af.siUniIna > 1 Then 'ni mela' 
																	   Else DP.vDesDom 
																	End 
                                                        From RdDocpre DP (NoLock) 
														Inner Join RdDjpafe DJ (NoLock) On DP.siCodMun = DJ.siCodMun and DP.iNumCor = DJ.iNumCor 
                                                        Where DJ.siCodMun = Md.siCodMun And DJ.iNumAfe = Md.iNumAfe) 
                           When Md.siCodCre = 110 Then (Select a.vDesDom 
						                                 From RDMAEALC a (Nolock) 
														 Where a.siCodMun = MD.siCodMun and a.iNumDJ = Af.iNumCor) 
                           When Md.siCodCre = 145 Then (Select Top 1 Case 
						                                               When Af.siUniAfe + Af.siUniIna > 1 Then ' (+) ' 
																	   Else a.vDesDom 
																	 End  
														From RdDocpre a (NoLock) 
														Inner Join RdDjpafe b (NoLock) On a.siCodMun = b.siCodMun And a.iNumCor = b.iNumCor  
														Where b.siCodMun = Md.siCodMun And b.iNumAfe = Md.iNumAfe) 
                           When Md.siCodCre = 146 Then (Select Top 1 Case 
						                                                When Af.siUniAfe + Af.siUniIna > 1 Then '(+) ' 
																		Else a.cPlaca + ' - ' + a.cNroMot 
																	 End 
                                                         From RdDocveh a (NoLock) 
														 Inner Join RdDjvafe b (NoLock) On a.siCodMun = b.siCodMun And a.iNumCor = b.iNumCor 
                                                         Where b.siCodMun = Md.siCodMun And b.iNumAfe = Md.iNumAfe) 
                           When Md.siCodCre = 200 Then (Select a.vDesDom 
						                                From RdDocpre a (NoLock) 
														Where a.siCodMun = Af.siCodMun And a.iNumCor = Af.iNumCor) 
                           When Md.siCodCre = 390 Then (Select c.vDesDer 
						                                From RdMaeder a (NoLock) 
														Inner Join ReMaeDer c (NoLock) On a.siCodMun=c.siCodMun And a.cCodDer=c.cCodDer 
                                                        Where a.siCodMun = Af.siCodMun And a.iNumDer = Af.iNumCor) 
                           When Md.siCodCre = 400 Then (Select Convert(Varchar(20),a.siCodMTr) 
                                                        From RdMaeMuT a (NoLock) 
														Where a.siCodMun = Af.siCodMun And a.iNumMul = Af.iNumCor) 
                           When Md.siCodCre In (820,823) Then (Select a.cNumRes 
						                                       From FrMaeres a (NoLock) 
															   Inner Join FrDetres b (NoLock) On a.siCodMun=b.siCodMun And a.cNumRes=b.cNumRes 
                                                               Where a.siCodMun = Md.siCodMun And b.cNumDoc = Md.cNumDoc) 
                           When Md.siCodCre = 821 Then (Select b.cNumPer 
						                                From FrMaeres a (NoLock) 
														Inner Join FrMaeper b (NoLock) On a.siCodMun=b.siCodMun And a.cNumRes=b.cNumRes 
                                                        Where a.siCodMun = Md.siCodMun And b.cNumDoc = Md.cNumDoc) 
                           Else '' End,''), 
						   */
                 [cPlaca] = '',
				 /*
				 Isnull((Select Top 1 cPlaca 
                                             From rdDocVeh Dv (Nolock) 
											 Inner Join rddjvafe Av  (Nolock) On Dv.siCodmun = Av.siCodmun And Dv.iNumCor = Av.iNumCor 
                                             Where Dv.sicodmun = Md.SicodMun And Dv.icodper = Md.iCodPer 
                                               And Av.Sicodmun= Md.SicodMun And Av.inumafe = Md.inumafe  
                                             Group By cPlaca  
                                             Having Count(cPlaca) = 1) , '' ) ,
                 */
                 --
                 [cPeriodo] = Cast(Cast(Md.siAnoAfe As Char(4)) + '-' + Replicate('0',  2 - Len(Md.siPerAfe)) + Cast(Md.siPerAfe As VarChar(2)) As Varchar(8)), 
				 --
                 [nTotal] = (nCuota + nDeremi + nCostas + nGastos  + nReajus  + nIntere + nMora + nMorAcu) - (nCuotaC + nReajusC + nDeremiC+ nIntereC + nMoraC + nMorAcuC + nCostasC + nGastosC - nDescue), 
				 --
                 [SiPerAfe] = Md.siPerAfe, 
                 [sdFecEmi] =  Convert(Char(10), sdFecEmi, 103), 
                 sdFecVen  = Convert(Char(10), sdFecVen, 103) ,
				 /*Case 
				                When Md.siCodCre In (145,146,200,400) And sdFecVen > = '01/01/2020' Then dbo.fnSGD_Deuda_DevolverFechaVencimiento(Md.sicodMun,Md.cNumDoc)
								Else Convert(Char(10), sdFecVen, 103) 
							End, 
							*/
                 sdFecVenA = Convert(Char(10), sdFecVenA, 103), 
				 --
                 [nCuota] = dbo.fnSGD_FormatearPresentacionImportes(nCuota - nCuotaC, 2), 
                 [nSaldo] = dbo.fnSGD_FormatearPresentacionImportes(nSaldo, 2), 
				 --
                 [iCodPer] = Md.iCodPer, 
                 [sicodcre] = Md.siCodCre, 
                 [nImporte] = nCuota + nReajus, 
                 [nInteres] = 0, 
                 [vPersona] = 'update por tmp',
				 /*
				 Rtrim(Ltrim((Select Case RdMaePer.siTipPer 
                                                     When 1 Then Str(Md.iCodPer)+'-'+Rtrim(Ltrim(vApePat)) + Space(1) + Rtrim(Ltrim(vApeMat)) + ',' + Space(1) + Rtrim(Ltrim(vNombre)) 
                                                     When 2 Then Str(Md.iCodPer)+'-'+Rtrim(Ltrim(vRazSoc)) 
                                                     Else Str(Md.iCodPer)+'-' +Rtrim(Ltrim(vApePat)) + Space(1) + Rtrim(Ltrim(vApeMat)) + ',' + Space(1) + Rtrim(Ltrim(vNombre)) 
                                                  End 
                                           From RdMaePer (Nolock) Where iCodper = Md.iCodPer))), 
										   */
                 [nImpori] = nImpori, 
				 --
                [nDeremi] = dbo.fnSGD_FormatearPresentacionImportes(nDeremi - nDeremiC, 2), 
                [nReinci] = dbo.fnSGD_FormatearPresentacionImportes(nReinci - nReinciC, 2), 
                [nReajuste] = dbo.fnSGD_FormatearPresentacionImportes(nReajus - nReajusC, 2),  
                [nCostas] = dbo.fnSGD_FormatearPresentacionImportes(nCostas - nCostasC, 2), 
                [nGastos] = dbo.fnSGD_FormatearPresentacionImportes(nGastos - nGastosC, 2), 
                [nIntere] = dbo.fnSGD_FormatearPresentacionImportes(nIntere - nIntereC, 2), 
                [nIntereDif] = 0, 
                [nMora] =  dbo.fnSGD_FormatearPresentacionImportes(nMora - nMoraC ,2), 
                [nMorAcu] = nMorAcu - nMorAcuC,
                [nCuotaCob] = nCuota,
                [nDerEmiCob]= nDerEmi,
                [nReinciCob]= nReinci,
                [nReajusCob]= nReajus,
                [nIntereCob]= nIntere,
                [nMoraCob]  = nMora,
                [nMorAcuCob]= nMorAcu,
                [nCostasCob]= nCostas,
                [nGastosCob]= nGastos,
                [nCuotaEmi] = nCuotaC,
                [nDerEmiEmi]= nDerEmiC,
                [nReinciEmi]= nReinciC,
                [nReajusEmi]= nReajusC,
                [nIntereEmi]= nIntereC,
                [nMoraEmi]  = nMoraC,
                [nMorAcuEmi]= nMorAcuC,
                [nCostasEmi]= nCostasC,
                [nGastosEmi]= nGastosC,
                [siCodGEm]= md.siCodGEm,
                MD.siCodMun,
                [nDescue] = nDescue  ,
                [SiTipEdo] = siTipEdo, 
                [siAnoAfe] = Md.siAnoAfe, 
                sdFecInt, Md.sdFecEnv, 
                [cPendiente] =    (Case 
				                      When Md.SiTipEdo Is Null Or SiTipEdo = 1 Then 'SI' 
                                      When SiTipEdo = 2 Or SiTipEdo = 4 Then (Case siCodFra 
									                                             When 2 Then 'SI' 
                                                                                 When 4 Then 'SI' 
                                                                                 Else 'NO' 
                                                                              End) 
                                      Else 'NO' 
                                   End), 
                 Md.iNumAfe, 
                siCodPag, 
                cMarca = '', 
                nMorDIf = 0, 
				--
                [nTotConDscto] = (nCuota + nDeremi + nCostas + nGastos  +  nReajus  + nIntere + nMora + nMorAcu)  +  -(nCuotaC + nReajusC + nDeremiC+ nIntereC + nMoraC + nMorAcuC + nCostasC + nGastosC - nDescue), 
				--
                dbo.fnTRe_ArbLP( 1,Md.inumafe) As LP, 
				dbo.fnTRe_ArbPj( 1,Md.inumafe) As PJ, 
				dbo.fnTRe_ArbSe( 1,Md.inumafe) As SE,
                [cImp] = 'P',
				dbo.fnSGD_NumDoc_VerificarTipoResTramite(1, Md.cNumDoc) As CodTipoT, 
				0 As MontoCompensado,
				----
				af.iNumCor,
				af.siUniAfe, Af.siUniIna
 From  RdMaeDeu Md with (NoLock, Index(Ix_RdMaeDeu_09))
 Left Join RdMaeAfe Af  (Nolock) On Md.siCodMun = Af.siCodMun and Md.iNumAfe = Af.iNumAfe 
 Where Md.siCodMun = 1 And Md.iCodPer = 8715 And Md.SitipEdo=1 
 ---------------------------------------------------------------------------------
 Create Index ix_tmpDeuda2_01 On #tmpDeuda2 (iCorrel)        
 Create Index ix_tmpDeuda2_02 On #tmpDeuda2 (siCodMun,cNumDoc)        
 Create Index ix_tmpDeuda2_03 On #tmpDeuda2 (siCodMun,iNumAfe)        
 Create Index ix_tmpDeuda2_04 On #tmpDeuda2 (siCodMun,iNumCor)        
 ---------------------------------------------------------------------------------
 update #tmpDeuda2
 set cConcepto = b.vDeaCre
 from #tmpDeuda2 a
 inner join sgTabCre b (nolock) on a.siCodCRe = b.siCodCRe
 where b.siCodEst=1
 --------------
  update #tmpDeuda2
 set vReferencia = Case 
                          When Md.siCodCre = 145 Then (Select Top 1 Case 
						                                               When Md.siUniAfe + Md.siUniIna > 1 Then ' ' 
																	   Else DP.vDesDom 
																	End 
                                                        From RdDocpre DP (NoLock) 
														Inner Join RdDjpafe DJ (NoLock) On DP.siCodMun = DJ.siCodMun and DP.iNumCor = DJ.iNumCor 
                                                        Where DJ.siCodMun = Md.siCodMun And DJ.iNumAfe = Md.iNumAfe) 
                           When Md.siCodCre = 110 Then (Select a.vDesDom 
						                                 From RDMAEALC a (Nolock) 
														 Where a.siCodMun = MD.siCodMun and a.iNumDJ = Md.iNumCor) 
                           When Md.siCodCre = 145 Then (Select Top 1 Case 
						                                               When Md.siUniAfe + Md.siUniIna > 1 Then ' (+) ' 
																	   Else a.vDesDom 
																	 End  
														From RdDocpre a (NoLock) 
														Inner Join RdDjpafe b (NoLock) On a.siCodMun = b.siCodMun And a.iNumCor = b.iNumCor  
														Where b.siCodMun = Md.siCodMun And b.iNumAfe = Md.iNumAfe) 
                           When Md.siCodCre = 146 Then (Select Top 1 Case 
						                                                When Md.siUniAfe + Md.siUniIna > 1 Then '(+) ' 
																		Else a.cPlaca + ' - ' + a.cNroMot 
																	 End 
                                                         From RdDocveh a (NoLock) 
														 Inner Join RdDjvafe b (NoLock) On a.siCodMun = b.siCodMun And a.iNumCor = b.iNumCor 
                                                         Where b.siCodMun = Md.siCodMun And b.iNumAfe = Md.iNumAfe) 
                           When Md.siCodCre = 200 Then (Select a.vDesDom 
						                                From RdDocpre a (NoLock) 
														Where a.siCodMun = Md.siCodMun And a.iNumCor = Md.iNumCor) 
                           When Md.siCodCre = 390 Then (Select c.vDesDer 
						                                From RdMaeder a (NoLock) 
														Inner Join ReMaeDer c (NoLock) On a.siCodMun=c.siCodMun And a.cCodDer=c.cCodDer 
                                                        Where a.siCodMun = Md.siCodMun And a.iNumDer = Md.iNumCor) 
                           When Md.siCodCre = 400 Then (Select Convert(Varchar(20),a.siCodMTr) 
                                                        From RdMaeMuT a (NoLock) 
														Where a.siCodMun = Md.siCodMun And a.iNumMul = Md.iNumCor) 
                           When Md.siCodCre In (820,823) Then (Select a.cNumRes 
						                                       From FrMaeres a (NoLock) 
															   Inner Join FrDetres b (NoLock) On a.siCodMun=b.siCodMun And a.cNumRes=b.cNumRes 
                                                               Where a.siCodMun = Md.siCodMun And b.cNumDoc = Md.cNumDoc) 
                           When Md.siCodCre = 821 Then (Select b.cNumPer 
						                                From FrMaeres a (NoLock) 
														Inner Join FrMaeper b (NoLock) On a.siCodMun=b.siCodMun And a.cNumRes=b.cNumRes 
                                                        Where a.siCodMun = Md.siCodMun And b.cNumDoc = Md.cNumDoc) 
                           Else '' 
						   End
 from #tmpDeuda2 Md
 ----------------------------------------
 update #tmpDeuda2
 set vPersona = Case b.siTipPer 
                   When 1 Then Str(a.iCodPer)+'-'+Rtrim(Ltrim(b.vApePat)) + ' ' + Rtrim(Ltrim(b.vApeMat)) + ', ' + Rtrim(Ltrim(b.vNombre)) 
                   When 2 Then Str(a.iCodPer)+'-'+Rtrim(Ltrim(b.vRazSoc)) 
                   Else Str(a.iCodPer)+'-' +Rtrim(Ltrim(b.vApePat)) + ' ' + Rtrim(Ltrim(b.vApeMat)) + ', ' + Rtrim(Ltrim(b.vNombre)) 
                End
 from #tmpDeuda2 a
 inner join RdMaePer b with (nolock) on (a.iCodper = b.iCodPer)
 ----
 update #tmpDeuda2
 set sdFecVen = dbo.fnSGD_Deuda_DevolverFechaVencimiento(a.sicodMun, a.cNumDoc)
 from #tmpDeuda2 a
 where a.siCodCre In (145,146,200,400) And a.sdFecVen > = '01/01/2020'
 ---------
 update #tmpDeuda2
 set cPlaca = (Select Top 1 cPlaca 
               From rdDocVeh Dv (Nolock) 
			   Inner Join rddjvafe Av  (Nolock) On Dv.siCodmun = Av.siCodmun And Dv.iNumCor = Av.iNumCor 
               Where Dv.sicodmun = Md.SicodMun And Dv.icodper = Md.iCodPer 
                 And Av.Sicodmun= Md.SicodMun And Av.inumafe = Md.inumafe  
               Group By cPlaca  
               Having Count(cPlaca) = 1)
 from #tmpDeuda2 Md
  -----
  -- select * from #tmpDeuda2

