CREATE FUNCTION GetStudyIncome
    (@StudyID int)
RETURNS decimal(10,2)
AS
    BEGIN
        DECLARE @ServiceTypeID int = (SELECT ServiceTypeID FROM ServiceTypes WHERE ServiceTypeName = 'Studies')
        DECLARE @MeetupServiceID int = (SELECT ServiceTypeID FROM ServiceTypes WHERE ServiceTypeName = 'Studies Meetup')
        IF NOT EXISTS(SELECT 1 FROM Studies WHERE StudyID = @StudyID)
            BEGIN
                RETURN 0.0
            END
        RETURN CONVERT(decimal(10, 2), (SELECT sum(Amount)
                       FROM Payments
                                INNER JOIN dbo.OrderDetails OD on OD.OrderDetailID = Payments.OrderDetailID
                       WHERE ServiceTypeID = @ServiceTypeID and ServiceID = @StudyID
                          OR (ServiceTypeID = @MeetupServiceID
                           AND
                              (ServiceID IN
                               (SELECT StudyMeetupID
                                FROM StudyMeetups
                                WHERE StudySemesterID IN
                                      (SELECT StudySemesterID
                                       FROM StudySemesters
                                       WHERE StudyID = @StudyID))
                                  ))))
    END