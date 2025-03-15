CREATE PROCEDURE AddCity
    @CityName nvarchar(50),
    @CountryID int
AS
    BEGIN
        SET NOCOUNT ON
        DECLARE @CityID int = (SELECT MAX(CityID) + 1 FROM Cities)
        IF @CityName IS NULL
            BEGIN
                RAISERROR ('City Name cannot be null', 16, 1)
                RETURN
            END
        IF @CountryID NOT IN (SELECT CountryID FROM Countries)
            BEGIN
                RAISERROR ('Country does not exist', 16, 1)
                RETURN
            END
        IF @CityName IN (SELECT CityName FROM Cities WHERE CountryID = @CountryID)
            BEGIN
                RAISERROR ('City already exists in this country', 16, 1)
                RETURN
            END

        INSERT INTO Cities (CityID, CityName, CountryID)
        VALUES (@CityID, @CityName, @CountryID)
        PRINT 'City added successfully'
    END