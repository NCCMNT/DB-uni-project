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
            cawcid.UserID,
            CourseID,
            DueDate as HeadTeacherPostponementDueDate
        from CoursesAttendanceWithCourseID as cawcid
        inner join HeadTeacherPaymentPostponements
            on cawcid.CourseID = HeadTeacherPaymentPostponements.ServiceID
                   and cawcid.UserID = HeadTeacherPaymentPostponements.UserID
        inner join ServiceTypes
        on ServiceTypes.ServiceTypeID = HeadTeacherPaymentPostponements.ServiceTypeID
                and ServiceTypeName = 'Course'
        where not exists (
            select 1
            from UsersThatPaidFullPriceForCourse
            where UsersThatPaidFullPriceForCourse.UserID = cawcid.UserID
              and UsersThatPaidFullPriceForCourse.CourseID = cawcid.CourseID
        )
            and getdate() > DueDate
    )
    select
        Debtors.UserID,
        Firstname,
        Lastname,
        Courses.CourseID,
        CourseName,
        Email,
        Phone,
        TotalPrice,
        TotalAmountPaid,
        TotalPrice - isnull(TotalAmountPaid, 0) as Debt,
        HeadTeacherPostponementDueDate
    from Debtors
    left join UserCoursePayments
        on Debtors.UserID = UserCoursePayments.UserID and Debtors.CourseID = UserCoursePayments.ServiceID
    inner join Courses
        on Debtors.CourseID = Courses.CourseID
    inner join Users
        on Debtors.UserID = Users.UserID;
