create view CoursesTypes as
    with CourseMeetingsCategoryCount as (
        select
            Courses.CourseID,
            CourseName,
            count(StationaryCourseMeetingID) as StationaryMeetingsCount,
            count(OnlineSyncCourseMeetingID) as OnlineSyncMeetingsCount,
            count(OnlineAsyncCourseMeetingID) as OnlineAsyncMeetingsCount
        from CoursesMeetings
        left join StationaryCourse
            on StationaryCourseMeetingID = MeetingID
        left join OnlineSyncCourse
            on OnlineSyncCourseMeetingID = MeetingID
        left join OnlineAsyncCourse
            on OnlineAsyncCourseMeetingID = MeetingID
        inner join Courses
            on Courses.CourseID = CoursesMeetings.CourseID
        group by Courses.CourseID, CourseName
    )
    select
        CourseID,
        CourseName,
        case
            when OnlineSyncMeetingsCount + OnlineAsyncMeetingsCount = 0 then 'Stationary'
            when OnlineAsyncMeetingsCount + StationaryMeetingsCount = 0 then 'Online Synchronous'
            when OnlineSyncMeetingsCount + StationaryMeetingsCount = 0 then 'Online Asynchronous'
            else 'Hybrid'
        end as CourseType,
        StationaryMeetingsCount,
        OnlineSyncMeetingsCount,
        OnlineAsyncMeetingsCount
    from CourseMeetingsCategoryCount;
