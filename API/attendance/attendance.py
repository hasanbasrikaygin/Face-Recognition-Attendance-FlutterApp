class Attendance:
    def __init__(self,id_attendance,id_lesson,date,id_student):
        if id is None:
            self.id_attendance = 0
        else:
            self.id_attendance=id_attendance
        self.id_lesson=id_lesson
        self.date=date
        self.id_student=id_student
        
    
    @staticmethod
    def CreateAttendace(obj):
        # öğrencinin bilgileri alınarak Attendance örnekleri 
        # oluşturulur ve bu örnekler bir liste olarak döndürülür
        list = []

        # eğer tek bir öğrenciyi temsil ediyorsa
        if isinstance(obj, tuple):
            # öğrenci örneği eklenir
            list.append(Attendance(obj[0],obj[1],obj[2],obj[3]))
        else:
            for i in obj:
                list.append(Attendance(i[0],i[1],i[2],i[3]))
        return list