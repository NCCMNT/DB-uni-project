CREATE PROCEDURE AddStudyMeetup
    @StudySemesterID int,
    @StartDate datetime,
    @EndDate datetime,
    @Price money,
    @ExtraPrice money
AS
    BEGIN
        SET NOCOUNT ON

        DECLARE @StudyMeetupID int = (SELECT MAX(StudyMeetupID) + 1 FROM StudyMeetups)

        --handling study semester exceptions
        IF @StudySemesterID IS NULL
            BEGIN
                RAISERROR ('Study schedule ID cannot be null', 16, 1)
                RETURN
            END
        IF @StudySemesterID NOT IN (SELECT StudySemesterID FROM StudySemesters)
            BEGIN
                RAISERROR ('There is no study semester with that ID', 16, 1)
                RETURN
            END

        --handling dates exceptions
        IF @StartDate IS NULL OR @EndDate IS NULL
            BEGIN
                RAISERROR ('Date cannot be null', 16, 1)
                RETURN
            END
        IF @StartDate < GETDATE()
            BEGIN
                RAISERROR ('Cannot add meetup with past datetime', 16, 1)
                RETURN
            END
        IF @EndDate <= @StartDate
            BEGIN
                RAISERROR ('End date must be further in time than start date', 16, 1)
                RETURN
            END

        --handling price exceptions
        IF @Price IS NULL OR @ExtraPrice IS NULL
            BEGIN
                RAISERROR ('Price cannot be null', 16, 1)
                RETURN
            END
        IF @Price <= 0 OR @ExtraPrice <= 0
            BEGIN
                RAISERROR ('Price must be greater than 0', 16, 1)
                RETURN
            END

        --adding correct values to the table
        INSERT INTO StudyMeetups (StudyMeetupID, StudySemesterID, StartDate, EndDate, Price, ExtraPrice)
        VALUES (@StudyMeetupID, @StudySemesterID, @StartDate, @EndDate, @Price,@ExtraPrice)
        PRINT 'Study meetup added successfully'
    END