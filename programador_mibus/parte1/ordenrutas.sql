

--TABLAS TEMPORALES FÍSICAS
CREATE TABLE #tabla (ID_RUTA INT, RT_ID varchar(10))--ID_RUTA es una variable solo para ordenar

CREATE TABLE #DATOS (RT_ID varchar(10), SN_B INT, SN_E INT, STOP_CD_B VARCHAR(12),
					STOP_CD_E VARCHAR(12), DIST INT, LMT_SPD_E TINYINT)

--insertamos solo 2 campos a la tabla temporal de la tabla Pattern_detail
INSERT INTO #tabla(ID_RUTA, RT_ID) SELECT ID_RUTA,RT_ID FROM Pattern_detail

--cuento la cantidad de registros en la tabla, lo utlizo para controlar el while
DECLARE @count int  = (select count(*) from #tabla)

--declaracion de variables
DECLARE @STOP_CD_B VARCHAR(12)
DECLARE @STOP_CD_E VARCHAR(12)
DECLARE @SN_B INT, @SN_E INT, @DIST INT
DECLARE @LMT_SPD_E TINYINT
DECLARE @AUX VARCHAR(10)


while @count > 0
BEGIN
	DECLARE @RT_ID VARCHAR(10) = (SELECT TOP 1 RT_ID FROM #tabla ORDER BY ID_RUTA)
	
	SET @AUX = @RT_ID
	
	SET @SN_B = (SELECT min(SN) FROM Pattern_detail WHERE RT_ID = @AUX)
	SET @SN_E = (SELECT max(SN) FROM Pattern_detail WHERE RT_ID = @AUX)
	SET @STOP_CD_B = (SELECT TOP 1 STOP_CD FROM Pattern_detail WHERE RT_ID = @AUX ORDER BY SN)
	SET @STOP_CD_E = (SELECT TOP 1 STOP_CD FROM Pattern_detail WHERE RT_ID = @AUX ORDER BY SN DESC)
	SET @DIST = (SELECT sum(DIST) FROM Pattern_detail WHERE RT_ID = @AUX) 
	SET @LMT_SPD_E = (SELECT TOP 1 LMT_SPD FROM Pattern_detail WHERE RT_ID = @AUX ORDER BY SN DESC)
		
	DELETE #tabla WHERE RT_ID=@RT_ID --borramos el RT_ID actual para continuar con otro en la aproxima iteracion

	SELECT @count = (SELECT COUNT(*) FROM #tabla)--cuento la cantidad actual de registros, debe ser menor 

	
	INSERT INTO #DATOS(RT_ID, SN_B, SN_E,STOP_CD_B, STOP_CD_E, DIST, LMT_SPD_E) --inserto los datos a la tabla temporal datos
	SELECT @RT_ID, @SN_B, @SN_E, @STOP_CD_B, @STOP_CD_E,@DIST, @LMT_SPD_E

END

--SELECT * FROM #DATOS
--SELECT * FROM OrdenRutas

INSERT INTO OrdenRutas (RT_ID, SN_B, SN_E,STOP_CD_B, STOP_CD_E, DIST, LMT_SPD) --paso los datos de la tabla tempral una tabla fisica
SELECT * from #DATOS