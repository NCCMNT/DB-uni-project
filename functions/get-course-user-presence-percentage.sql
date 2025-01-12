CREATE FUNCTION GetCourseUserPresencePercentage(@CourseID INT, @UserID INT)
RETURNS REAL
AS
BEGIN
    IF NOT EXISTS(
        SELECT 1
        FROM CourseMeetingPresence
        INNER JOIN CoursesMeetings
            ON CoursesMeetings.MeetingID = CourseMeetingPresence.MeetingID
        WHERE CourseID = @CourseID AND UserID = @UserID
    )
    BEGIN
        RETURN 0.0;
    END;

    DECLARE @PresenceCount INT, @MeetingsCount INT;

    SELECT
        @PresenceCount = COUNT(*)
    FROM CourseMeetingPresence
    INNER JOIN CoursesMeetings
        ON CoursesMeetings.MeetingID = CourseMeetingPresence.MeetingID
    WHERE CourseID = @CourseID AND UserID = @UserID AND Presence = 'Present';

    SELECT
        @MeetingsCount = COUNT(*)
    FROM CourseMeetingPresence
    INNER JOIN CoursesMeetings
        ON CoursesMeetings.MeetingID = CourseMeetingPresence.MeetingID
    WHERE CourseID = @CourseID AND UserID = @UserID;

    RETURN CAST(@PresenceCount AS REAL) * 100 / @MeetingsCount;
END;
GO
