CREATE PROCEDURE AddTranslator
    @EmployeeID INT,
    @LanguageID INT
AS
BEGIN

    SET NOCOUNT ON;

    DECLARE @TranslatorLanguageID INT = (SELECT MAX(TranslatorLanguageID) + 1 FROM Translators);

    IF NOT EXISTS(SELECT 1 from Employees where EmployeeID = @EmployeeID)
    BEGIN
       RAISERROR('Given employee does not exist', 16, 1);
       RETURN;
    END

    IF NOT EXISTS(SELECT 1 from Languages where LanguageID = @LanguageID)
    BEGIN
       RAISERROR('Given language does not exist', 16, 1);
       RETURN;
    END

    IF NOT EXISTS(
        SELECT
            1
        FROM EmployeeRoles
        INNER JOIN Roles
            ON Roles.RoleID = EmployeeRoles.RoleID
        WHERE RoleName = 'Translator' AND EmployeeID = @EmployeeID
    )
    BEGIN
       RAISERROR('Given employee does not have a translator role', 16, 1);
       RETURN;
    END

    IF EXISTS(SELECT 1 from Translators where EmployeeID = @EmployeeID AND LanguageID = @LanguageID)
    BEGIN
       RAISERROR('Given employee is already a translator for given language', 16, 1);
       RETURN;
    END

    INSERT INTO Translators (TranslatorLanguageID, LanguageID, EmployeeID)
    VALUES (@TranslatorLanguageID, @LanguageID, @EmployeeID);

    PRINT 'Translator added correctly';
END;
