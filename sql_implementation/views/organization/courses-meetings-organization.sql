create view CoursesMeetingsOrganization as
    with ClassroomsAddresses as (
        select
            ClassroomID,
            CountryName + ', ' +
            CityName + ', ' +
            Street + ' ' +
            ZipCode + ', ' +
            'classroom no. ' + cast(RoomNo as VARCHAR) as FullAddress
        from Classrooms
        inner join Addresses
            on Classrooms.AddressID = Addresses.AddressID
        inner join Cities on
            Cities.CityID = Addresses.CityID
        inner join Countries
            on Cities.CountryID = Countries.CountryID
    )
    select
        Courses.CourseID,
        Courses.CourseName,
        case
            when FullAddress is not null then 'Stationary'
            when MeetingLink is not null then 'Online Synchronous'
            when RecordingLink is not null then 'Online Asynchronous'
        end as Form,
        coalesce(FullAddress, MeetingLink, RecordingLink) as Location,
        MeetingID,
        CoursesMeetings.StartDate as MeetingStartDate,
        CoursesMeetings.EndDate as MeetingEndDate
    from CoursesMeetings
    left join StationaryCourse
        on StationaryCourseMeetingID = MeetingID
    left join OnlineSyncCourse
        on OnlineSyncCourseMeetingID = MeetingID
    left join OnlineAsyncCourse
        on OnlineAsyncCourseMeetingID = MeetingID
    inner join Courses
        on Courses.CourseID = CoursesMeetings.CourseID
    inner join CoursesTypes
        on Courses.CourseID = CoursesTypes.CourseID
    left join ClassroomsAddresses
        on StationaryCourse.ClassroomID = ClassroomsAddresses.ClassroomID;
