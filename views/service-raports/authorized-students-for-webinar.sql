create view UsersAuthorizedForWebinar as
select WebinarID, O.UserID
from Payments
         inner join dbo.OrderDetails OD on Payments.OrderDetailID = OD.OrderDetailID
         inner join dbo.Orders O on OD.OrderID = O.OrderID
         inner join dbo.ServiceTypes ST on OD.ServiceTypeID = ST.ServiceTypeID
         left join dbo.Webinars W on W.WebinarID = OD.ServiceID
where ServiceTypeName = 'Webinar'
  and PayDate < W.Date