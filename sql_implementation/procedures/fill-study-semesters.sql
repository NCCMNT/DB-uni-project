CREATE PROCEDURE FillStudySemesters
    @StudyID int
AS
    BEGIN
        SET NOCOUNT ON
        DECLARE @I int = 1
        WHILE @I <= 7
            BEGIN
                EXEC AddStudySemester @StudyID, @I
                SET @I = @I + 1
            END
        PRINT 'Study semester added successfully'
    END

