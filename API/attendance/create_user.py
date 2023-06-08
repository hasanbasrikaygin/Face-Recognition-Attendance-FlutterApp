from flask import request , jsonify
import cv2
from PIL import Image
from numpy import asarray
from numpy import expand_dims
import pickle
import cv2
from keras_facenet import FaceNet
import os
from os import listdir
from student import Student
from dbmanager import DbManager
def createUser():
    
    if(request.method == "POST"):
        imagefile = request.files["image"]
        name = request.form.get('name')
        surname = request.form.get('surname')
        number = request.form.get('number')
        #print(" **** "+number+ " ****")      
        filename = f"{number}.jpg"
        imagefile.save("./createUser/" + filename)
        
        #database işlemleri
        # öğrenci nesnesinin ad , soyad , 
        # numara bilgileriyle veri tabanınan kayıt edilmesi
        db = DbManager()
        std = Student(None,name,surname,int(number))                                   
        db.addStudent(std)
        #print(name)
        #print(surname)

        # OpenCV'nin yüz algılama sınıflandırıcısını (Cascade Classifier)
        # kullanarak yüzleri algılamak için HaarCascade nesnesi oluşturuluyor.
        HaarCascade = cv2.CascadeClassifier(cv2.samples.findFile(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml'))
        #yüz tanıma için kullanılan  derin öğrenme modelinin örneği olşuturulur
        MyFaceNet = FaceNet()
        # resimlerin bulunduğu klasör
        folder = "createUser/"
        # kullanıcıların yüz imzalarını tutmak için sözlük oluşturulması
        database = {}

        for filename in listdir(folder):
            if filename.endswith(".jpg") or filename.endswith(".jpeg") or filename.endswith(".png"):           
                path = folder + filename
                #print(path)
                #OpenCV ile resim dosyası okunur ve gbr1 değişkenine atanır.
                gbr1 = cv2.imread(folder + filename)
                
                if gbr1 is not None:
                    #1.1 zoom faktörü genellikle 1.1 kullanılır :
                    # 1.1 + ; hız ++ küçük yüzleri bulma --
                    # 4 : Minimum komşu sayısı değeri
                    faceCoordinates = HaarCascade.detectMultiScale(gbr1, 1.1, 4)         
                    # en az bir yüz tespit edilmiş ise
                    if len(faceCoordinates) > 0:
                        x1, y1, width, height = faceCoordinates[0]   
                    # yüzün sol üst köşesini ve boyutunu belirtir          
                    else:
                        x1, y1, width, height = 1, 1, 10, 10
                    # köşe edğişkeniyle boyutları kullanark yüzün diğer köşesi hesaplanır
                    x1, y1 = abs(x1), abs(y1)
                    x2, y2 = x1 + width, y1 + height
                    # opencv katmanındaki veriler bgr olarak bulunur
                    # pil ile rgb olarak kullanır
                    # görüntü değişkenine opencv ile aldığımız görübtü bgr den rgbye dönüştürmemiz gerekir
                    #dönüşümden sonra  bgr olarak isimlenidiriyoruz
                    gbr = cv2.cvtColor(gbr1, cv2.COLOR_BGR2RGB)
                    gbr = Image.fromarray(gbr)
                    # yüzün arraye dönüşümü             
                    gbr_array = asarray(gbr)
                     # resimin köşe konunmularına göre resim kırpma işlemi gerçekleştirilir
                    face = gbr_array[y1:y2, x1:x2]   
                    #yüzün yeniden boyutlandırılması
                    #nedeni facenet 160x160 girdi alacak şeklide eğitilmiştir           
                    face = Image.fromarray(face)                       
                    face = face.resize((160, 160))
                    face = asarray(face)
                    #facenet girdi olarak 4 boyutlşu bir girdi bekler fakat bizim elimizde 160X160x3 ... vardır
                    #4 boyutlu girdinin nedeni input olarak birden fazla yüz olabilceğinden kaynaklanır
                    #yalnızca 1 adet yüz varsa facenet girişi (1)x160x160x3 olmalıdır
                    face = expand_dims(face, axis=0)
                    # Yüzün imzası (embedding) hesaplanır.
                    signature = MyFaceNet.embeddings(face)
                    # imzanın databaseye kayıt edilmesi
                    database[os.path.splitext(filename)[0]] = signature                 
                #else:
                    #print("Resim yüklenemedi!")
            else:
                continue
        myfile = open("data.pkl", "wb")
        pickle.dump(database, myfile)
        myfile.close()
                


        return jsonify({
            "message":"Sevgili "+ name +" İşleminiz gerçekleştirilmiştir. ", "name": name, "surname": surname
        })