create view BilocationReport as
with futureWebinarsList as (
    select
        u.UserID as UID,
        w.WebinarID as EventID,
        'Webinar' as EventType,
        w.Date as StartDate,
        dateadd(hour, 2, w.Date) as EndDate -- założenie: webinary trwają po 2h
        from Users as u
        inner join Orders as o on o.UserID = u.UserID
        inner join OrderDetails as od on o.OrderID = od.OrderID
        inner join dbo.ServiceTypes ST on od.ServiceTypeID = ST.ServiceTypeID and ServiceTypeName = 'Webinar'
        inner join webinars as w on w.WebinarID = od.ServiceID
        where w.Date > getdate()),
futureCourseList as (
    select
        u.UserID as UID,
        cm.MeetingID as EventID,
        'Course Meeting' as EventType,
        cm.StartDate as StartDate,
        cm.EndDate as EndDate
        from Users as u
        inner join Orders as o on o.UserID = u.UserID
        inner join OrderDetails as od on o.OrderID = od.OrderID
        inner join dbo.ServiceTypes ST on od.ServiceTypeID = ST.ServiceTypeID and ServiceTypeName = 'Webinar'
        inner join CoursesMeetings as cm on cm.CourseID = od.ServiceID
        where cm.StartDate > getdate()
),
futureStudyList as (
    select
        u.UserID as UID,
        m.MeetingID as EventID,
        'Study Meeting' as EventType,
        m.StartDate as StartDate,
        m.EndDate as EndDate
        from Users as u
        inner join students as s on s.UserID = u.UserID
        inner join StudySemesters as ss on s.StudyID = ss.StudyID
        inner join dbo.StudyMeetups SM on ss.StudySemesterID = SM.StudySemesterID
        inner join dbo.StudiesMeetings M on SM.StudyMeetupID = M.StudyMeetupID
        where m.StartDate > getdate()
),
allFutureEvents as (
    select * from futureWebinarsList
    union
    select * from futureCourseList
    union
    select * from futureStudyList
),
overlappingEvents as (
    select
        e1.UID, u.Firstname, u.Lastname,
        e1.EventID as [1st Event ID],
        e1.EventType as [1st Event Type],
        e2.EventID as [2nd Event ID],
        e2.EventType as [2nd Event Type],
        e1.StartDate as [1st Event Start],
        e1.EndDate as [1st Event End],
        e2.StartDate as [2nd Event Start],
        e2.EndDate as [2nd Event End]
    from allFutureEvents e1
    inner join allFutureEvents e2 on e1.UID = e2.UID
        and e1.EventID < e2.EventID -- unikanie duplikatów i łączenia eventów samych ze sobą
        and e1.StartDate < e2.EndDate
        and e1.EndDate > e2.StartDate -- warunek czasowy kolizji eventów
    inner join Users as u on e1.UID = u.UserID
) select distinct * from overlappingEvents;