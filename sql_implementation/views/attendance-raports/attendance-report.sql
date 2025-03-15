create view AttendanceReport as
select
    'Webinars' as ServiceType,
    Format(avg(cast(replace(Percentage, '%', '') as decimal(7, 2))) / 100, 'P') as AverageAttendance
from WebinarAttendance

union select 'Study Meetings' as ServiceType,
    Format(avg(cast(replace(Percentage, '%', '') as decimal(7, 2))) / 100, 'P') as AverageAttendance
from StudyAttendance
union select 'Course Meetings' as Servicetype,
    Format(avg(cast(replace(Percentage, '%', '') as decimal(7, 2))) / 100, 'P') as AverageAttendance
from CourseAttendace