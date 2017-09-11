Use Siat002
go

--------------------------------------------------------------------------------------------------------------  
/* Database name      : SIAT TRIBUTARIO                                                                     */  
/* DBMS name          : Microsoft SQL Server 2000                                                           */  
/* Descripcion        : SP que ubica y calcula la deuda a una fecha determinada, segun criterios de busqueda*/  
/*                      y considerando si el documento ya fue compensado.                                   */  
/* Input              : @psicodMun    -- Cod. de Municipalidad                                              */  
/*                      @pcCodPer     -- Cod. Administrado                                                  */  
/*                      @pSicodCre    -- Cod. de Concepto                                                   */  
/*                      @piCodPreVeh  -- Cod.                                                               */  
/*                      @pcNumDoc     -- Doc. de Deuda                                                      */  
/*                      @psiAnoAfe    -- Año de Afectacion                                                  */  
/*                      @psiPerAfe    -- Periodo de Afectacion                                              */  
/*                      @pcFecCal     -- Fecha de calculo                                                   */  
/*                      @pcNumPro     -- Numero de proyecto                                                 */  
/*                      @psiOpcion    -- Opcion / Busqueda por 0: Deuda, 1: Predio, 2: Vehiculo             */  
/* Output             : Proceso                                                                             */  
/* Creado por         : Oimer Pérez                                                                         */  
/* Fec Creación       : <15/06/2007>                                                                        */  
--------------------------------------------------------------------------------------------------------------  
--  Modificado por   : Alexander Huaccho Magro         Fecha   : 06/08/2009                                             
--  Motivo           : parametrización de para Obtener Fecha de vencimiento fisca                         
--  Requerimiento    : 36592  
--------------------------------------------------------------------------------------------------------------  
--  Modificado por   : Victor Hugo Ore Mustto          Fecha   :   
--  Motivo           : Integracion SGD  
--------------------------------------------------------------------------------------------------------------  
/* Fec. Actualización : 25/01/2010                                                                          */      
/* Responsable        : Williams Vargas Mamani                                                              */        
/* Motivo             : Actualizacion de Observaciones, se coloco los NoLock necesarios                     */        
--------------------------------------------------------------------------------------------------------------
/* Fec. Actualización : 07/05/2010                                                                          */      
/* Responsable        : Miller R. Vega Zuloaga                                                              */        
/* Motivo             : Se ha cambiado la longitud del campo del tempral #tmpDeuda2                         */        
--------------------------------------------------------------------------------------------------------------
/*
   Exec spsgd_Compensacion_ConsultarDeudaSimulacion 1, '0', 0, 0, '10403493101', 0, 0, '14/04/2004', '', 0  
   Exec spsgd_Compensacion_ConsultarDeudaSimulacion 1, '0', 0, 0, '10818867146', 0, 0, '', '00002300174771', 0
   Exec spsgd_Compensacion_ConsultarDeudaSimulacion 1, '8715', 145, 0, '', 0, 0, '', '', 0
*/
alter Procedure dbo.spSGD_Compensacion_ConsultarDeudaSimulacion_opt_macv
(  @psicodMun    SmallInt,  
   @pcCodPer     Char(10),  
   @psicodCre    SmallInt,  
   @piCodPreVeh  Integer ,  
   @pcNumDoc     Char(16) = '',  
   @psiAnoAfe    Smallint,  
   @psiPerAfe    Smallint,  
   @pcFecCal     Char(10),  
   @pcNumPro     Char(14),  
   @psiOpcion    SmallInt = 0 -- Busqueda por 0: Deuda, 1: Predio, 2: Vehiculo  
)  
AS  
Begin  
 --   Configuracion de entorno  

   Set NoCount ON
	Set Quoted_Identifier On
   Set DateFormat DMY  
     
   -- Declaracion de Variables  
   -- Para formacion de cadena de consulta  
   Declare  
      @vSQL         Varchar(8000),  
      @vSQL2        Varchar(8000),  
      @vSQL3        Varchar(8000),  
      @vCondicion   VarChar(200) ,  
      --   Para fechas  
      @sdFecVen     SmallDatetime,  
      @sdFecVenA    SmallDatetime,  
      --   Para contener valores de los componentes  
      @nCuota       Numeric(11,2),  
      @nDerEmi      Numeric(11,2),   
      @nReajus      Numeric(11,2),  
      @nReinci      Numeric(11,2),   
      @nCostas      Numeric(11,2),   
      @nGastos      Numeric(11,2),  
      @nDescue      Numeric(11,2),   
      @nIntere      Numeric(11,2),   
      @nMora        Numeric(11,2),  
      @nMorAcu      Numeric(11,2),   
      @nCuotaImg    Numeric(11,2),   
      @nReajusteImg Numeric(11,2),   
      @nDeremiImg   Numeric(11,2),   
      @nIntereImg   Numeric(11,2),   
      @nMoraImg     Numeric(11,2),   
      @nMorAcuImg   Numeric(11,2),   
      @nCostasImg   Numeric(11,2),   
      @nGastosImg   Numeric(11,2),   
      @nDescueImg   Numeric(11,2),   
      @nMoraPen     Numeric(10,2),   
      @nMorAcuPen   Numeric(10,2),  
      @siAnoAfe     SmallInt,  
      @siPerAfe     SmallInt,  
      @siCodGEm     SmallInt,  
      @siCodBEm     SmallInt,  
      @nCuotaC      Numeric(11,2),  
      @nDerEmiC     Numeric(11,2),  
      @nReinciC     Numeric(11,2),  
      @nReajusC     Numeric(11,2),  
      @nIntereC     Numeric(11,2),  
      @nMoraC       Numeric(11,2),  
      @nMorAcuC     Numeric(11,2),  
      @nCostasC     Numeric(11,2),  
      @nGastosC     Numeric(11,2),  
      @siCodCre     SmallInt     ,  
      @sdFecInt     SmallDateTime,  
      -- Variables para recorrer tabla temporal  
      @iTotal       Integer,  
      @i            Integer,  
      @cImp         Char(1)  
     
      Declare @cFecVenF  Char(10)  
     
      -- Obtenemos Fecha de Vencimiento de deuda fiscalizada  
      Select @cFecVenF = vValPar   
      From SGTabPar (NoLock)  
      Where siCodMun = @psiCodMun  
        And cCodMod  = 'Rd'  
        And siTipPar = 2  
        And siCodPar = 16  
   ------------------------
   -- Creacion de tabla temporal        
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
      cPJ        Char(50)       , cSE         Char(50)     , cImp         Char(1)    , 
	  iNumCor    Integer        , siUniAfe    Smallint      , siUniIna    Smallint
   ) 
	  -----------------------------     
   -- Asignacion de valores iniciales  
   Select @vSQL2 = ''  
     
   If @pcCodPer=0  
      Set @pcCodPer = 'Md.iCodPer'
     
   --   Formar los criterios de busqueda  
   Set @vCondicion = ''  
     
   If Ltrim(Rtrim(@pcNumDoc)) <> ''
      Set @vCondicion = ' And Md.cNumOri = ''' + Rtrim(Ltrim(@pcNumDoc)) + ''''
     
   If @psicodCre <> 0  
   Begin  
      If @vCondicion <> ''  
         Set @vCondicion = @vCondicion + ' and '
      Else  
         Set @vCondicion = ' and ' 
     
      Set @vCondicion = @vCondicion + ' Md.SiCodCre = ' + Str(@pSicodCre)  
   End  
     
   If @psiAnoAfe <> 0  
   Begin  
      If @vCondicion <> ''  
         Set @vCondicion = @vCondicion + ' and '  
      Else  
         Set @vCondicion = ' and '  
     
      Set @vCondicion = @vCondicion + ' Md.SiAnoAfe = ' + Str(@psiAnoAfe)  
   End  
     
   If @psiPerAfe <> 0  
   Begin  
      If @vCondicion <> ''  
         Set @vCondicion = @vCondicion + ' and '
      Else  
         Set @vCondicion = ' and '
     
      Set @vCondicion = @vCondicion + ' Md.SiPerAfe = ' + Str(@psiPerAfe)  
   End  
   --
   -- Formacion de cadena para consulta de busqueda  
   --
   Set @vSQL = ' Select ' + Char(10) +
      '[cConcepto] = '''' , ' + Char(10) +
      '[cNumDoc] = Md.cNumDoc, ' + Char(10) +
      '[cNumOri] = Md.cNumOri,  ' + Char(10) +
      '[siReclamo] =  dbo.fnSGD_NumDoc_VerificarSiDeudaReclamada(1, Md.cNumDoc),' + Char(10) +
      '[vReferencia] = '''' , ' + Char(10) +
      '[cPlaca] = '''' ,' + Char(10) +
      '[cPeriodo] = Cast(Cast(Md.siAnoAfe As Char(4)) + ''-'' + Replicate(''0'',  2 - Len(Md.siPerAfe)) ' + '+ Cast(Md.siPerAfe As VarChar(2)) As Varchar(8)), ' + Char(10) +
      '[nTotal] = (nCuota + nDeremi + nCostas + nGastos  + nReajus  + nIntere + nMora + nMorAcu) - (nCuotaC + nReajusC + nDeremiC+ nIntereC + nMoraC + nMorAcuC + nCostasC + nGastosC - nDescue), ' + Char(10) +
      '[SiPerAfe] = Md.siPerAfe, ' + Char(10) +        
      '[sdFecEmi] =  Convert(Char(10), sdFecEmi, 103), ' + Char(10) +        
      'sdFecVen  = Convert(Char(10), sdFecVen, 103), ' + Char(10) +        
      'sdFecVenA = Convert(Char(10), sdFecVenA, 103), ' + Char(10) +        
      '[nCuota] = dbo.fnSGD_FormatearPresentacionImportes(nCuota - nCuotaC, 2), '  + Char(10) +        
      '[nSaldo] = dbo.fnSGD_FormatearPresentacionImportes(nSaldo, 2), ' + Char(10) +        
      '[iCodPer] = Md.iCodPer, ' + Char(10) +        
      '[sicodcre] = Md.siCodCre, ' + Char(10) +        
      '[nImporte] = nCuota + nReajus, '   + Char(10) +        
      '[nInteres] = 0, ' + Char(10) +        
      '[vPersona] = '''' , ' + Char(10) +        
      '[nImpori] = nImpori, ' + Char(10) +        
      '[nDeremi] = dbo.fnSGD_FormatearPresentacionImportes(nDeremi - nDeremiC, 2), ' + Char(10) +        
      '[nReinci] = dbo.fnSGD_FormatearPresentacionImportes(nReinci - nReinciC, 2), ' + Char(10) +        
      '[nReajuste] = dbo.fnSGD_FormatearPresentacionImportes(nReajus - nReajusC, 2),  ' + Char(10) +        
      '[nCostas] = dbo.fnSGD_FormatearPresentacionImportes(nCostas - nCostasC, 2), ' + Char(10) +        
      '[nGastos] = dbo.fnSGD_FormatearPresentacionImportes(nGastos - nGastosC, 2), ' + Char(10) +        
      '[nIntere] = dbo.fnSGD_FormatearPresentacionImportes(nIntere - nIntereC, 2), '  + Char(10) +        
      '[nIntereDif] = 0, ' + Char(10) +        
      '[nMora] =  dbo.fnSGD_FormatearPresentacionImportes(nMora - nMoraC ,2), ' + Char(10) +        
      '[nMorAcu] = nMorAcu - nMorAcuC,' + Char(10) +        
      '[nCuotaCob] = nCuota,' + Char(10) +        
      '[nDerEmiCob]= nDerEmi,' + Char(10) +        
      '[nReinciCob]= nReinci,' + Char(10) +        
      '[nReajusCob]= nReajus,' + Char(10) +        
      '[nIntereCob]= nIntere,' + Char(10) +        
      '[nMoraCob]  = nMora,' + Char(10) +        
      '[nMorAcuCob]= nMorAcu,' + Char(10) +        
      '[nCostasCob]= nCostas,' + Char(10) +        
      '[nGastosCob]= nGastos,' + Char(10) +        
      '[nCuotaEmi] = nCuotaC,' + Char(10) +        
      '[nDerEmiEmi]= nDerEmiC,' + Char(10) +        
      '[nReinciEmi]= nReinciC,' + Char(10) +        
      '[nReajusEmi]= nReajusC,' + Char(10) +        
      '[nIntereEmi]= nIntereC,' + Char(10) +        
      '[nMoraEmi]  = nMoraC,' + Char(10) +        
      '[nMorAcuEmi]= nMorAcuC,' + Char(10) +        
      '[nCostasEmi]= nCostasC,' + Char(10) +        
      '[nGastosEmi]= nGastosC,' + Char(10) +        
      '[siCodGEm]= md.siCodGEm,' + Char(10) +        
      'MD.siCodMun, ' + Char(10) +        
      '[nDescue] = nDescue  ,' + Char(10) +        
      '[SiTipEdo] = siTipEdo, ' + Char(10) +        
      '[siAnoAfe] = Md.siAnoAfe, ' + Char(10) +        
      'sdFecInt, Md.sdFecEnv, ' + Char(10) +        
      '[cPendiente] =    (Case ' + Char(10) +        
      'When Md.SiTipEdo Is Null Or SiTipEdo = 1 Then ''SI'' '  + Char(10) +        
      'When SiTipEdo = 2 Or SiTipEdo = 4 Then ' + Char(10) +        
      '(Case siCodFra ' + Char(10) +        
      ' When 2 Then ''SI'' ' + Char(10) +        
      ' When 4 Then ''SI'' ' + Char(10) +        
      ' Else ''NO'' ' + Char(10) +        
      'End) '  + Char(10) +        
      'Else ''NO'' '  + Char(10) +        
      'End), '  + Char(10) +        
      'Md.iNumAfe, '  + Char(10) +        
      'siCodPag, '  + Char(10) +        
      'cMarca = '''', ' + Char(10) +        
      'nMorDIf = 0, ' + Char(10)         
      
   Set @vSQL3=''        
           
   Set @vSQL3='[nTotConDscto] = (nCuota + nDeremi + nCostas + nGastos  + nReajus  + nIntere + nMora + nMorAcu)  + ' + 
             ' -(nCuotaC + nReajusC + nDeremiC+ nIntereC + nMoraC + nMorAcuC + nCostasC + nGastosC - nDescue), ' + Char(10) +        
      ' dbo.fnTRe_ArbLP('+str(@psiCodMun)+',Md.inumafe) As LP,' +        
      ' dbo.fnTRe_ArbPj('+str(@psiCodMun)+',Md.inumafe) As PJ,' +        
      ' dbo.fnTRe_ArbSe('+str(@psiCodMun)+',Md.inumafe) As SE,' + Char(10) +        
      '[cImp] = ''P'',' +  
	  ' af.iNumCor, af.siUniAfe, Af.siUniIna'
   -----------------------------------------------------------------------------------------------------------------------
   If @psiOpcion = 0  -- Buscar Solo en Maestro de Deuda        
      Set @vSQL2 = @vSQL2 + ' From  RdMaeDeu Md with (NoLock, Index = Ix_RdMaeDeu_09)'  + Char(10) +        
          ' Left Join RdMaeAfe Af  (Nolock) On Md.siCodMun = Af.siCodMun and Md.iNumAfe = Af.iNumAfe ' + Char(10) +        
          ' Where Md.siCodMun = ' + Str(@psicodMun) + 
          ' And Md.iCodPer = ' + (@pcCodPer) +        
          ' And Md.SitipEdo = 1 ' + @vCondicion
   Else        
      If @psiOpcion = 1   -- Buscar Por Predio        
         Set @vSQL2 = @vSQL2 + ' From Rdmaeafe A (Nolock)' + Char(10) +        
             ' Inner Join RDMaeDeu Md (Nolock) ON a.siCodMun = Md.siCodMun And a.iNumAfe = Md.iNumAfe ' + Char(10) +        
             ' Left Join RdMaeAfe Af (Nolock) On Md.siCodMun = Af.siCodMun And Md.iNumAfe = Af.iNumAfe ' +Char(10) +        
             ' Inner Join RDDocPre (Nolock) On a.siCodMun = RDDocPre.siCodMun And a.iNumCor = RDDocPre.iNumCor ' + Char(10) +        
             ' Where Md.SicodMun = ' + Str(@psiCodMun) + 
			   ' And Md.iCodPer = ' +  Str(@pcCodPer) + 
   			   ' And Md.SitipEdo = 1 ' +
			   ' And RDDocPre.iCodPre = ' + Str(@piCodPreVeh) + @vCondicion

      Else        
         If @psiOpcion = 2   -- Buscar Por Vehiculo        
            Set @vSQL2 = @vSQL2 + ' From Rddjvafe  (Nolock)' + Char(10) +        
                ' Inner Join RDMaeDeu Md(Nolock) On Rddjvafe.siCodMun = Md.siCodMun And Rddjvafe.iNumAfe = Md.iNumAfe ' + Char(10) +
                ' Left Join RdMaeAfe Af (Nolock) On Md.siCodMun = Af.siCodMun And Md.iNumAfe = Af.iNumAfe ' + Char(10) +
                ' Inner Join RDDocVeh (Nolock) On Rddjvafe.siCodMun = RDDocVeh.siCodMun And Rddjvafe.iNumCor = RDDocVeh.iNumCor ' + Char(10) +       
                ' Where Md.siCodMun = ' + Str(@psiCodMun) +        
                  ' And Md.iCodPer = ' + Str(@pcCodPer) +        
				  ' And Md.SitipEdo = 1 ' +
                  ' And RDDocVeh.iCodVeh = '  + Str(@piCodPreVeh) + @vCondicion
         Else
		    Set @vSQL2 = @vSQL2
   --
   -- Insercion de consulta en tabla temporal  
   Insert Into #tmpDeuda2  
   Exec (@vSQL+@vSQL3+@vSQL2)  
   --    
   Create Index ix_tmpDeuda2_01 On #tmpDeuda2 (iCorrel)        
   Create Index ix_tmpDeuda2_02 On #tmpDeuda2 (siCodMun,cNumDoc)        
   Create Index ix_tmpDeuda2_03 On #tmpDeuda2 (siCodMun,iNumAfe)        
   Create Index ix_tmpDeuda2_04 On #tmpDeuda2 (siCodMun,iNumCor)        
   Create Index ix_tmpDeuda2_05 On #tmpDeuda2 (siCodCre,sdFecVen)        
   -----------------------------
   Update #tmpDeuda2
       set cConcepto = b.vDeaCre
   From #tmpDeuda2 a
   Inner Join sgTabCre b (Nolock) on a.siCodCRe = b.siCodCRe
   Where b.siCodEst=1
   --------------
   Update #tmpDeuda2
       Set vReferencia = Case 
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
   From #tmpDeuda2 Md
   ----------------------------------------
   Update #tmpDeuda2
       Set vPersona = Case b.siTipPer 
                   When 1 Then Str(a.iCodPer)+'-'+Rtrim(Ltrim(b.vApePat)) + ' ' + Rtrim(Ltrim(b.vApeMat)) + ', ' + Rtrim(Ltrim(b.vNombre)) 
                   When 2 Then Str(a.iCodPer)+'-'+Rtrim(Ltrim(b.vRazSoc)) 
                   Else Str(a.iCodPer)+'-' +Rtrim(Ltrim(b.vApePat)) + ' ' + Rtrim(Ltrim(b.vApeMat)) + ', ' + Rtrim(Ltrim(b.vNombre)) 
                End
   From #tmpDeuda2 a
   Inner Join RdMaePer b with (nolock) on (a.iCodper = b.iCodPer)
   --------------
   Update #tmpDeuda2
       Set sdFecVen = dbo.fnSGD_Deuda_DevolverFechaVencimiento(a.sicodMun, a.cNumDoc)
   From #tmpDeuda2 a
   Where a.siCodCre In (145,146,200,400) And a.sdFecVen > = @cFecVenF
   ---------
   Update #tmpDeuda2
      Set cPlaca = (Select Top 1 cPlaca 
               From rdDocVeh Dv (Nolock) 
               Inner Join rddjvafe Av  (Nolock) On Dv.siCodmun = Av.siCodmun And Dv.iNumCor = Av.iNumCor 
               Where Dv.sicodmun = Md.SicodMun And Dv.icodper = Md.iCodPer 
                 And Av.Sicodmun= Md.SicodMun And Av.inumafe = Md.inumafe  
               Group By cPlaca  
               Having Count(cPlaca) = 1)
   From #tmpDeuda2 Md
   -----------------------------        
   --   
   -- Obtener numero de registros  
   Select @iTotal = Count(*)  
   From #tmpDeuda2  
     
   -- Iniciar Bucle  
   Select @i = 1, @cImp = '', @pcNumPro = LTrim(RTrim(@pcNumPro))    
   --------------------------------------------------------------------------
   While @i <= @iTotal  
   Begin  
      -- Obtener documento de deuda y Fecha de Vencimiento  
      Select @pcNumDoc = cNumDoc, @sdFecVen = sdFecVen   
      From #tmpDeuda2 (NoLock)   
      Where iCorrel = @i  
     
      Set @cImp = ''  
     
      -- Verificar si fue imputado anteriormente, totalmente o parcialmente.  
      Select @cImp = bImp   
      From GdDetCom (NoLock)   
      Where siCodMun = @psicodMun   
         And cNumDoc = @pcNumDoc   
         And cNumPro = @pcNumPro  
         And bEjecuta = 0              
     
      -- Si documento ya fue compensado anteriormente  
      If @cImp <> ''   
      Begin  
         -- Asignar ubicacion de tablas desde las cuales se extraera la data  
         If @cImp = 'P' -- Imputación parcial  
         Begin  
            Select  @siCodCre  = a.siCodCre, @sdFecInt = a.sdFecInt, @siAnoAfe =   a.siAnoAfe,   @siPerAfe = a.siPerAfe,  
                  @siCodGEm  = siCodGEm  ,   @siCodBEm = b.siCodBEm,   @sdFecVen = a.sdFecVen,   @sdFecVenA= a.sdFecVenA,  
                  @nCuota    = a.nCuota  ,   @nCuotaC    = a.nCuotaC ,   @nDerEmi  = a.nDerEmi , @nDerEmiC = a.nDerEmiC,  
                  @nReinci   = a.nReinci , @nReinciC = a.nReinciC,   @nReajus  = a.nReajus , @nReajusC = a.nReajusC,  
                  @nIntere   = a.nIntere , @nIntereC = a.nIntereC,   @nMora    = a.nMora   ,   @nMoraC   = a.nMoraC,  
                  @nMorAcu   = a.nMorAcu , @nMorAcuC = a.nMorAcuC,   @nCostas  = a.nCostas , @nCostasC = a.nCostasC,  
                  @nGastos   = a.nGastos , @nGastosC = a.nGastosC,   @nDescue  = a.nDescue ,  
                  @nCuotaImg = Case   
                                  When (nCuota-nCuotaC)<0 Then 0   
                                  Else (nCuota-nCuotaC)   
                               End,  
                  @nReajusteImg = Case   
                                     When (nReajus-nReajusC)<0 Then 0   
                                     Else (nReajus-nReajusC)   
                                   End,  
                  @nDeremiImg  = Case   
                                    When (nDerEmi-nDeremiC)<0 Then 0   
                                    Else (nDerEmi-nDeremiC)   
                                  End,  
                  @nIntereImg  = Case   
                                    When (nIntere-nIntereC)<0 Then 0   
                                    Else (nIntere-nIntereC)   
                                  End,   
                  @nMoraImg    = Case   
                                    When (nMora-nMoraC)<0     Then 0   
                                    Else (nMora-nMoraC)       
                                  End,  
                  @nMorAcuImg  = Case   
                                When (nMorAcu-nMorAcuC)<0 Then 0   
                                    Else (nMorAcu-nMorAcuC)   
                                  End,  
                  @nCostasImg  = Case   
                                    When (nCostas-nCostasC)<0 Then 0   
                                    Else (nCostas-nCostasC)   
                                 End,  
                  @nGastosImg  = Case   
                                    When (nGastos-nGastosC)<0 Then 0   
                                    Else (nGastos-nGastosC)   
                                  End,  
                  @nDescueImg  = nDescue  
            From RdMaeDeuTmp a  (NoLock)  
            Left Join RdProBen b (NoLock) On a.iCodper = b.iCodPer And a.siCodCRe = b.siCodCre And a.siAnoAfe = b.siAnoAfe  
            Where siCodMun = @psicodMun   
              And cNumDoc = @pcNumDoc  
              And cNumPro = @pcNumPro  
            --
            -- Actualizar componentes  
            Update #tmpDeuda2  
               Set nCuota    = IsNull(@nCuotaImg,0) ,  nIntere   = IsNull(@nIntereImg,0),  
                   nDerEmi   = IsNull(@nDeremiImg,0),  nInteres  = IsNull(@nIntereImg,0),    
                   nMora     = IsNull(@nMoraImg,0)  ,  nMorAcu   = IsNull(@nMorAcuImg,0),  
                   nCostas   = IsNull(@nCostasImg,0),  nGastos   = IsNull(@nGastosImg,0),  
                   nReajuste = IsNull(@nReajusteImg,0)  
            Where iCorrel = @i  
            --
            -- Actualizar totales  
            Update #tmpDeuda2  
               Set nTotal = IsNull(@nReajusteImg,0) +   
                            IsNull(@nCuotaImg,0) + IsNull(@nDeremiImg,0) + IsNull(@nIntereImg,0) + IsNull(@nMoraImg,0) + IsNull(@nMorAcuImg,0) +  IsNull(@nCostasImg,0) + IsNull(@nGastosImg,0),   
                   nTotConDscto = IsNull(@nReajusteImg,0) +  
                            IsNull(@nCuotaImg,0) + IsNull(@nDeremiImg,0) + IsNull(@nIntereImg,0) + IsNull(@nMoraImg,0) + IsNull(@nMorAcuImg,0) +  IsNull(@nCostasImg,0) + IsNull(@nGastosImg,0)  
            Where  iCorrel = @i  
         End  
         Else --   Imputación Total  
            -- Actualizar componentes  
            Update #tmpDeuda2  
               Set cImp='T',  
                   nTotal   = 0, nTotConDscto = 0, nCuota   = 0, nSaldo   = 0,  
                   nImporte = 0, nInteres     = 0, nImpori  = 0, nDeremi  = 0,  
                   nReinci  = 0, nReajuste    = 0, nCostas  = 0, nGastos  = 0,  
                   nIntere  = 0, nIntereDIf   = 0, nMora    = 0, nMorAcu  = 0,  
                   nDescue  = 0  
            Where  iCorrel = @i  
      End  
      Else --   SI DOCUMENTO AÚN NO FUE COMPENSADO  
      Begin  
         -- Actualizar totales  
         Update #tmpDeuda2  
         Set nTotal       = (nCuota + nReajuste + nDeremi + nIntere + nMora + nMorAcu + nCostas + nGastos),  
             nTotConDscto = (nCuota + nReajuste + nDeremi + nIntere + nMora + nMorAcu + nCostas + nGastos)  
         Where iCorrel = @i  
      End  
     -- Incrementar registro  
     Set @i = @i + 1  
   End  
     
   -- Mostrar Resultados  
   -- No se compensará interés , moras ni mora acumulada  
   Select  
      cConcepto As Concepto                         ,  
      cNumDoc                                       ,  
      iCodPer     ,  
      vReferencia As Referencia              ,  
      cPeriodo                                      ,  
      Convert(Char(10),sdFecVen,103)  As  sdFecVen  ,  
      Convert(Char(10),sdFecVenA,103) As  sdFecVenA ,  
      nTotal = nTotal - (nIntere + nMora)           ,   
      cNumOri                                       ,     
      nTotConDscto = nTotConDscto - (nIntere + nMora),   
      SiPerAfe                                      ,   
      Convert(Char(10),sdFecEmi,103)  As  sdFecEmi  ,       
      nCuota                                        ,    
      nSaldo                                ,  
      cPlaca                                       ,   
      sicodcre                                      ,      
      nImporte                                      ,    
      nInteres  = 0.00                              ,     
      vPersona                                      ,    
      nImpori          ,  
      nDeremi                                       ,   
      nReinci                                       ,     
      nReajuste                                     ,    
      nCostas                                       ,     
      nGastos                                       ,    
      nIntere                                       ,  
      nIntereDif                                    ,   
      nMora     = 0.00                              ,  
      nMorAcu                                       ,   
      nDescue                                       ,     
      SiTipEdo                                      ,      
      siAnoAfe                                      ,  
      Convert(Char(10),sdFecInt,103) As  sdFecInt   ,  
      Convert(Char(10),sdFecEnv,103) As  sdFecEnv   ,  
      cPendiente As Pendiente                       ,  
      iNumAfe                                       ,  
      siCodPag                                      ,  
      cMarca  As Marca                              ,  
      nMorDif                                      ,  
      cLP As LP                                     ,  
      cPJ As PJ                                     ,  
      cSE As SE                                     ,  
      siReclamo As Reclamo                          ,  
      Convert(Char(8),sdFecVen,112) as sdFecVen  
   From #tmpDeuda2  
   Where nTotConDscto > 0  
   Order By (Case   
                When sdFecVenA Is null   
                   Then Convert(smalldatetime,sdFecVen)   
                Else Convert(smalldatetime,sdFecVenA)   
             End),   
      nTotConDscto   
End


