-- version 1
create view WebinarsIncome as
    with WebinarsPayments as (
        select
            ServiceID,
            sum(Amount) as WebinarsIncome
        from Payments
        inner join OrderDetails
            on Payments.OrderDetailID = OrderDetails.OrderDetailID
        inner join ServiceTypes
            on OrderDetails.ServiceTypeID = ServiceTypes.ServiceTypeID
        where ServiceTypeName = 'Webinar'
        group by ServiceID
    )
    select
        WebinarID,
        WebinarName,
        isnull(WebinarsIncome, 0) as TotalIncome
    from WebinarsPayments
    right join Webinars
        on ServiceID = WebinarID;

-- version 2
create view WebinarsIncome as
    select
        WebinarID,
        WebinarName,
        isnull(sum(Amount), 0) as TotalIncome
    from Payments
    inner join OrderDetails
        on Payments.OrderDetailID = OrderDetails.OrderDetailID
    inner join ServiceTypes
        on OrderDetails.ServiceTypeID = ServiceTypes.ServiceTypeID
    right join Webinars
        on ServiceID = WebinarID and ServiceTypeName = 'Webinar'
    group by WebinarID, WebinarName;
