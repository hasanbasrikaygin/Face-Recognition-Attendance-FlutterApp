class Student:
    def __init__(self,id_student,name,surname, number,):
        if id is None:
            self.id_lesson = 0
        else:
            self.id_student=id_student
        self.name=name
        if len(surname)>50:
            raise Exception("name hatasi")
        self.surname=surname
        
        self.number=number
    @staticmethod
    def CreateStudent(obj):
        list = []

        if isinstance(obj, tuple):
            list.append(Student(obj[0],obj[1],obj[2],obj[3],))
        else:
            for i in obj:
                list.append(Student(i[0],i[1],i[2],i[3],))
        return list