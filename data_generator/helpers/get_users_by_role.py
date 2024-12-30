def get_users_by_role(cursor, role):
    cursor.execute(f"select * from dbo.Employees e inner join dbo.EmployeeRoles r on e.EmployeeID = r.EmployeeID where RoleID = {role}")
    users = []
    for row in cursor.fetchall():
        users.append({
            "EmployeeID": row[0],
            "FirstName": row[1],
            "LastName": row[2],
            "BirthDate": row[3],
            "HireDate": row[4],
            "AddressID": row[5],
            "Phone": row[6]
        })
    return users