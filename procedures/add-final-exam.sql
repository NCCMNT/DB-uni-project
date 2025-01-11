CREATE PROCEDURE AddFinalExam
    @StudyID int,
    @StudentID int,
    @GradeID int
AS
    BEGIN
        SET NOCOUNT ON

        --handling study ID exceptions
        IF @StudyID IS NULL
            BEGIN
                RAISERROR ('Study ID cannot be null', 16, 1);
            END
        IF @StudyID NOT IN (SELECT StudyID FROM Studies)
            BEGIN
                RAISERROR ('There is no study with that ID', 16, 1)
            END

        --handling student ID exceptions
        IF @StudentID IS NULL
            BEGIN
                RAISERROR ('Student ID cannot be null', 16, 1)
            END
        IF @StudentID NOT IN (SELECT StudentID FROM Students)
            BEGIN
                RAISERROR ('There is no student with that ID', 16, 1)
            END
        IF @StudyID != (SELECT StudyID FROM Students WHERE StudentID = @StudentID)
            BEGIN
                RAISERROR ('This student is not on given studies', 16, 1)
            END

        --handling grade ID exceptions
        IF @GradeID IS NULL
            BEGIN
                RAISERROR ('Grade ID cannot be null', 16, 1)
            END
        IF @GradeID NOT IN (SELECT GradeID FROM Grades)
            BEGIN
                RAISERROR ('There is no grade with that ID', 16, 1)
            END

        --adding correct values to the table
        INSERT INTO FinalExams (StudyID, StudentID, GradeID)
        VALUES (@StudyID, @StudentID, @GradeID)
        PRINT 'Final exam added successfully'
    END

