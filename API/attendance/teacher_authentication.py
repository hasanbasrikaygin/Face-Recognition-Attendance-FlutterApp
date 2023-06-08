from flask import  request , jsonify
from dbmanager import DbManager
def teacherAuthentication():
    data = request.get_json()
    name = data['name']
    password = data['password']
    #print(password)
    #print(name)
    db = DbManager()
    if db.checkTeacherAuthentication(name,password):
        return  jsonify({'result': 'true'})
    else:
        return  jsonify({'result': 'false'})
