CREATE FUNCTION GetLecturerSchedule(@LecturerID int)
RETURNS TABLE
AS
RETURN (
    SELECT s.StudyName, sub.SubjectName, sm.StudyMeetupID, m.MeetingID,
           m.StartDate, m.EndDate, m.LimitOfMeetingParticipants, l.LanguageName,
           e.Firstname + ' ' + e.Lastname AS Translator
        FROM StudiesMeetings AS m
        INNER JOIN Subjects AS sub ON m.SubjectID = sub.SubjectID
        INNER JOIN StudyMeetups AS sm ON m.StudyMeetupID = sm.StudyMeetupID
        INNER JOIN StudySemesters AS sem ON sem.StudySemesterID = sm.StudySemesterID
        INNER JOIN Studies AS s ON sem.StudyID = s.StudyID
        INNER JOIN Translators AS t ON m.TranslatorLanguageID = t.TranslatorLanguageID
        INNER JOIN Languages AS l ON t.LanguageID = l.LanguageID
        INNER JOIN Employees AS e ON t.EmployeeID = e.EmployeeID
        WHERE m.LecturerID = @LecturerID
    )
