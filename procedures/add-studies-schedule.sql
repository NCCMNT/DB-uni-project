CREATE PROCEDURE AddStudiesSchedule
    @StudySemesterID int,
    @SubjectID int
AS
    BEGIN
        SET NOCOUNT ON

        --handling study semester exceptions
        IF @StudySemesterID IS NULL
            BEGIN
                RAISERROR ('Study schedule ID cannot be null', 16, 1)
            END
        IF @StudySemesterID NOT IN (SELECT StudySemesterID FROM StudySemesters)
            BEGIN
                RAISERROR ('There is no study semester with that ID', 16, 1)
            END

        --handling subject exceptions
        IF @SubjectID IS NULL
            BEGIN
                RAISERROR ('Subject ID cannot be null', 16, 1)
            END
        IF @SubjectID NOT IN (SELECT SubjectID FROM Subjects)
            BEGIN
                RAISERROR ('There is no subject with that ID', 16, 1)
            END

        --adding correct values to the table
        INSERT INTO StudiesSchedule (StudySemesterID, SubjectID)
        VALUES (@StudySemesterID, @SubjectID)
        PRINT 'Studies schedule added successfully'
    END