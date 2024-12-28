-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2024-12-28 15:16:25.125

-- foreign keys
ALTER TABLE Addresses DROP CONSTRAINT Addresses_City;

ALTER TABLE Cities DROP CONSTRAINT City_Country;

ALTER TABLE Classrooms DROP CONSTRAINT Classrooms_Addresses;

ALTER TABLE CoursesMeetings DROP CONSTRAINT Copy_of_CoursesMeetings_Employees;

ALTER TABLE CoursesAttendance DROP CONSTRAINT CoursesAttendance_CoursesMeetings;

ALTER TABLE CoursesAttendance DROP CONSTRAINT CoursesAttendance_Users;

ALTER TABLE CoursesMeetings DROP CONSTRAINT CoursesMeetings_Courses;

ALTER TABLE Courses DROP CONSTRAINT Courses_Employees;

ALTER TABLE Courses DROP CONSTRAINT Courses_Translators;

ALTER TABLE EmployeeRoles DROP CONSTRAINT EmployeeRoles_Employees;

ALTER TABLE EmployeeRoles DROP CONSTRAINT EmployeeRoles_Roles;

ALTER TABLE Employees DROP CONSTRAINT Employees_Addresses;

ALTER TABLE FinalExams DROP CONSTRAINT FinalExams_Grades;

ALTER TABLE FinalExams DROP CONSTRAINT FinalExams_Studies;

ALTER TABLE FinalExams DROP CONSTRAINT FinalExams_Users;

ALTER TABLE HeadTeacherPaymentPostponements DROP CONSTRAINT HeadTeacherPaymentPostponements_Courses;

ALTER TABLE HeadTeacherPaymentPostponements DROP CONSTRAINT HeadTeacherPaymentPostponements_ServiceTypes;

ALTER TABLE HeadTeacherPaymentPostponements DROP CONSTRAINT HeadTeacherPaymentPostponements_Studies;

ALTER TABLE HeadTeacherPaymentPostponements DROP CONSTRAINT HeadTeacherPaymentPostponements_StudyMeetup;

ALTER TABLE HeadTeacherPaymentPostponements DROP CONSTRAINT HeadTeacherPaymentPostponements_Users;

ALTER TABLE HeadTeacherPaymentPostponements DROP CONSTRAINT HeadTeacherPaymentPostponements_Webinars;

ALTER TABLE InternshipDetails DROP CONSTRAINT InternshipDetails_Internships;

ALTER TABLE InternshipDetails DROP CONSTRAINT InternshipDetails_Students;

ALTER TABLE Internships DROP CONSTRAINT Internships_Studies;

ALTER TABLE Translators DROP CONSTRAINT LanguageId;

ALTER TABLE OnlineAsyncCourse DROP CONSTRAINT OnlineAsyncCourse_Copy_of_CoursesMeetings;

ALTER TABLE OnlineStudy DROP CONSTRAINT OnlineStudy_StudiesMeetings;

ALTER TABLE OnlineSyncCourse DROP CONSTRAINT OnlineSyncCourse_Copy_of_CoursesMeetings;

ALTER TABLE OrderDetails DROP CONSTRAINT OrderDetails_Courses;

ALTER TABLE OrderDetails DROP CONSTRAINT OrderDetails_Orders;

ALTER TABLE OrderDetails DROP CONSTRAINT OrderDetails_ServiceTypes;

ALTER TABLE OrderDetails DROP CONSTRAINT OrderDetails_Studies;

ALTER TABLE OrderDetails DROP CONSTRAINT OrderDetails_StudiesMeetings;

ALTER TABLE OrderDetails DROP CONSTRAINT OrderDetails_StudyMeetup;

ALTER TABLE OrderDetails DROP CONSTRAINT OrderDetails_Webinars;

ALTER TABLE Orders DROP CONSTRAINT Orders_Users;

ALTER TABLE Payments DROP CONSTRAINT Payments_OrderDetails;

