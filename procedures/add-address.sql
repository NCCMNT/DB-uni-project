CREATE PROCEDURE AddAddress
    @CityID int,
    @Street nvarchar(30),
    @ZipCode nvarchar(20)
AS
    BEGIN
        SET NOCOUNT ON
        DECLARE @AddressID int = (SELECT MAX(AddressID) + 1 FROM Addresses)
        IF @CityID NOT IN (SELECT CityID FROM Cities)
            BEGIN
                RAISERROR ('City does not exist', 16, 1)
                RETURN
            END
        IF @Street IS NULL
            BEGIN
                RAISERROR ('Street cannot be null', 16, 1)
                RETURN
            END
        IF @ZipCode IS NULL
            BEGIN
                RAISERROR ('Zip Code cannot be null', 16, 1)
                RETURN
            END
        IF @ZipCode IN (SELECT ZipCode FROM Addresses WHERE CityID = @CityID)
            BEGIN
                RAISERROR ('Address already exists in this city', 16, 1)
                RETURN
            END

        INSERT INTO Addresses (AddressID, CityID, Street, ZipCode)
        VALUES (@AddressID, @CityID, @Street, @ZipCode)
        PRINT 'Address added successfully'
    END