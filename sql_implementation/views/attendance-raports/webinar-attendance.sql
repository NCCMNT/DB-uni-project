create view WebinarAttendance as
with users_on_webinar
         as(select WebinarID, count(*) [Users]
            from WebinarsAttendance
            group by WebinarID)
select
    NU.WebinarID,
    WebinarName,
    cast(UW.Users as varchar) + '/' + cast(NU.Users as varchar) as [Users on webinar],
    FORMAT(UW.Users/convert(decimal(7,2),NU.Users), 'P') as Percentage
    from NumberOfUsersAuthorizedForWebinar NU
    inner join users_on_webinar UW on UW.WebinarID = NU.WebinarID
    inner join Webinars W on W.WebinarID = NU.WebinarID
where Date < GETDATE()