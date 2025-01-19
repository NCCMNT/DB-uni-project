CREATE PROCEDURE AddStudent
    @UserID int,
    @StudyID int,
    @SemesterNo int
AS
    BEGIN
        SET NOCOUNT ON

        DECLARE @StudentID int = (SELECT max(StudentID) + 1 FROM Students)

        --handling user id exceptions
        IF @UserID IS NULL
            BEGIN
                RAISERROR ('User ID cannot be null', 16, 1)
                RETURN
            END
        IF @UserID NOT IN (SELECT UserID FROM Users)
            BEGIN
                RAISERROR ('There is no user with that ID', 16, 1)
                RETURN
            END

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


        INSERT INTO Students (StudentID, UserID, StudyID, SemesterNo)
        VALUES (@StudentID, @UserID, @StudyID, @SemesterNo)
        PRINT 'Student added successfully'

    END