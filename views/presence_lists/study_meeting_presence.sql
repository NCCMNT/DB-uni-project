-- STUDIES ATTENDANCE LIST
create view StudyMeetingPresence as (
select distinct sm.MeetingID, sm.StartDate ,s2.StudentID, u.Firstname, u.Lastname,
       iif(s2.StudentID in (select sa.StudentID from StudyAttandance as sa where sa.StudyMeetingID = sm.MeetingID), 'Present', 'Absent') as Presence
        from StudiesMeetings as sm
        inner join dbo.StudyMeetups S on sm.StudyMeetupID = S.StudyMeetupID
        inner join dbo.StudySemesters SS on S.StudySemesterID = SS.StudySemesterID
        inner join dbo.Students S2 on ss.StudyID = S2.StudyID
        inner join users as u on u.UserID = s2.UserID);