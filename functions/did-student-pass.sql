CREATE FUNCTION DidStudentPass (@StudentID int)
RETURNS BIT
AS
    BEGIN
        DECLARE @AllStudentMeetings int = (SELECT COUNT(*) FROM StudyMeetingPresence WHERE StudentID = @StudentID)
        DECLARE @MeetingWhereStudentWasPresent int = (SELECT COUNT(*) FROM StudyMeetingPresence
                                                        WHERE StudentID = @StudentID AND Presence = 'Present')
        DECLARE @NumberOfPassedInternships int = (SELECT COUNT(*) FROM InternshipDetails
                                                        WHERE StudentID = @StudentID AND Pass = 1)
        DECLARE @PassedThreshold decimal = (100 * @MeetingWhereStudentWasPresent) / CAST(@AllStudentMeetings AS DECIMAL)

        IF @PassedThreshold >= CAST(80 AS DECIMAL) AND @NumberOfPassedInternships = 2
            BEGIN
                RETURN 1
            END
        RETURN 0
    END

