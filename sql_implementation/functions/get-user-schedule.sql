CREATE FUNCTION GetUserSchedule(@UserID INT)
RETURNS TABLE
AS
RETURN (
    SELECT
        'Course Meeting' AS ServiceTypeName,
        CourseID AS ServiceID,
        CourseName AS ServiceName,
        CoursesMeetingsOrganization.MeetingID,
        Location,
        MeetingStartDate,
        MeetingEndDate
    FROM CoursesMeetingsOrganization
    INNER JOIN UsersAuthorizedForCourseMeeting
        ON CoursesMeetingsOrganization.MeetingID = UsersAuthorizedForCourseMeeting.MeetingID
    WHERE UserID = @UserID AND MeetingStartDate > GETDATE()
    UNION
    SELECT
        'Study Meeting' AS ServiceTypeName,
        StudyID AS ServiceID,
        SubjectName + ' (study: ' + StudyName + ')' AS ServiceName,
        StudiesMeetingsOrganization.MeetingID,
        Location,
        MeetingStartDate,
        MeetingEndDate
    FROM StudiesMeetingsOrganization
    INNER JOIN UsersAuthorizedForStudyMeeting
        ON StudiesMeetingsOrganization.MeetingID = UsersAuthorizedForStudyMeeting.MeetingID
    WHERE UserID = @UserID AND MeetingStartDate > GETDATE()
    UNION
    SELECT
        'Webinar' AS ServiceTypeName,
        Webinars.WebinarID AS ServiceID,
        WebinarName AS ServiceName,
        Webinars.WebinarID AS MeetingID,
        RecordingLink AS Location,
        Date AS MeetingStartDate,
        DATEADD(HOUR, 2, Date) AS MeetingEndDate
    FROM Webinars
    INNER JOIN UsersAuthorizedForWebinar
        ON Webinars.WebinarID = UsersAuthorizedForWebinar.WebinarID
    WHERE UserID = @UserID AND Date > GETDATE()
);
