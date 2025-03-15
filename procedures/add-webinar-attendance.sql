CREATE PROCEDURE AddWebinarAttendance
    @WebinarID int,
    @UserID int
AS
    BEGIN
        SET NOCOUNT ON
        DECLARE @UserSignedForWebinar int = (SELECT COUNT(*) FROM dbo.UsersAuthorizedForWebinar WHERE WebinarID = @WebinarID AND UserID = @UserID)
        IF @UserSignedForWebinar = 0
            BEGIN
                RAISERROR ('User is not authorized for this webinar', 16, 1)
                RETURN
            END
        IF @WebinarID IS NULL OR @UserID IS NULL
            BEGIN
                RAISERROR ('WebinarID and UserID cannot be null', 16, 1)
                RETURN
            END
        IF @WebinarID NOT IN (SELECT WebinarID FROM dbo.Webinars)
            BEGIN
                RAISERROR ('Webinar does not exist', 16, 1)
                RETURN
            END
        IF @UserID NOT IN (SELECT UserID FROM dbo.Users)
            BEGIN
                RAISERROR ('User does not exist', 16, 1)
                RETURN
            END
        IF @UserID IN (SELECT UserID FROM dbo.WebinarsAttendance WHERE WebinarID = @WebinarID)
            BEGIN
                RAISERROR ('User is already on the list', 16, 1)
                RETURN
            END
        INSERT INTO dbo.WebinarsAttendance (WebinarID, UserID)
        VALUES (@WebinarID, @UserID)

        PRINT 'User added to the list successfully'
    END