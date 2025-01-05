-- WEBINAR ATTENDANCE LIST
create view WebinarMeetingPresence as (
select distinct w.webinarID, w.Date, u.Firstname, u.Lastname, u.UserID,
       iif(u.UserID in (select wa.userid from dbo.WebinarsAttendance as wa where wa.WebinarID = w.WebinarID), 'Present', 'Absent') as Presence
        from Webinars as w
        inner join OrderDetails as od on od.ServiceID = w.WebinarID
        inner join orders as o on o.OrderID = od.OrderID
        inner join users as u on u.UserID = o.UserID
        inner join dbo.ServiceTypes ST on od.ServiceTypeID = ST.ServiceTypeID and st.ServiceTypeName = 'Webinar');