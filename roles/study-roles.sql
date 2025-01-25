CREATE ROLE StudyCoordinator;
GRANT EXECUTE ON AddStudy TO StudyCoordinator;
GRANT EXECUTE ON AddFinalExam TO StudyCoordinator;
GRANT EXECUTE ON AddInternship TO StudyCoordinator;
GRANT EXECUTE ON AddInternshipDetail TO StudyCoordinator;
GRANT EXECUTE ON AddStudiesSchedule TO StudyCoordinator;
GRANT EXECUTE ON AddStudyMeetup TO StudyCoordinator;
GRANT EXECUTE ON AddSubject TO StudyCoordinator;
GRANT EXECUTE ON DidStudentPass TO StudyCoordinator;
GRANT EXECUTE ON PassStudentsInternship TO StudyCoordinator;
GRANT SELECT, INSERT, UPDATE, DELETE ON Studies TO StudyCoordinator;
GRANT SELECT, INSERT, UPDATE, DELETE ON Internships TO StudyCoordinator;
GRANT SELECT, INSERT, UPDATE, DELETE ON InternshipDetails TO StudyCoordinator;

CREATE ROLE Lecturer;
GRANT EXECUTE ON AddOnlineStudyMeeting TO Lecturer;
GRANT EXECUTE ON AddStationaryStudyMeeting TO Lecturer;
GRANT EXECUTE ON AddStudyAttendance TO Lecturer;
GRANT SELECT ON NumberOfUsersAuthorizedForStudyMeeting TO Lecturer;
GRANT SELECT ON StudyMeetingPresence TO Lecturer;
GRANT SELECT ON StudyAttendance TO Lecturer;
GRANT SELECT ON StudiesMeetingsOrganization TO Lecturer;
GRANT SELECT ON UsersAuthorizedForStudyMeeting TO Lecturer;
GRANT SELECT, INSERT, UPDATE, DELETE ON OnlineStudy TO Lecturer;
GRANT SELECT, INSERT, UPDATE, DELETE ON StationaryStudy TO Lecturer;
GRANT SELECT, INSERT, UPDATE, DELETE ON StudyAttandance TO Lecturer;

CREATE ROLE Student;
GRANT EXECUTE ON DidStudentPass TO Student;
GRANT SELECT ON FinalExams TO Student;
GRANT SELECT ON StudiesMeetings TO Student;
GRANT SELECT ON OnlineStudy TO Student;
GRANT SELECT ON StationaryStudy TO Student;
GRANT SELECT ON StudyMeetups TO Student;

ALTER ROLE Lecturer ADD MEMBER StudyCoordinator;