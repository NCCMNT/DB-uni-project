create view CoursesIncome as
    select
        CourseID,
        CourseName,
        isnull(sum(Amount), 0) as TotalIncome
    from Payments
    inner join OrderDetails
        on Payments.OrderDetailID = OrderDetails.OrderDetailID
    inner join ServiceTypes
        on OrderDetails.ServiceTypeID = ServiceTypes.ServiceTypeID
    right join Courses
        on ServiceID = CourseID and ServiceTypeName = 'Course'
    group by CourseID, CourseName;
