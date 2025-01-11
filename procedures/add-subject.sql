CREATE PROCEDURE AddSubject
    @SubjectName varchar(30),
    @Description text
AS
    BEGIN
        SET NOCOUNT ON
        DECLARE @SubjectID int = (SELECT MAX(SubjectID) + 1 FROM Subjects)

        --handling study name exceptions
        IF @SubjectName IS NULL
            BEGIN
                RAISERROR ('Subject name cannot be null', 16, 1)
                RETURN
            END
        IF @SubjectName IN (SELECT SubjectName FROM Subjects)
            BEGIN
                RAISERROR ('There already exists subject with that name', 16, 1)
                RETURN
            END

        --handling description exceptions
        IF @Description IS NULL
            BEGIN
                RAISERROR ('Description cannot be null', 16, 1)
                RETURN
            END

        --adding correct values to the table
        INSERT INTO Subjects (SubjectID, SubjectName, Description)
        VALUES (@SubjectID, @SubjectName, @Description)
        PRINT 'Subject added successfully'
    END

