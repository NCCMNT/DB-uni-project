CREATE PROCEDURE AddCourseMeetingAttendance
    @CourseMeetingID INT,
    @UserID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS(SELECT 1 FROM CoursesMeetings WHERE MeetingID = @CourseMeetingID)
    BEGIN
        RAISERROR('Given course meeting does not exist.', 16, 1);
        RETURN;
    END;

    IF NOT EXISTS(SELECT 1 FROM Users WHERE UserID = @UserID)
    BEGIN
        RAISERROR('Given user does not exist.', 16, 1);
        RETURN;
    END;

    IF NOT EXISTS(SELECT 1 FROM UsersAuthorizedForCourseMeeting WHERE MeetingID = @CourseMeetingID AND UserID = @UserID)
    BEGIN
        RAISERROR('Given user is not authorized for given course meeting.', 16, 1);
        RETURN;
    END;

    IF EXISTS(SELECT 1 FROM CoursesAttendance WHERE CourseMeetingID = @CourseMeetingID AND UserID = @UserID)
    BEGIN
        RAISERROR ('User is already on the list', 16, 1);
        RETURN;
    END;

    INSERT INTO CoursesAttendance (CourseMeetingID, UserID)
    VALUES (@CourseMeetingID, @UserID);

    PRINT 'User added to the course attendance list';
END;
