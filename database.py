import mysql.connector 

def get_connection():
    connection = mysql.connector.connect(
        host="localhost",
        user="root",
        password="(*akshi#123)",
        database="db_project_payroll"
    )
    return connection
