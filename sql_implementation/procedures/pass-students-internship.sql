CREATE PROCEDURE PassStudentsInternship
    @StudentID int,
    @InternshipID int
AS
    BEGIN
        SET NOCOUNT ON

        --handling student ID exceptions
        IF @StudentID IS NULL
            BEGIN
                RAISERROR ('Student ID cannot be null', 16, 1)
                RETURN
            END
        IF @StudentID NOT IN (SELECT StudentID FROM Students)
            BEGIN
                RAISERROR ('There is no student with that ID', 16, 1)
                RETURN
            END

        --handling internship ID exceptions
        IF @InternshipID IS NULL
            BEGIN
                RAISERROR ('Internship ID cannot be null', 16, 1)
                RETURN
            END
        IF @InternshipID NOT IN (SELECT InternshipID FROM Internships)
            BEGIN
                RAISERROR ('There is no internship with that ID', 16, 1)
                RETURN
            END

        --checking if student-internship pair exists in internship details
        IF NOT EXISTS (SELECT 1
                   FROM InternshipDetails
                   WHERE StudentID = @StudentID AND InternshipID = @InternshipID)
            BEGIN
                RAISERROR ('There is no record of this student being on this internship', 16, 1)
                RETURN
            END

        --passing students internship
        UPDATE InternshipDetails
        SET PASS = 1
        WHERE StudentID = @StudentID AND InternshipID = @InternshipID

        PRINT 'Updated record successfully'

    END