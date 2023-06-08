from flask import Flask
from create_user import createUser
from face_recognition import recognition
from get_attendance import getLessonAttendance
from flask import Flask
from teacher_authentication import teacherAuthentication
from week_list_post import postWeekList

app = Flask(__name__)

@app.route('/createUser', methods=['POST'])
def create_user_route():
    return createUser()

@app.route('/upload', methods=['POST'])
def upload_route():
    return recognition()

@app.route('/getLessonAttendance', methods=['POST'])
def attendace_list_get():
    return getLessonAttendance()

@app.route('/postLessonWeek', methods=['POST'])
def post_week_list():
    return postWeekList()

@app.route('/teacherAuthentication', methods=['POST'])
def post_teacher_authentication():
    return teacherAuthentication()

if __name__ == '__main__':
    app.run(debug=True , port=4000) 
