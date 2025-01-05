create view UsersAuthorizedForCourseMeeting as
select MeetingID, O.UserID
          from Payments
                   inner join dbo.OrderDetails OD on Payments.OrderDetailID = OD.OrderDetailID
                   inner join dbo.Orders O on OD.OrderID = O.OrderID
                   inner join dbo.ServiceTypes ST on OD.ServiceTypeID = ST.ServiceTypeID
                   left join dbo.CoursesMeetings CM on CM.CourseID = OD.ServiceID
          where ServiceTypeName = 'Course'
            and PayDate < CM.StartDate
          union
          select CM2.MeetingID, UserID
          from HeadTeacherPaymentPostponements
                   inner join ServiceTypes ST2 on ST2.ServiceTypeName = 'Course'
                   inner join dbo.CoursesMeetings CM2 on CM2.CourseID = ServiceID