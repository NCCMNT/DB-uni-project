create view UsersAuthorizedForStudyMeeting as
select MeetingID, O.UserID
from Payments
         inner join dbo.OrderDetails OD on Payments.OrderDetailID = OD.OrderDetailID
         inner join dbo.Orders O on OD.OrderID = O.OrderID
         inner join dbo.ServiceTypes ST on OD.ServiceTypeID = ST.ServiceTypeID
         left join dbo.StudiesMeetings SM on SM.StudyMeetupID = OD.ServiceID
where ServiceTypeName = 'Studies Meetup'
  and PayDate < SM.StartDate
union
select SM2.MeetingID, UserID
from HeadTeacherPaymentPostponements
         inner join ServiceTypes ST2 on ST2.ServiceTypeName = 'Studies Meetup'
         inner join dbo.StudiesMeetings SM2 on SM2.StudyMeetupID = ServiceID