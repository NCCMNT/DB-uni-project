-- STUDIES INDEXES
CREATE INDEX StudiesIDX ON Studies (StudyCoordinatorID);
CREATE INDEX StudentsIDX ON Students (UserID, StudyID, SemesterNo);
CREATE INDEX InternshipsIDX ON Internships (StudyID);
CREATE INDEX StudySemestersIDX ON StudySemesters(StudyID, SemesterNo);
CREATE INDEX StationaryStudyIDX ON StationaryStudy(ClassroomID);
CREATE INDEX StudiesMeetingsIDX ON StudiesMeetings(StudyMeetupID, SubjectID, LecturerID, TranslatorLanguageID);
CREATE INDEX StudyMeetupsIDX ON StudyMeetups(StudySemesterID);
CREATE INDEX FinalExamsIDX ON FinalExams(GradeID);