create view FutureActivitiesReport as
with users_on_activities as (
select
    'Webinar' as [Service Type],
    UW.WebinarID as ServiceID,
    'Remote' as Place,
    UW.Users as [Users signed in],
    Date as [Date of activity]
from NumberOfUsersAuthorizedForWebinar UW
inner join Webinars W on UW.WebinarID = W.WebinarID
union
select
    'Study Meeting',
    US.MeetingID,
    iif(US.MeetingID in (select OnlineStudyMeetingID from OnlineStudy), 'Remote', 'On-site'),
    US.Users,
    SM.StartDate
from NumberOfUsersAuthorizedForStudyMeeting US
inner join StudiesMeetings SM on SM.MeetingID = US.MeetingID
union
select
    'Course Meeting',
    UC.MeetingID,
    iif(UC.MeetingID in (select StationaryCourseMeetingID from StationaryCourse), 'On-site', 'Remote'),
    UC.Users,
    CM.StartDate
from NumberOfUsersAuthorizedForCourseMeeting UC
inner join CoursesMeetings CM on CM.MeetingID = UC.MeetingID
)
select * from users_on_activities UOA
where UOA.[Date of activity] > GETDATE()