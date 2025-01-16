CREATE PROCEDURE AddUser
    @Firstname VARCHAR(20),
    @Lastname VARCHAR(20),
    @Email VARCHAR(50),
    @Password VARCHAR(255),
    @Phone VARCHAR(15),
    @CountryName VARCHAR(50),
    @CityName VARCHAR(50),
    @Street VARCHAR(30),
    @ZipCode VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserID INT = (SELECT MAX(UserID) + 1 FROM Users);

    IF EXISTS(SELECT 1 FROM Users WHERE Email = @Email)
    BEGIN
        RAISERROR('Given email is not unique.', 16, 1);
        RETURN;
    END;

    IF @Email NOT LIKE '%_@__%.__%'
    BEGIN
        RAISERROR('Given email is not valid.', 16, 1);
        RETURN;
    END;

    IF EXISTS(SELECT 1 FROM Users WHERE Phone = @Phone)
    BEGIN
        RAISERROR('Given phone number is not unique.', 16, 1);
        RETURN;
    END;

    DECLARE @CountryID INT = (SELECT CountryID FROM Countries WHERE CountryName = @CountryName);

    IF NOT EXISTS(
         SELECT 1
         FROM Cities
         INNER JOIN Countries
            ON Cities.CountryID = Countries.CountryID
         WHERE CityName = @CityName AND CountryName = @CountryName
         )
    BEGIN
        EXEC AddCity
            @CityName = @CityName,
            @CountryID = @CountryID;
    END;

    DECLARE @CityID INT = (SELECT CityID FROM Cities WHERE CityName = @CityName);

    IF NOT EXISTS(
        SELECT 1
        FROM Addresses
        WHERE ZipCode = @ZipCode AND CityID = @CityID
    )
    BEGIN
        EXEC AddAddress
            @CityID = @CityID,
            @Street = @Street,
            @ZipCode = @ZipCode
    END;

    DECLARE @AddressID INT = (SELECT AddressID FROM Addresses WHERE ZipCode = @ZipCode AND Street = @Street AND CityID = @CityID);

    INSERT INTO Users (UserID, Firstname, Lastname, Email, Password, Phone, AddressID)
    VALUES (@UserID, @Firstname, @Lastname, @Email, @Password, @Phone, @AddressID);

    PRINT 'User added successfully.';
END;
