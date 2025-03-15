create role CourseCoordinator;

grant execute on AddCourse to CourseCoordinator;
grant execute on AddStationaryCourseMeeting to CourseCoordinator;
grant execute on AddOnlineSyncCourseMeeting to CourseCoordinator;
grant execute on AddOnlineAsyncCourseMeeting to CourseCoordinator;
grant select, insert, update on Courses to CourseCoordinator;
grant select, insert, update on CoursesMeetings to CourseCoordinator;
grant select, insert, update on StationaryCourse to CourseCoordinator;
grant select, insert, update on OnlineSyncCourse to CourseCoordinator;
grant select, insert, update on OnlineAsyncCourse to CourseCoordinator;
