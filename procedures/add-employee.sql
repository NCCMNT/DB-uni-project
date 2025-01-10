CREATE PROCEDURE AddEmployee
    @Firstname VARCHAR(20),
    @Lastname VARCHAR(20),
    @BirthDate DATE,
    @HireDate DATE,
    @AddressID INT,
    @Phone VARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @EmployeeID INT = (SELECT MAX(EmployeeID) + 1 FROM Employees);

    IF NOT EXISTS(SELECT 1 FROM Addresses WHERE AddressID = @AddressID)
    BEGIN
        RAISERROR('Given address does not exists.', 16, 1);
    END;

    IF EXISTS(SELECT 1 FROM Employees WHERE Phone = @Phone)
    BEGIN
        RAISERROR('Given phone number is not unique.', 16, 1);
    END;

    IF @BirthDate > @HireDate
    BEGIN
        RAISERROR('Birth date cannot be later than hire date.', 16, 1);
    END;

    IF @BirthDate < '1900-01-01'
    BEGIN
        RAISERROR('Birth date cannot be earlier than 1900-01-01.', 16, 1);
    END;

    IF @HireDate > GETDATE()
    BEGIN
        RAISERROR('Hire date cannot be later than current date.', 16, 1);
    END;

    INSERT INTO Employees (EmployeeID, Firstname, Lastname, BirthDate, HireDate, AddressID, Phone)
    VALUES (@EmployeeID, @Firstname, @Lastname, @BirthDate, @HireDate, @AddressID, @Phone);

    PRINT 'Employee added successfully.';
END;
