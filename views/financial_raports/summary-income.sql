create view SummaryIncome as
    select
        'Course' as ServiceType,
        CourseID as ServiceID,
        CourseName as ServiceName,
        TotalIncome
    from CoursesIncome
    union
    select
        'Study' as ServiceType,
        StudyID as ServiceID,
        StudyName as ServiceName,
        TotalIncome
    from StudyIncome
    union
    select
        'Webinar' as ServiceType,
        WebinarID as ServiceID,
        WebinarName as ServiceName,
        TotalIncome
    from WebinarsIncome;
