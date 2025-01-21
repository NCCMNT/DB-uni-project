create role RegisteredUser;

grant select on FutureActivitiesReport to RegisteredUser;
grant select on GetUserSchedule to RegisteredUser;
grant execute on GetCourseUserPresencePercentage to RegisteredUser;
