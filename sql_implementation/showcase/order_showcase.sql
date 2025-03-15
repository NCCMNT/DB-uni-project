select * from Orders

select count(*) from Orders;

select * from Courses


select * from UsersAuthorizedForCourseMeeting
where MeetingID = (select top 1 CoursesMeetings.MeetingID
                   from CoursesMeetings
                   where CourseID = 1) and UserID = 1

EXEC CreateOrder 1
select top 1 * from Orders order by OrderID desc

DECLARE @OrderID int = (select max(OrderID) from Orders)
DECLARE @ServiceTypeID int = (select ServiceTypeID from ServiceTypes where ServiceTypeName = 'Course')
EXEC AddOrderDetails @OrderID, @ServiceTypeID, 1

select * from FutureCourses

DECLARE @OrderID int = (select max(OrderID) from Orders)
DECLARE @ServiceTypeID int = (select ServiceTypeID from ServiceTypes where ServiceTypeName = 'Course')
EXEC AddOrderDetails @OrderID, @ServiceTypeID, 1



select top 1 * from OrderDetails order by OrderDetailID desc

select * from UsersAuthorizedForCourseMeeting
where MeetingID = (select top 1 CoursesMeetings.MeetingID
                   from CoursesMeetings
                   where CourseID = 5) and UserID = 1

select TotalPrice from Courses where CourseID = 5

DECLARE @OrderDetailID int = (select max(OrderDetailID) from OrderDetails)
-- EXEC CreatePayment @OrderDetailID, -1

EXEC CreatePayment @OrderDetailID, 40

select top 1 * from Payments order by PaymentID desc

select * from UsersAuthorizedForCourseMeeting
where MeetingID IN (select CoursesMeetings.MeetingID
                   from CoursesMeetings
                   where CourseID = 5)
and UserID = 1

select * from CoursesMeetings where CourseID = 5


