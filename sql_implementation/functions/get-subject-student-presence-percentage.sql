CREATE FUNCTION GetSubjectStudentPresencePercentage(@SubjectID INT, @StudentID INT)
RETURNS REAL
AS
BEGIN
    IF NOT EXISTS(
        SELECT 1
        FROM StudyMeetingPresence
        INNER JOIN StudiesMeetings
            ON StudiesMeetings.MeetingID = StudyMeetingPresence.MeetingID
        WHERE SubjectID = @SubjectID AND StudentID = @StudentID
    )
    BEGIN
        RETURN 0.0;
    END;

    DECLARE @PresenceCount INT, @MeetingsCount INT;

    SELECT
        @PresenceCount = COUNT(*)
    FROM StudyMeetingPresence
    INNER JOIN StudiesMeetings
        ON StudiesMeetings.MeetingID = StudyMeetingPresence.MeetingID
    WHERE SubjectID = @SubjectID AND StudentID = @StudentID AND Presence = 'Present';

    SELECT
        @MeetingsCount = COUNT(*)
    FROM StudyMeetingPresence
    INNER JOIN StudiesMeetings
        ON StudiesMeetings.MeetingID = StudyMeetingPresence.MeetingID
    WHERE SubjectID = @SubjectID AND StudentID = @StudentID

    RETURN CAST(@PresenceCount AS REAL) * 100 / @MeetingsCount;
END;
