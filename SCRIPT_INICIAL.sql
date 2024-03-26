CREATE DATABASE BDMG  
GO

USE [BDMG]
GO

CREATE TABLE [dbo].[Tarefas](
	[IdTarefa] [int] IDENTITY(1,1) NOT NULL,
	[Descricao] [varchar](250) NOT NULL,
	[Status] [char](1) NOT NULL,
	[Prioridade] [int] NOT NULL,
	[InseridoEm] [datetime] NULL,
	[DataConclusao] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdTarefa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


