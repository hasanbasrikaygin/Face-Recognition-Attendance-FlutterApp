import mysql.connector
from attendance import Attendance
from connection import connection
from student import Student
class DbManager:
    def __init__(self):
        # başlangıçta otomatik olarak çalışır
        # veri tabanı bağlantısını oluşturur
        self.connection = connection
        # veri tabanı üzerinde sorguları çalıştırmak için kullanılır
        self.cursor = self.connection.cursor()

    # yoklaması yapılan öğrencinin 
    # okul numarasına göre id_student değerini geri verir
    def getStudentIdByNumber(self, number):
        sql = "SELECT id_student FROM st_student WHERE number = %s "
        values = (number,)
        # sorgu gerçekleştirilir
        self.cursor.execute(sql, values)
        try:# tek satır verisini döndürür
            result = self.cursor.fetchone()
            if result is not None: 
                # ilk satırdaki id;_Student döndürür
                return result[0]
            else:
                return None
        except mysql.connector.Error as err:
            print("Error: ", err)
    # öğretmenin seçtiği derse ait geçmiş derslerin tarihleri 
    def getLessonWeekTime(self, lesson):
        sql = """
        SELECT start_time, end_time, lesson_name, week FROM week WHERE lesson_name = %s
    """
        value = (lesson,)
        self.cursor.execute(sql, value)
        # tüm sonuçalrı döndürür
        results = self.cursor.fetchall()
        lesson_data = []

        for row in results: # resulttaki her satır  için oluşturulur
            start_time = str(row[0])
            end_time = str(row[1])
            lesson_name = row[2]
            week = row[3]
            # bilgiler her satır için toplanır  
            lesson_info = f"{week} Başlangıç tarihi : {start_time}  Bitiş tarihi : {end_time}, "
            # string diziye aktarılır
            lesson_data.append(lesson_info)

        return lesson_data

   
    # girilen ders başlangıç ve bitiş tarihlerini ve ders adını kullanarak 
    # istenilen zaman aralığında bulunan öğrencileri gösterir
    def getLessonAttendance(self,lesson,firstDate,secondDate):
        sql ="""
                SELECT
                    st_student.name,
                    st_student.surname,
                    st_student.number
                FROM 
	                at_attendance
                INNER JOIN st_student  ON at_attendance.id_student = st_student.id_student
                INNER JOIN le_lesson   ON at_attendance.id_lesson  = le_lesson.id_lesson
                WHERE le_lesson.name =%s
                AND at_attendance.date BETWEEN %s AND %s
        
        """ 
        value = (lesson,firstDate,secondDate,)
        self.cursor.execute(sql,value)
        try:
            results = self.cursor.fetchall()
            students =[]
            for row in results:
                # bilgiler her satır için toplanır 
                student_attendance = f"{row[0]} {row[1]} {row[2]}" 
                # string diziye aktarılır
                students.append(student_attendance) 
            return students
        except mysql.connector.Error as err:
            print("Error : ", err)
        pass


        # gelen ad , soyad ve numara bilgilerine göre yeni öğrenci kaydı oluşturur
    def addStudent(self,student:Student):
        sql = "INSERT INTO st_student(name,surname,number) VALUES (%s,%s,%s)"
        value = (student.name,student.surname,student.number)
        self.cursor.execute(sql,value)

        try:
            #Veritabanındaki değişiklikleri onaylamak için kullanıyoruz
            self.connection.commit()
            #print(f'{self.cursor.rowcount} tane öğrenci kaydi eklendi .')
        except mysql.connector.Error as err:
            print("hata : ", err)


    # gelen ders tarih ve id_student değerlerini at_attendance tablosuna ekler
    # öğrenci yoklama alma işlemini geröekleştirir
    def addAttendance(self,attendance:Attendance):
        sql = """
        INSERT INTO at_attendance(id_lesson,date,id_student) 
        VALUES (%s,%s,%s)
        """
        
        value = (attendance.id_lesson,attendance.date,attendance.id_student,)
        self.cursor.execute(sql,value)

        try:
            #Veritabanındaki değişiklikleri onaylamak için kullanıyoruz
            self.connection.commit()
            print(f'{self.cursor.rowcount} tane yoklama kaydi eklendi .')
        except mysql.connector.Error as err:
            print("hata : ", err)


    # öğretmen hafta ve tarih seçererk ders kaydı oluşturur
    def addWeekLessonTime(self,week,startTime,endTime,lesson):
        sql ="""
        INSERT INTO week (week, start_time, end_time, lesson_name)
        VALUES (%s,%s,%s,%s)
        """
        value = (week,startTime,endTime,lesson)
        self.cursor.execute(sql,value)
        try:
            #Veritabanındaki değişiklikleri onaylamak için kullanıyoruz
            self.connection.commit()
            #print(' ders kaydi eklendi .')
        except mysql.connector.Error as err:
            print("hata : ", err)
        pass

        # kullanıcı adı ve parola doğrulama
    def checkTeacherAuthentication(self, name, password): 
        # eşleşen satır sayısı döndürlür
        sql = "SELECT COUNT(*) FROM teacher WHERE name = %s AND password = %s"
        value = (name, password)
        self.cursor.execute(sql,value)
        try:
            #veri tabanınadan dönen sonuç alınır
            result = self.cursor.fetchone()[0]
            if result > 0:
                return True
            else:
                return False
        except mysql.connector.Error as err:
            print("hata : ", err)
        pass

