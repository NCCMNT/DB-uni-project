CREATE PROCEDURE AddStationaryStudyMeeting
    @StudyMeetupID int,
    @SubjectID int,
    @StartDate datetime,
    @EndDate datetime,
    @LecturerID int,
    @LimitOfMeetingParticipants int,
    @TranslatorLanguageID int,
    @ClassroomID int
AS
    BEGIN
        SET NOCOUNT ON

        DECLARE @MeetingID int = (SELECT MAX(MeetingID) + 1 FROM StudiesMeetings)

        --handling study meetup exceptions
        IF @StudyMeetupID IS NULL
            BEGIN
                RAISERROR ('Study meetup ID cannot be null', 16 ,1)
                RETURN
            END
        IF @StudyMeetupID NOT IN (SELECT StudyMeetupID FROM StudyMeetups)
            BEGIN
                RAISERROR ('There is no study meetup with that ID', 16, 1)
                RETURN
            END

        --handling subjects exceptions
        IF @SubjectID IS NULL
            BEGIN
                RAISERROR ('Subject ID cannot be null', 16 ,1)
                RETURN
            END
        IF @SubjectID NOT IN (SELECT SubjectID FROM Subjects)
            BEGIN
                RAISERROR ('There is no subject with that ID', 16, 1)
                RETURN
            END
        IF @SubjectID NOT IN (
            SELECT DISTINCT sch.SubjectID FROM StudiesSchedule AS sch
                INNER JOIN StudyMeetups AS sm ON sm.StudySemesterID = sch.StudySemesterID
                WHERE sm.StudyMeetupID = @StudyMeetupID)
            BEGIN
                RAISERROR ('This subject is not in the schedule of study and semester on which given meetup is', 16, 1)
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

        --handling lecturer exceptions
        IF @LecturerID IS NULL
            BEGIN
                RAISERROR ('Lecturer ID cannot be null', 16, 1)
            END
        IF @LecturerID NOT IN (
            SELECT e.EmployeeID FROM Employees AS e
                INNER JOIN EmployeeRoles AS er ON e.EmployeeID = er.EmployeeID
                INNER JOIN Roles AS r ON er.RoleID = r.RoleID
                WHERE r.RoleName = 'Lecturer')
            BEGIN
                RAISERROR ('Given employee is not a lecturer', 16, 1)
                RETURN
            END

        --handling limit of participants exceptions
        IF @LimitOfMeetingParticipants IS NULL
            BEGIN
                RAISERROR ('Limit of participants cannot be null', 16, 1)
                RETURN
            END
        IF @LimitOfMeetingParticipants <= 0
            BEGIN
                RAISERROR ('Limit of participants must be greater than 0', 16, 1)
                RETURN
            END
        IF @LimitOfMeetingParticipants <= (
            SELECT s.LimitOfStudents FROM Studies AS s
                INNER JOIN StudySemesters AS ss ON s.StudyID = ss.StudyID
                INNER JOIN StudyMeetups AS sm ON ss.StudySemesterID = sm.StudySemesterID
                WHERE sm.StudyMeetupID = @StudyMeetupID)
            BEGIN
                RAISERROR ('Limit of participants must be at least of value determined by studies on which given meeting is supposed to be', 16 , 1)
                RETURN
            END

        --handling translator language id exceptions
        IF @TranslatorLanguageID NOT IN (SELECT TranslatorLanguageID FROM Translators)
            BEGIN
                RAISERROR ('There is no translator language pair with that ID', 16, 1)
                RETURN
            END

        --handling classroom exceptions
        IF @ClassroomID IS NULL
            BEGIN
                RAISERROR ('Classroom ID cannot be null', 16, 1)
                RETURN
            END
        IF @ClassroomID NOT IN (SELECT ClassroomID FROM Classrooms)
            BEGIN
                RAISERROR ('There is no classroom with that ID', 16, 1)
                RETURN
            END

        --adding correct values to the tables
        INSERT INTO StudiesMeetings (MeetingID, StudyMeetupID, SubjectID, StartDate, EndDate, LecturerID, LimitOfMeetingParticipants, TranslatorLanguageID)
        VALUES (@MeetingID, @StudyMeetupID, @SubjectID, @StartDate, @EndDate, @LecturerID, @LimitOfMeetingParticipants, @TranslatorLanguageID)

        INSERT INTO StationaryStudy (StationaryStudyMeetingID, ClassroomID)
        VALUES (@MeetingID, @ClassroomID)
        PRINT 'Stationary study meeting added successfully'
    END