create view StudyAttendance as
with users_on_meeting as
         (select SA.StudyMeetingID, count(*) as [User on meeting]
          from StudyAttandance SA
          group by SA.StudyMeetingID)
select NU.MeetingID,
       cast([User on meeting] as varchar) + '/' + cast(NU.Users as varchar) as [Users Present],
       FORMAT((select count(*)
               from StudyAttandance SA
               where SA.StudyMeetingID = NU.MeetingID)/ convert(decimal(7, 2), NU.Users), 'P') as [Percentege]
from NumberOfUsersAuthorizedForStudyMeeting NU
         inner join users_on_meeting UOM on UOM.StudyMeetingID = NU.MeetingID
         inner join StudiesMeetings SM on NU.MeetingID = SM.MeetingID
where StartDate < GETDATE()