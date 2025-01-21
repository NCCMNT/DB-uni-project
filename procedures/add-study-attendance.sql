CREATE PROCEDURE AddStudyAttendance
    @StudyMeetingID int,
    @StudentID int
AS
    BEGIN
        SET NOCOUNT ON

        --handling study meeting id exceptions
        IF @StudyMeetingID IS NULL
            BEGIN
                RAISERROR ('Study meeting ID cannot be null', 16, 1)
                RETURN
            END
        IF @StudyMeetingID NOT IN (SELECT MeetingID FROM StudiesMeetings)
            BEGIN
                RAISERROR ('There is no study meeting with that ID', 16, 1)
                RETURN
            END

        --handling student id exceptions
        IF @StudentID IS NULL
            BEGIN
                RAISERROR ('Student ID cannot be null', 16, 1)
                RETURN
            END
        IF @StudentID NOT IN (SELECT StudentID FROM Students)
            BEGIN
                RAISERROR ('There is no student with that ID', 16, 1)
                RETURN
            END

        --check if this student is on the list of all students that should be on this meeting
        IF @StudentID NOT IN (
            select distinct s2.StudentID from StudiesMeetings as sm
                inner join dbo.StudyMeetups S on sm.StudyMeetupID = S.StudyMeetupID
                inner join dbo.StudySemesters SS on S.StudySemesterID = SS.StudySemesterID
                inner join dbo.Students S2 on ss.StudyID = S2.StudyID
                where sm.MeetingID = @StudyMeetingID)
            BEGIN
                RAISERROR ('This student is not supposed to be on this meeting', 16, 1)
                RETURN
            END

        INSERT INTO StudyAttandance (StudyMeetingID, StudentID)
        VALUES (@StudyMeetingID, @StudentID)
        PRINT 'Student attendance added successfully'

    END