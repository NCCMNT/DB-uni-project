CREATE PROCEDURE AddCourse
    @CourseName VARCHAR(40),
    @FeePrice MONEY,
    @TotalPrice MONEY,
    @TranslatorLanguageID INT,
    @CourseCoordinatorID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CourseID INT = (SELECT MAX(CourseID) + 1 FROM Courses);

    IF NOT @FeePrice > 0
    BEGIN
        RAISERROR('Fee price must be greater than 0.', 16, 1);
    END;

    IF NOT @TotalPrice > @FeePrice
    BEGIN
        RAISERROR('Total price must be greater than fee price.', 16, 1);
    END;

    IF @TranslatorLanguageID IS NOT NULL AND NOT EXISTS(SELECT 1 FROM Translators WHERE TranslatorLanguageID = @TranslatorLanguageID)
    BEGIN
        RAISERROR('Given translator language pair does not exist.', 16, 1);
    END;

    IF NOT EXISTS(
        SELECT 1
        FROM EmployeeRoles
        INNER JOIN Roles
            ON Roles.RoleID = EmployeeRoles.RoleID
        WHERE RoleName = 'Course Coordinator' AND EmployeeID = @CourseCoordinatorID
    )
    BEGIN
        RAISERROR('Given course coordinator does not exist.', 16, 1);
    END;

    INSERT INTO Courses (CourseID, CourseName, FeePrice, TotalPrice, TranslatorLanguageID, CourseCoordinatorID)
    VALUES (@CourseID, @CourseName, @FeePrice, @TotalPrice, @TranslatorLanguageID, @CourseCoordinatorID);

    PRINT 'Course added successfully.';
END;
