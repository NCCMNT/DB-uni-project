create view StudyIncome as
    with StudyFeeIncome as (
        select
            StudyID,
            isnull(sum(Amount), 0) as TotalFeeIncome
        from Payments
        inner join OrderDetails
            on Payments.OrderDetailID = OrderDetails.OrderDetailID
        inner join ServiceTypes
            on OrderDetails.ServiceTypeID = ServiceTypes.ServiceTypeID
        right join Studies
            on ServiceID = StudyID and ServiceTypeName = 'Studies'
        group by StudyID
    ), StudyMeetupsIncome as (
        select
            StudyID,
            isnull(sum(Amount), 0) as TotalMeetupsIncome
        from Payments
        inner join OrderDetails
            on Payments.OrderDetailID = OrderDetails.OrderDetailID
        inner join ServiceTypes
            on OrderDetails.ServiceTypeID = ServiceTypes.ServiceTypeID
        inner join StudyMeetups
            on ServiceID = StudyMeetupID
        right join StudySemesters
            on StudyMeetups.StudySemesterID = StudySemesters.StudySemesterID and ServiceTypeName = 'Studies Meetup'
        group by StudyID
    )
    select
        Studies.StudyID,
        StudyName,
        TotalFeeIncome + TotalMeetupsIncome as TotalIncome
    from StudyFeeIncome
    inner join StudyMeetupsIncome
        on StudyFeeIncome.StudyID = StudyMeetupsIncome.StudyID
    inner join Studies
        on StudyFeeIncome.StudyID = Studies.StudyID and StudyMeetupsIncome.StudyID = Studies.StudyID;
