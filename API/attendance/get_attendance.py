from flask import request , jsonify
from dbmanager import DbManager
def getLessonAttendance():
    data = request.get_json()
    lesson = data['lesson']
    startTime = data['startTime']
    endTime = data['endTime']

    db = DbManager()
    attendance_list = db.getLessonAttendance(lesson, startTime, endTime)
 
    if  attendance_list is  None:
        attendance_list = ["boş değer"]
    """
    print("lesson")
    print(lesson)
    print("startTime")
    print(startTime)
    print("endTime")
    print(endTime)
    print("type(attendance)")
    print(type(attendance_list))
    print("type(attendance)")"""
    return jsonify({'attendance_list':attendance_list})