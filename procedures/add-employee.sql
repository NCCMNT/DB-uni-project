CREATE PROCEDURE AddEmployee
    @Firstname VARCHAR(20),
    @Lastname VARCHAR(20),
    @BirthDate DATE,
    @HireDate DATE,
    @CountryName VARCHAR(50),
    @CityName VARCHAR(50),
    @Street VARCHAR(30),
    @ZipCode VARCHAR(20),
    @Phone VARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @EmployeeID INT = (SELECT MAX(EmployeeID) + 1 FROM Employees);

    IF NOT EXISTS(SELECT 1 FROM Countries WHERE CountryName = @CountryName)
    BEGIN
        RAISERROR('Given country does not exists.', 16, 1);
        RETURN;
    END;

    IF EXISTS(SELECT 1 FROM Employees WHERE Phone = @Phone)
    BEGIN
        RAISERROR('Given phone number is not unique.', 16, 1);
        RETURN;
    END;

    IF @BirthDate > @HireDate
    BEGIN
        RAISERROR('Birth date cannot be later than hire date.', 16, 1);
        RETURN;
    END;

    IF @BirthDate < '1900-01-01'
    BEGIN
        RAISERROR('Birth date cannot be earlier than 1900-01-01.', 16, 1);
        RETURN;
    END;

    IF @HireDate > GETDATE()
    BEGIN
        RAISERROR('Hire date cannot be later than current date.', 16, 1);
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

    INSERT INTO Employees (EmployeeID, Firstname, Lastname, BirthDate, HireDate, AddressID, Phone)
    VALUES (@EmployeeID, @Firstname, @Lastname, @BirthDate, @HireDate, @AddressID, @Phone);

    PRINT 'Employee added successfully.';
END;
