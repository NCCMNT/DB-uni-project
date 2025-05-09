CREATE PROCEDURE AddWebinar
    @WebinarName varchar(80),
    @RecordingLink varchar(100),
    @Date datetime,
    @Price money,
    @WebinarPresenterID int,
    @TranslatorLanguageID int = null
AS
    BEGIN
        DECLARE @WebinarID int = (select max(WebinarID) + 1 from Webinars)
        SET NOCOUNT ON
        IF @Date < GETDATE()
            BEGIN
                RAISERROR ('Date cannot be in the past', 16, 1)
                RETURN
            END
        IF @WebinarPresenterID NOT IN (SELECT UserID FROM dbo.Users)
            BEGIN
                RAISERROR ('Webinar Presenter does not exist', 16, 1)
                RETURN
            END
        IF @WebinarName IN (SELECT WebinarName FROM dbo.Webinars)
            BEGIN
                RAISERROR ('Webinar already exists', 16, 1)
                RETURN
            END
        IF @TranslatorLanguageID IS NOT NULL AND @TranslatorLanguageID NOT IN (SELECT TranslatorLanguageID FROM Translators)
            BEGIN
                RAISERROR ('Translator does not exist', 16, 1)
                RETURN
            END
        IF @Price < 0 OR @Price IS NULL OR @Price > 999999
            BEGIN
                RAISERROR ('Price must be between 0 and 999999', 16, 1)
                RETURN
            END
        IF @RecordingLink IN (SELECT RecordingLink FROM dbo.Webinars)
            BEGIN
                RAISERROR ('Recording Link already exists.', 16, 1)
                RETURN
            END
        IF NOT (@RecordingLink LIKE 'https://%' OR @RecordingLink LIKE 'http://%')
            BEGIN
                RAISERROR ('Invalid link, must be either http://* or https://*', 16, 1)
                RETURN
            END

        INSERT INTO dbo.Webinars (WebinarID, WebinarName, RecordingLink, Date, Price, WebinarPresenterID, TranslatorLanguageID)
        VALUES (@WebinarID,@WebinarName, @RecordingLink, @Date,@Price,@WebinarPresenterID, @TranslatorLanguageID)
        PRINT 'Webinar added successfully'
    END

