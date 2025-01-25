-- DROP COURSE INDEXES
DROP INDEX IF EXISTS CoursesIDX ON Courses;
DROP INDEX IF EXISTS CoursesMeetingsIDX ON CoursesMeetings;
DROP INDEX IF EXISTS StationaryCourseIDX ON StationaryCourse;

-- DROP STUDIES INDEXES
DROP INDEX IF EXISTS StudiesIDX ON Studies;
DROP INDEX IF EXISTS StudentsIDX ON Students;
DROP INDEX IF EXISTS InternshipsIDX ON Internships;
DROP INDEX IF EXISTS StudySemestersIDX ON StudySemesters;
DROP INDEX IF EXISTS StationaryStudyIDX ON StationaryStudy;
DROP INDEX IF EXISTS StudiesMeetingsIDX ON StudiesMeetings;
DROP INDEX IF EXISTS StudyMeetupsIDX ON StudyMeetups;
DROP INDEX IF EXISTS FinalExamsIDX ON FinalExams;

-- DROP PEOPLE INDEXES
DROP INDEX IF EXISTS EmployeesIDX ON Employees;
DROP INDEX IF EXISTS TranslatorsIDX ON Translators;
DROP INDEX IF EXISTS UsersIDX ON Users;

-- DROP ORDERS INDEXES
DROP INDEX IF EXISTS OrdersIDX ON Orders;
DROP INDEX IF EXISTS OrderDetailsIDX ON OrderDetails;
DROP INDEX IF EXISTS PaymentsIDX on Payments;
DROP INDEX IF EXISTS HeadTeacherPaymentPostponementsIDX on HeadTeacherPaymentPostponements;

-- DROP WEBINAR INDEXES
DROP INDEX IF EXISTS WebinarAttendanceIDX on WebinarsAttendance;
DROP INDEX IF EXISTS WebinarsIDX on Webinars;

-- DROP MISC INDEXES
DROP INDEX IF EXISTS CitiesIDX on Cities;
DROP INDEX IF EXISTS AddressesIDX on Addresses;
DROP INDEX IF EXISTS ClassroomsIDX on Classrooms;