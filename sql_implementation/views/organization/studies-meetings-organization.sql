create view StudiesMeetingsOrganization as
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
        Studies.StudyID,
        StudyName,
        SemesterNo,
        SubjectName,
        iif(MeetingLink is not null, 'Online', 'Stationary') as Form,
        iif(MeetingLink is not null, MeetingLink, FullAddress) as Location,
        StudiesMeetings.StudyMeetupID,
        StudyMeetups.StartDate as MeetupStartDate,
        StudyMeetups.EndDate as MeetupEndDate,
        MeetingID,
        StudiesMeetings.StartDate as MeetingStartDate,
        StudiesMeetings.EndDate as MeetingEndDate
    from StudyMeetups
    inner join StudySemesters
        on StudyMeetups.StudySemesterID = StudySemesters.StudySemesterID
    inner join Studies
        on Studies.StudyID = StudySemesters.StudyID
    inner join StudiesMeetings
        on StudyMeetups.StudyMeetupID = StudiesMeetings.StudyMeetupID
    inner join Subjects
        on Subjects.SubjectID = StudiesMeetings.SubjectID
    left join StationaryStudy
        on StationaryStudyMeetingID = MeetingID
    left join OnlineStudy
        on OnlineStudyMeetingID = MeetingID
    left join ClassroomsAddresses
        on StationaryStudy.ClassroomID = ClassroomsAddresses.ClassroomID;
