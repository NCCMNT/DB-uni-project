with users_course_payments as
         (select O.UserID, OD.ServiceID, sum(Amount) paid, max(PayDate) maxPaymentDate
          from Payments
                   inner join dbo.OrderDetails OD
                              on Payments.OrderDetailID = OD.OrderDetailID and ServiceTypeID = 5
                   inner join dbo.Orders O on OD.OrderID = O.OrderID
          group by O.UserID, OD.ServiceID)
select MeetingID, UserID
from users_course_payments U
         inner join dbo.Courses C on U.ServiceID = C.CourseID
         left join dbo.CoursesMeetings CM on C.CourseID = CM.CourseID
where MeetingID is not null
  and DATEDIFF(hour, maxPaymentDate, StartDate) > 72
  and paid >= TotalPrice
union
select CM2.MeetingID, UserID
from HeadTeacherPaymentPostponements H
         inner join dbo.CoursesMeetings CM2 on CM2.CourseID = ServiceID
where H.ServiceTypeID = 5