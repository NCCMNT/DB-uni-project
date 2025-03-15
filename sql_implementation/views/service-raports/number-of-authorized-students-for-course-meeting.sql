create view NumberOfUsersAuthorizedForCourseMeeting as
select MeetingID, count(*) as [Users]
from UsersAuthorizedForCourseMeeting
group by MeetingID