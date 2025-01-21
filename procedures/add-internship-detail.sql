CREATE PROCEDURE AddInternshipDetail
    @InternshipID int,
    @StudentID int,
    @CompanyName varchar(20),
    @Pass bit
AS
    BEGIN
        SET NOCOUNT ON

        --handling internship id exceptions
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

        --handling student id exceptions
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
        IF (SELECT COUNT(*) FROM InternshipDetails WHERE StudentID = @StudentID) = 2
            BEGIN
                RAISERROR ('This student is already registered for both internships', 16, 1)
                RETURN
            END
        IF (SELECT COUNT(*) FROM InternshipDetails WHERE StudentID = @StudentID) =  1 AND
           @InternshipID IN (SELECT InternshipID FROM InternshipDetails WHERE StudentID = @StudentID)
            BEGIN
                RAISERROR ('This student is already registered for internship with that ID', 16, 1)
                RETURN
            END

        --handling company name exceptions
        IF @CompanyName IS NULL
            BEGIN
                RAISERROR ('Company name cannot be null', 16, 1)
                RETURN
            END
        IF @StudentID NOT IN (SELECT StudentID FROM Students)
            BEGIN
                RAISERROR ('There is no student with that ID', 16, 1)
                RETURN
            END


        INSERT INTO InternshipDetails (InternshipID, StudentID, CompanyName, Pass)
        VALUES (@InternshipID, @StudentID, @CompanyName, @Pass)
        PRINT 'Internship detail added successfully'

    END