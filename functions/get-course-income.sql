CREATE FUNCTION GetCourseIncome
    (@CourseID int)
RETURNS decimal(10, 2)
BEGIN
    DECLARE @CourseServiceTypeID int  = (SELECT ServiceTypeID FROM ServiceTypes WHERE ServiceTypeName = 'Course')

    IF NOT EXISTS(SELECT 1 FROM Courses WHERE CourseID = @CourseID)
        BEGIN
            RETURN 0.0
        END
    RETURN CONVERT(decimal(10, 2), (
        SELECT sum(Amount)
        FROM Payments
        INNER JOIN dbo.OrderDetails OD on OD.OrderDetailID = Payments.OrderDetailID
        WHERE ServiceTypeID = @CourseServiceTypeID and ServiceID = @CourseID
        ))
end