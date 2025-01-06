create view CourseAttendance as
with users_on_course_meeting as
         (select CA.CourseMeetingID, count(*) [Users]
          from CoursesAttendance CA
          group by CA.CourseMeetingID)
select NUM.MeetingID                                             as  'CourseMeetingID',
       cast(UOM.Users as varchar) + '/' + cast(NUM.Users as varchar) [Users on course meeting],
       FORMAT(UOM.Users / cast(NUM.Users as decimal(7, 2)), 'P') as  [Percentage]
from NumberOfUsersAuthorizedForCourseMeeting NUM
         inner join users_on_course_meeting UOM on UOM.CourseMeetingID = NUM.MeetingID
         inner join CoursesMeetings CM on CM.MeetingID = NUM.MeetingID
where StartDate < GETDATE()
