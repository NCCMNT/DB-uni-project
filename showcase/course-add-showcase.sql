select *
from CoursesMeetingsOrganization
order by CourseID desc;

EXEC AddCourse
    @CourseName = 'Example course',
    @FeePrice = 100,
    @TotalPrice = 150,
    @TranslatorLanguageID = NULL,
    @CourseCoordinatorID = 3;

declare @NewCourseID INT = (select max(CourseID) from Courses);

EXEC AddStationaryCourseMeeting
    @CourseID = @NewCourseID,
    @StartDate = '02-03-2025 18:00:00',
    @EndDate = '02-03-2025 19:30:00',
    @CourseInstructorID = 4,
    @LimitOfParticipants = 15,
    @ClassroomID = 1;

EXEC AddOnlineSyncCourseMeeting
    @CourseID = @NewCourseID,
    @StartDate = '02-04-2025 18:00:00',
    @EndDate = '02-04-2025 19:30:00',
    @CourseInstructorID = 4,
    @LimitOfParticipants = 15,
    @MeetingLink = 'http://examplelink.com/courses/link/qwer';


EXEC AddOnlineAsyncCourseMeeting
    @CourseID = @NewCourseID,
    @StartDate = '02-05-2025 18:00:00',
    @EndDate = '02-05-2025 19:30:00',
    @CourseInstructorID = 4,
    @LimitOfParticipants = 15,
    @RecordingLink = 'http://examplelink.com/courses/recording/jkla';

EXEC AddOnlineAsyncCourseMeeting
    @CourseID = @NewCourseID,
    @StartDate = '02-06-2025 18:00:00',
    @EndDate = '02-06-2025 19:30:00',
    @CourseInstructorID = 4,
    @LimitOfParticipants = 15,
    @RecordingLink = 'http://examplelink.com/coruses/recording/asdf';

select
    *
from CoursesMeetingsOrganization
where CourseID = @NewCourseID;

select *
from CoursesTypes
where CourseID = @NewCourseID;
