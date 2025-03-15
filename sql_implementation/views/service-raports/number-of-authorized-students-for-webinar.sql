create view NumberOfUsersAuthorizedForWebinar as
select WebinarID, count(*) [Users]
from UsersAuthorizedForWebinar
group by WebinarID