-- COURSE ATTENDANCE LIST
create view CourseMeetingPresence as (
select distinct cm.MeetingID, cm.StartDate, u.Firstname, u.Lastname, u.UserID,
       iif(u.UserID in (select ca.userid from CoursesAttendance as ca where ca.CourseMeetingID = cm.MeetingID), 'Present', 'Absent') as Presence
        from CoursesMeetings as cm
        inner join OrderDetails as od on od.ServiceID = cm.CourseID
        inner join orders as o on o.OrderID = od.OrderID
        inner join users as u on u.UserID = o.UserID
        inner join dbo.ServiceTypes ST on od.ServiceTypeID = ST.ServiceTypeID and st.ServiceTypeName = 'Course');