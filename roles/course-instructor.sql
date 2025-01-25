create role CourseInstructor;

alter role CourseInstructor add member CourseCoordinator;
grant execute on AddCourseMeetingAttendance to CourseInstructor;
grant execute on GetCourseUserPresencePercentage to CourseInstructor;
grant select on CourseMeetingPresence to CourseInstructor;
grant select on CourseMeetingPresence to CourseInstructor;
grant select on CoursesMeetingsOrganization to CourseInstructor;
grant select on CoursesTypes to CourseInstructor;
grant select on UsersAuthorizedForCourseMeeting to CourseInstructor;
grant select on NumberOfUsersAuthorizedForCourseMeeting to CourseInstructor;
grant select on CourseAttendace to CourseInstructor;
grant select, insert, update on CoursesAttendance to CourseInstructor;
