CREATE PROCEDURE AddStudy
    @StudyName varchar(40),
    @FeePrice money,
    @StudyCoordinator int,
    @LimitOfStudents int
AS
    BEGIN
        SET NOCOUNT ON
        DECLARE @StudyID int = (SELECT MAX(StudyID) + 1 FROM Studies)

        --handling study name exceptions
        IF @StudyName IS NULL
            BEGIN
                RAISERROR ('Study name cannot be null', 16, 1)
                RETURN
            END
        IF @StudyName IN (SELECT StudyName FROM Studies)
            BEGIN
                RAISERROR ('There already exists study with that name', 16, 1)
                RETURN
            END

        --handling fee price exceptions
        IF @FeePrice IS NULL
            BEGIN
                RAISERROR ('Fee price cannot be null', 16, 1)
                RETURN
            END
        IF @FeePrice < 0
            BEGIN
                RAISERROR ('Invalid value: Fee price must be non-negative value', 16, 1)
                RETURN
            END
        IF @FeePrice > 10000
            BEGIN
                RAISERROR ('Invalid value: Fee price cannot exceed 10000', 16, 1)
                RETURN
            END

        --handling study coordinator exceptions
        IF @StudyCoordinator IS NULL
            BEGIN
                RAISERROR ('Study coordinator cannot be null', 16, 1)
                RETURN
            END
        IF @StudyCoordinator NOT IN (
            SELECT e.EmployeeID FROM Employees AS e
                INNER JOIN EmployeeRoles AS er ON e.EmployeeID = er.EmployeeID
                INNER JOIN Roles AS r ON er.RoleID = r.RoleID
                WHERE r.RoleName = 'Study Coordinator')
            BEGIN
                RAISERROR ('Given employee is not study coordinator', 16, 1)
                RETURN
            END

        --handling limit of students exceptions
        IF @LimitOfStudents <= 0
            BEGIN
                RAISERROR ('Invalid value: Limit of students must be greater than 0', 16, 1)
                RETURN
            END

        --adding correct values to the table
        INSERT INTO Studies (StudyID, StudyName, FeePrice, StudyCoordinatorID, LimitOfStudents)
        VALUES (@StudyID, @StudyName, @FeePrice, @StudyCoordinator, @LimitOfStudents)
        PRINT 'Study added successfully'
    END