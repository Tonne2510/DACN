/*ham de cat string trong attribute exist o product*/
CREATE FUNCTION dbo.SplitString
(
    @String NVARCHAR(MAX),
    @Delimiter CHAR(1)
)
RETURNS @Output TABLE (Item NVARCHAR(MAX))
AS
BEGIN
    DECLARE @Start INT, @End INT
    SET @Start = 1
    SET @End = CHARINDEX(@Delimiter, @String)

    WHILE @Start < LEN(@String) + 1
    BEGIN
        IF @End = 0
            SET @End = LEN(@String) + 1
        
        INSERT INTO @Output(Item)
        SELECT SUBSTRING(@String, @Start, @End - @Start)

        SET @Start = @End + 1
        SET @End = CHARINDEX(@Delimiter, @String, @Start)
    END
    RETURN
END
