from flask import  request , jsonify
from dbmanager import DbManager
def postWeekList():
    data = request.get_json()
    lesson = data['lesson']
    startTime = data['startTime']
    endTime = data['endTime']
    week = data['week']

    db = DbManager()
    db.addWeekLessonTime(week, startTime, endTime, lesson)
    
    db = DbManager()
    lesson_data = db.getLessonWeekTime(lesson)
    """
    print("week")
    print(week)
    print("lesson")
    print(lesson)
    print("startTime")
    print(startTime)
    print("endTime")
    print(endTime)
    print("type(attendance)")
    print("type(attendance)")"""
    return jsonify({'lesson_data':lesson_data})