ALTER TABLE StationaryCourse DROP CONSTRAINT StationaryCourse_Classrooms;

ALTER TABLE StationaryCourse DROP CONSTRAINT StationaryCourse_Copy_of_CoursesMeetings;

ALTER TABLE StationaryStudy DROP CONSTRAINT StationaryStudy_Classrooms;

ALTER TABLE StationaryStudy DROP CONSTRAINT StationaryStudy_StudiesMeetings;

ALTER TABLE Students DROP CONSTRAINT Students_Semesters;

ALTER TABLE Students DROP CONSTRAINT Students_Studies;

ALTER TABLE Students DROP CONSTRAINT Students_Users;

ALTER TABLE StudiesMeetings DROP CONSTRAINT StudiesMeetings_Employees;

ALTER TABLE StudiesMeetings DROP CONSTRAINT StudiesMeetings_StudyMeetup;

ALTER TABLE StudiesMeetings DROP CONSTRAINT StudiesMeetings_Subjects;

ALTER TABLE StudiesMeetings DROP CONSTRAINT StudiesMeetings_Translators;

ALTER TABLE StudiesSchedule DROP CONSTRAINT StudiesSchedule_StudySemesters;

ALTER TABLE StudiesSchedule DROP CONSTRAINT StudiesSchedule_Subjects;

ALTER TABLE Studies DROP CONSTRAINT Studies_Coordinators;

ALTER TABLE StudyAttandance DROP CONSTRAINT StudyAttandance_Students;

ALTER TABLE StudyAttandance DROP CONSTRAINT StudyAttandance_StudiesMeetings;

ALTER TABLE StudyMeetups DROP CONSTRAINT StudyMeetup_StudySemesters;

ALTER TABLE StudySemesters DROP CONSTRAINT StudySemesters_Semesters;

ALTER TABLE StudySemesters DROP CONSTRAINT StudySemesters_Studies;

ALTER TABLE Translators DROP CONSTRAINT TranslatorsLanguages_Employees;

ALTER TABLE Webinars DROP CONSTRAINT Translators_Webinars;

ALTER TABLE Users DROP CONSTRAINT Users_Addresses;

ALTER TABLE WebinarsAttendance DROP CONSTRAINT WebinarsAttendance_Users;

ALTER TABLE WebinarsAttendance DROP CONSTRAINT WebinarsAttendance_Webinars;

ALTER TABLE Webinars DROP CONSTRAINT Webinars_Employees;

-- tables
DROP TABLE Addresses;

DROP TABLE Cities;

DROP TABLE Classrooms;

DROP TABLE Countries;

DROP TABLE Courses;

DROP TABLE CoursesAttendance;

DROP TABLE CoursesMeetings;

DROP TABLE EmployeeRoles;

DROP TABLE Employees;

DROP TABLE FinalExams;

DROP TABLE Grades;

DROP TABLE HeadTeacherPaymentPostponements;

DROP TABLE InternshipDetails;

DROP TABLE Internships;

DROP TABLE Languages;

DROP TABLE OnlineAsyncCourse;

DROP TABLE OnlineStudy;

DROP TABLE OnlineSyncCourse;

DROP TABLE OrderDetails;

DROP TABLE Orders;

DROP TABLE Payments;

DROP TABLE Roles;

DROP TABLE Semesters;

DROP TABLE ServiceTypes;

DROP TABLE StationaryCourse;

DROP TABLE StationaryStudy;

DROP TABLE Students;

DROP TABLE Studies;

DROP TABLE StudiesMeetings;

DROP TABLE StudiesSchedule;

DROP TABLE StudyAttandance;

DROP TABLE StudyMeetups;

DROP TABLE StudySemesters;

DROP TABLE Subjects;

DROP TABLE Translators;

DROP TABLE Users;

DROP TABLE Webinars;

DROP TABLE WebinarsAttendance;

-- End of file.

