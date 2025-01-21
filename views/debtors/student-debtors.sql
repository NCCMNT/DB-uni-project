create view StudentDebtors as
    with UserMeetupPayments as (
        select
            UserID,
            ServiceID as StudyMeetupID,
            sum(Amount) as TotalAmountPaid
        from Payments
        right join OrderDetails
            on Payments.OrderDetailID = OrderDetails.OrderDetailID
        inner join ServiceTypes
            on OrderDetails.ServiceTypeID = ServiceTypes.ServiceTypeID and ServiceTypeName = 'Studies Meetup'
        inner join Orders
            on Orders.OrderID = OrderDetails.OrderID
        group by UserID, ServiceID
    ), UsersThatPaidFullPriceForMeetup as (
        select
            UserID,
            StudyMeetups.StudyMeetupID,
            Price,
            TotalAmountPaid,
            StudyID
        from UserMeetupPayments
        inner join StudyMeetups
            on UserMeetupPayments.StudyMeetupID = StudyMeetups.StudyMeetupID
        inner join StudySemesters
            on StudyMeetups.StudySemesterID = StudySemesters.StudySemesterID
        where UserMeetupPayments.TotalAmountPaid >= StudyMeetups.Price
            and exists (
                select
                    distinct
                    Orders.OrderID
                from OrderDetails
                inner join Orders
                    on Orders.OrderID = OrderDetails.OrderID
                inner join ServiceTypes
                    on OrderDetails.ServiceTypeID = ServiceTypes.ServiceTypeID and ServiceTypeName = 'Studies Meetup'
                where Orders.UserID = UserMeetupPayments.UserID
                    and OrderDetails.ServiceID = UserMeetupPayments.StudyMeetupID
                intersect
                select
                    distinct
                    Orders.OrderID
                from OrderDetails
                inner join Orders
                    on Orders.OrderID = OrderDetails.OrderID
                inner join ServiceTypes
                    on OrderDetails.ServiceTypeID = ServiceTypes.ServiceTypeID and ServiceTypeName = 'Studies'
                where Orders.UserID = UserMeetupPayments.UserID
                    and OrderDetails.ServiceID = StudySemesters.StudyID
            )
    ), StudiesMeetingsAttendanceWithMeetupsID as (
        select
            distinct
            UserID,
            StudyMeetups.StudyMeetupID
        from StudyAttandance
        inner join StudiesMeetings
            on StudyAttandance.StudyMeetingID = StudiesMeetings.MeetingID
        inner join StudyMeetups
            on StudyMeetups.StudyMeetupID = StudiesMeetings.StudyMeetupID
        inner join Students
            on Students.StudentID = StudyAttandance.StudentID
    ), Debtors as (
        select
            distinct
            StudiesMeetingsAttendanceWithMeetupsID.UserID,
            StudyMeetupID,
            DueDate as HeadTeacherPostponementDueDate
        from StudiesMeetingsAttendanceWithMeetupsID
        inner join HeadTeacherPaymentPostponements
            on HeadTeacherPaymentPostponements.UserID = StudiesMeetingsAttendanceWithMeetupsID.UserID
                and HeadTeacherPaymentPostponements.ServiceID = StudiesMeetingsAttendanceWithMeetupsID.StudyMeetupID
        inner join ServiceTypes
            on ServiceTypes.ServiceTypeID = HeadTeacherPaymentPostponements.ServiceTypeID
                and ServiceTypeName = 'Studies Meetup'
        where not exists (
            select 1
            from UsersThatPaidFullPriceForMeetup
            where UsersThatPaidFullPriceForMeetup.UserID = StudiesMeetingsAttendanceWithMeetupsID.UserID
              and UsersThatPaidFullPriceForMeetup.StudyMeetupID = StudiesMeetingsAttendanceWithMeetupsID.StudyMeetupID
        )
        and DueDate < getdate()
    )
    select
        Debtors.UserID,
        Debtors.StudyMeetupID,
        Firstname,
        Lastname,
        Email,
        Phone,
        Price,
        TotalAmountPaid,
        StudyMeetups.Price - isnull(TotalAmountPaid, 0) as Debt
        , HeadTeacherPostponementDueDate
    from Debtors
    left join UserMeetupPayments
        on Debtors.UserID = UserMeetupPayments.UserID and Debtors.StudyMeetupID = UserMeetupPayments.StudyMeetupID
    inner join StudyMeetups
        on Debtors.StudyMeetupID = StudyMeetups.StudyMeetupID
    inner join Users
        on Debtors.UserID = Users.UserID;
