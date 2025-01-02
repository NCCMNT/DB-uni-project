create view CoursesDebtors as
    with UserCoursePayments as (
        select
            UserID,
            ServiceID,
            sum(Amount) as TotalAmountPaid
        from Payments
        right join OrderDetails
            on Payments.OrderDetailID = OrderDetails.OrderDetailID
        inner join ServiceTypes
            on OrderDetails.ServiceTypeID = ServiceTypes.ServiceTypeID and ServiceTypeName = 'Course'
        inner join Orders
            on Orders.OrderID = OrderDetails.OrderID
        group by UserID, ServiceID
    ), UsersThatPaidFullPriceForCourse as (
        select
            UserID,
            CourseID,
            FeePrice,
            TotalPrice,
            TotalAmountPaid
        from UserCoursePayments
        inner join Courses
            on ServiceID = CourseID
        where TotalAmountPaid >= Courses.TotalPrice
    ), CoursesAttendanceWithCourseID as (
        select
            distinct
            UserID,
            MeetingID,
            CourseID
        from CoursesAttendance
        inner join CoursesMeetings
            on CoursesAttendance.CourseMeetingID = CoursesMeetings.MeetingID
    ), Debtors as (
        select
            distinct
            UserID,
            CourseID
        from CoursesAttendanceWithCourseID
        where not exists (
            select 1
            from UsersThatPaidFullPriceForCourse
            where UsersThatPaidFullPriceForCourse.UserID = CoursesAttendanceWithCourseID.UserID
              and UsersThatPaidFullPriceForCourse.CourseID = CoursesAttendanceWithCourseID.CourseID
        )
    )
    select
        Debtors.UserID,
        Firstname,
        Lastname,
        CourseName,
        Email,
        Phone,
        TotalPrice,
        TotalAmountPaid,
        TotalPrice - isnull(TotalAmountPaid, 0) as Debt
    from Debtors
    left join UserCoursePayments
        on Debtors.UserID = UserCoursePayments.UserID and Debtors.CourseID = UserCoursePayments.ServiceID
    inner join Courses
        on Debtors.CourseID = Courses.CourseID
    inner join Users
        on Debtors.UserID = Users.UserID;
