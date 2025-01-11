CREATE PROCEDURE AddUser
    @Firstname VARCHAR(20),
    @Lastname VARCHAR(20),
    @Email VARCHAR(50),
    @Password VARCHAR(255),
    @Phone VARCHAR(15),
    @AddressID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserID INT = (SELECT MAX(UserID) + 1 FROM Users);

    IF EXISTS(SELECT 1 FROM Users WHERE Email = @Email)
    BEGIN
        RAISERROR('Given email is not unique.', 16, 1);
    END;

    IF EXISTS(SELECT 1 FROM Users WHERE Phone = @Phone)
    BEGIN
        RAISERROR('Given phone number is not unique.', 16, 1);
    END;

    IF NOT EXISTS(SELECT 1 FROM Addresses WHERE AddressID = @AddressID)
    BEGIN
        RAISERROR('Given address does not exist.', 16, 1);
    END;

    INSERT INTO Users (UserID, Firstname, Lastname, Email, Password, Phone, AddressID)
    VALUES (@UserID, @Firstname, @Lastname, @Email, @Password, @Phone, @AddressID);

    PRINT 'User added successfully.';
END;
