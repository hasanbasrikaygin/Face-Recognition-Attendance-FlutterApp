import mysql.connector
#  MySQL veritabanına bağlantı kurulması 
connection = mysql.connector.connect( # bağlantı oluşturma
    host = "host",
    user="user_name",
    password="password",
    database="schema_name"
)