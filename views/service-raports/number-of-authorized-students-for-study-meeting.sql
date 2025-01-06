create view NumberOfUsersAuthorizedForStudyMeeting as
select MeetingID, count(*) [Users] from UsersAuthorizedForStudyMeeting
group by MeetingID