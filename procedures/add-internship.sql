CREATE PROCEDURE AddInternship
    @StudyID int
AS
    BEGIN
        SET NOCOUNT ON

        --handling study id exceptions
        IF @StudyID IS NULL
            BEGIN
                RAISERROR ('Study ID cannot be null', 16, 1)
                RETURN
            END
        IF @StudyID NOT IN (SELECT StudentID FROM Students)
            BEGIN
                RAISERROR ('There is no study with that ID', 16, 1)
                RETURN
            END

        DECLARE @I int = 1;
        WHILE @I <= 2
            BEGIN
                DECLARE @InternshipID int = (SELECT MAX(InternshipID) + 1 FROM Internships)

                IF EXISTS(SELECT 1 FROM Internships WHERE StudyID = @StudyID AND CycleNo = @I)
                    BEGIN
                        RAISERROR ('There already is internship with that study id and cycle number', 16, 1)
                        RETURN
                    END

                INSERT INTO Internships (InternshipID, StudyID, CycleNo)
                VALUES (@InternshipID, @StudyID, @I)

                SET @I = @I + 1
            END

        PRINT 'Internship added successfully'
    END
