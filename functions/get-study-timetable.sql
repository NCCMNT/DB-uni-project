CREATE FUNCTION GetStudyTimetable (@StudyID int)
RETURNS TABLE
AS
RETURN (
    SELECT sem.StudyID, sem.SemesterNo, sm.StudyMeetupID, sm.StartDate AS 'MEETUP START DATE',
           sm.EndDate AS 'MEETUP END DATE', m.MeetingID, m.StartDate AS 'MEETING START DATE',
           m.EndDate AS 'MEETING END DATE', sub.SubjectName, e.Firstname + ' ' + e.Lastname AS LECTURER
        FROM StudySemesters AS sem
        INNER JOIN StudiesSchedule AS ss ON sem.StudySemesterID = ss.StudySemesterID
        INNER JOIN Subjects AS sub ON ss.SubjectID = sub.SubjectID
        INNER JOIN StudyMeetups AS sm ON sem.StudySemesterID = sm.StudySemesterID
        INNER JOIN StudiesMeetings AS m on sm.StudyMeetupID = m.StudyMeetupID and sub.SubjectID = m.SubjectID
        INNER JOIN Employees AS e ON m.LecturerID = e.EmployeeID
        WHERE sem.StudyID = @StudyID
    )

