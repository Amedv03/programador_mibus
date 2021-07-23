
--select * from Transacciones
--DROP TABLE #cantidadHoraTransaccion

CREATE TABLE #cantidadHoraTransaccion(NumTransaccion INT, FechaTransacccion SMALLDATETIME)

CREATE TABLE #Transaccion(transaccion int)

INSERT INTO #cantidadHoraTransaccion(NumTransaccion,FechaTransacccion)
SELECT NumTransaccion, FechaTransaccion FROM Transacciones

--SELECT * FROM #cantidadHoraTransaccion

DECLARE @count int = (SELECT COUNT(*) FROM #cantidadHoraTransaccion)
DECLARE @DURACION_AUX SMALLDATETIME 
DECLARE @CONTADOR SMALLDATETIME
DECLARE @SUMAHORA SMALLDATETIME
DECLARE @AUXILIAR SMALLDATETIME 
DECLARE @TRANSACCION INT = 0

while @count > 0
begin
	DECLARE @fechaTransaccion smalldatetime = (SELECT TOP 1 FechaTransacccion FROM #cantidadHoraTransaccion ORDER BY NumTransaccion)

	--SET @DURACION_AUX = @fechaTransaccion

	SET @DURACION_AUX = (SELECT  SUM( DATEPART(SECOND, [@fechaTransaccion]) + 
                60 * DATEPART(MINUTE, [@fechaTransaccion]) + 
                3600 * DATEPART(HOUR, [@fechaTransaccion] ) 
        )
    
    FROM #cantidadHoraTransaccion)

	SET @SUMAHORA =  @SUMAHORA + @DURACION_AUX

	SET @AUXILIAR =  (SELECT CAST(DATEADD(SECOND, @DURACION_AUX, 0) AS SMALLDATETIME))

	IF @AUXILIAR > ('01:00:00')
		SET @TRANSACCION = @TRANSACCION + 1  


	DELETE #cantidadHoraTransaccion WHERE FechaTransacccion = @fechaTransaccion
	SELECT @count = (SELECT COUNT(*) FROM #cantidadHoraTransaccion)
end


