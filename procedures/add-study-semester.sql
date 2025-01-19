CREATE PROCEDURE AddStudySemester
    @StudyID int,
    @SemesterNo int
AS
    BEGIN
        SET NOCOUNT ON
        DECLARE @StudySemesterID int = (SELECT MAX(StudySemesterID) + 1 FROM StudySemesters)

        --handling study id exceptions
        IF @StudyID IS NULL
            BEGIN
                RAISERROR ('Study ID cannot be null', 16, 1)
                RETURN
            END
        IF @StudyID NOT IN (SELECT StudyID FROM Studies)
            BEGIN
                RAISERROR ('There is no study with that ID', 16, 1)
                RETURN
            END

        --handling semester no exceptions
        IF @SemesterNo IS NULL
            BEGIN
                RAISERROR ('Semester number cannot be null', 16, 1)
                RETURN
            END
        IF @SemesterNo NOT IN (SELECT SemesterNo FROM Semesters)
            BEGIN
                RAISERROR ('There is no semester with that number', 16, 1)
                RETURN
            END

        IF EXISTS(SELECT 1 FROM StudySemesters WHERE StudyID = @StudyID AND SemesterNo = @SemesterNo)
            BEGIN
                RAISERROR ('There is already study semester with that values', 16, 1)
                RETURN
            END

        --adding correct values to the table
        INSERT INTO StudySemesters (StudySemesterID, StudyID, SemesterNo)
        VALUES (@StudySemesterID, @StudyID, @SemesterNo)
        PRINT 'Study semester added successfully'
    END
go

