CREATE PROCEDURE AddEmployeeRoles
    @EmployeeID INT,
    @RoleID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS(SELECT 1 from Employees where EmployeeID = @EmployeeID)
    BEGIN
       RAISERROR('Given employee does not exist', 16, 1);
    END

    IF NOT EXISTS(SELECT 1 from Roles where RoleID = @RoleID)
    BEGIN
       RAISERROR('Given role does not exist', 16, 1);
    END

    IF EXISTS(SELECT 1 from EmployeeRoles where EmployeeID = @EmployeeID AND RoleID = @RoleID)
    BEGIN
       RAISERROR('Given employee already has given a role', 16, 1);
    END

    INSERT INTO EmployeeRoles (EmployeeID, RoleID)
    VALUES (@EmployeeID, @RoleID);

    PRINT 'Employee Role pair added correctly';
END;
