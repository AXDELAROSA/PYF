-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			FACTURA_CXP_XML
-- // OPERACION:		LIBERACION / TABLAS
-- ////////////////////////////////////////////////////////////// 
-- // Autor:			AX de la Rosa
-- // Fecha creación:	21/SEP/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FACTURA_CXP_XML]') AND type in (N'U'))
	DROP TABLE [dbo].[FACTURA_CXP_XML]
GO


-- ////////////////////////////////////////////////////////////////
-- //					FACTURA_CXP_XML				 
-- ////////////////////////////////////////////////////////////////


CREATE TABLE [dbo].[FACTURA_CXP_XML] (
	[K_FACTURA_CXP_XML]				[INT] NOT NULL,
	[C_FACTURA_CXP_XML]				[VARCHAR](255) NOT NULL,
	-- ============================
-- ///////////////////////////////////////////////////////////////////
-- <cfdi:Comprobante /////////////////////////////////////////////////
	[XML_Fecha]						[DATETIME]	NULL,
	[XML_Folio]						[VARCHAR] (100) NOT NULL,
	[XML_FormaPago]					[VARCHAR] (100) NOT NULL,
	[XML_LugarExpedicion]			[VARCHAR] (100) NOT NULL,
	[XML_MetodoPago]				[VARCHAR] (100) NOT NULL, 
	[XML_Moneda]					[VARCHAR] (100) NOT NULL,
	[XML_NoCertificado]				[VARCHAR] (100) NOT NULL,
--	[XML_Sello]						[VARCHAR] (100) NOT NULL,
	[XML_Serie]						[VARCHAR] (100) NOT NULL, 
	[XML_SubTotal]					[DECIMAL] (19,4) NOT NULL,
	[XML_TipoCambio]				[VARCHAR] (100) NOT NULL, 
	[XML_TipoDeComprobante]			[VARCHAR] (100) NOT NULL,
	[XML_Total]						[DECIMAL] (19,4) NOT NULL,
	[XML_Version]					[VARCHAR] (100) NOT NULL,
-- ///////////////////////////////////////////////////////////////////
-- <cfdi:Emisor ////////////////////////////////////////////////////
	[K_PROVEEDOR]					[INT],	
	[XML_EMI_Nombre]				[VARCHAR] (100) NOT NULL,
	[XML_EMI_RegimenFiscal]			[VARCHAR] (100) NOT NULL,
	[XML_EMI_Rfc]					[VARCHAR] (100) NOT NULL,	
-- ///////////////////////////////////////////////////////////////////
-- <cfdi:Receptor ////////////////////////////////////////////////////
	[K_RAZON_SOCIAL]				[INT],	
	[XML_REC_Nombre]				[VARCHAR] (100) NOT NULL,
	[XML_REC_Rfc]					[VARCHAR] (100) NOT NULL,
	[XML_REC_UsoCFDI]				[VARCHAR] (100) NOT NULL,	
-- ///////////////////////////////////////////////////////////////////
-- <cfdi:Impuestos		<cfdi:Traslados> /////////////////////////////
 	[XML_TotalImpuestosTrasladados] [DECIMAL] (19,4) NOT NULL,
	[XML_Importe]					[DECIMAL] (19,4) NOT NULL,
	[XML_Impuesto]					[VARCHAR] (100) NOT NULL,
	[XML_TasaOCuota]				[VARCHAR] (100) NOT NULL,
	[XML_TipoFactor]				[VARCHAR] (100) NOT NULL,
-- ///////////////////////////////////////////////////////////////////
-- <tfd:TimbreFiscalDigita ///////////////////////////////////////////
	[XML_FechaTimbrado]				[DATETIME] NOT NULL, 
	[XML_NoCertificadoSAT]			[VARCHAR] (100) NOT NULL, 
	[XML_UUID]						[VARCHAR] (100) NOT NULL, 
-- ///////////////////////////////////////////////////////////////////
	[XML_ARCHIVO]					[NVARCHAR](MAX)		-- ARCHIVO
		
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[FACTURA_CXP_XML]
	ADD CONSTRAINT [PK_FACTURA_CXP_XML]
		PRIMARY KEY CLUSTERED ([K_FACTURA_CXP_XML])
GO

CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_FACTURA_CXP_XML_01_DESCRIPCION] 
	   ON [dbo].[FACTURA_CXP_XML] ( [XML_Serie],[XML_Folio] )
GO

-- //////////////////////////////////////////////////////

/*

-- WIWI/FK // HGF - SE DEJA OPCIONAL PARA PODER TRABAJAR

ALTER TABLE [dbo].[FACTURA_CXP_XML] ADD 
	CONSTRAINT [FK_FACTURA_CXP_XML_01]  
		FOREIGN KEY ([K_FACTURA_CXP]) 
		REFERENCES [dbo].[FACTURA_CXP] ([K_FACTURA_CXP])
GO

*/


-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[FACTURA_CXP_XML] 
	ADD		[K_USUARIO_ALTA]			[INT] NOT NULL,
			[F_ALTA]					[DATETIME] NOT NULL,
			[K_USUARIO_CAMBIO]			[INT] NOT NULL,
			[F_CAMBIO]					[DATETIME] NOT NULL,
			[L_BORRADO]					[INT] NOT NULL,
			[K_USUARIO_BAJA]			[INT] NULL,
			[F_BAJA]					[DATETIME] NULL;
GO



ALTER TABLE [dbo].[FACTURA_CXP_XML] ADD 
	CONSTRAINT [FK_FACTURA_CXP_XML_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_FACTURA_CXP_XML_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_FACTURA_CXP_XML_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO



-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
