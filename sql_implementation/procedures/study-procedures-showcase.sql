-- STUDY PROCEDURES SHOWCASE --

-- ADD STUDIES
-- list of IDs of Study Coordinators
SELECT e.EmployeeID FROM Employees AS e
    INNER JOIN EmployeeRoles AS er ON e.EmployeeID = er.EmployeeID
    INNER JOIN Roles AS r ON er.RoleID = r.RoleID
    WHERE r.RoleName = 'Study Coordinator'

EXEC AddStudy
    @StudyName = 'Law', --'Forensics',
    @FeePrice = 500.0,
    @StudyCoordinator = 13,
    @LimitOfStudents = 50;

SELECT StudyID FROM Studies WHERE StudyName = 'Law' -- 'Forensics'

-- ADD STUDY SEMESTERS
-- fill study semesters
EXEC FillStudySemesters
--     @StudyID = --86;

-- ADD SUBJECTS
EXEC AddSubject
    @SubjectName = 'Basics of law',
    @Description = 'Students learn basic knowledge about law'

-- ADD STUDIES SCHEDULE
-- SELECT StudySemesterID FROM StudySemesters WHERE StudyID = 86
SELECT SubjectID FROM Subjects WHERE SubjectName = 'Basics of law'
-- EXEC AddStudiesSchedule
--     @StudySemesterID = --602,
--     @SubjectID = --327

-- ADD STUDY MEETUP
EXEC AddStudyMeetup 
--     @StudySemesterID = --596,
--     @StartDate = '2025-01-30 11:30:00.000',
--     @EndDate = '2025-01-30 16:30:00.000',
--     @Price = 150.00,
--     @ExtraPrice = 50.00

-- ADD STUDY MEETING
SELECT StudyMeetupID FROM StudyMeetups WHERE StudySemesterID = 596
SELECT e.EmployeeID FROM Employees AS e
    INNER JOIN EmployeeRoles AS er ON e.EmployeeID = er.EmployeeID
    INNER JOIN Roles AS r ON er.RoleID = r.RoleID
    WHERE r.RoleName = 'Lecturer'
SELECT TranslatorLanguageID FROM Translators
EXEC AddStationaryStudyMeeting
--     @StudyMeetupID = --5951,
--     @SubjectID = --327,
--     @StartDate = '2025-01-30 11:30:00.000',
--     @EndDate = '2025-01-30 12:30:00.000',
--     @LecturerID = 7,
--     @LimitOfMeetingParticipants = 80,
--     @TranslatorLanguageID = 1,
--     @ClassroomID = 1

EXEC AddOnlineStudyMeeting
--     @StudyMeetupID = --5951,
--     @SubjectID = --327,
--     @StartDate = '2025-01-30 12:30:00.000',
--     @EndDate = '2025-01-30 13:30:00.000',
--     @LecturerID = 12,
--     @LimitOfMeetingParticipants = 80,
--     @TranslatorLanguageID = NULL,
--     @MeetingLink = 'https://skibidischool.pl/online-study/aaaaaareyrey'

-- ADD STUDENT
-- SELECT * FROM Students WHERE UserID = 2
-- SELECT * FROM Studies WHERE StudyID = 52
EXEC AddStudent
--     @UserID = --1,
--     @StudyID = --52,
--     @SemesterNo = 1;

-- SELECT StudentID FROM Students WHERE UserID = 1 AND StudyID = 52

-- ADD FINAL EXAM
EXEC AddFinalExam
--     @StudyID = --52,
--     @StudentID = --3859,
--     @GradeID = 5

-- ADD INTERNSHIPS
EXEC AddInternship
--     @StudyID = --86;

-- SELECT InternshipID FROM Internships WHERE StudyID = 86
SELECT CompanyName FROM InternshipDetails

EXEC AddInternshipDetail
--     @InternshipID = --171,
--     @StudentID = --3859,
--     @CompanyName = 'Law & Order',
--     @Pass = 0

EXEC AddInternshipDetail
--     @InternshipID = --172,
--     @StudentID = --3859,
--     @CompanyName = 'Law & Order',
--     @Pass = 0
