from flask import  request , jsonify
import werkzeug
import cv2
from PIL import Image
import numpy as np
from numpy import asarray
from numpy import expand_dims
import pickle
import cv2
from keras_facenet import FaceNet
from attendance import Attendance
from dbmanager import DbManager

def recognition():
    if(request.method == "POST"):
        lessonNumber = request.form.get('lessonNumber')
        #print(lessonNumber)
        attendaceTime = request.form.get('attendanceTime')
        #print(attendaceTime)
        
        imagefile = request.files["image"]
        filename = werkzeug.utils.secure_filename(imagefile.filename)
        imagefile.save("./uplodedimages/" + filename)
        image_path = "./uplodedimages/" + filename
        # OpenCV'nin yüz algılama sınıflandırıcısını (Cascade Classifier)
        # kullanarak yüzleri algılamak için HaarCascade nesnesi oluşturuluyor.
        HaarCascade = cv2.CascadeClassifier(cv2.samples.findFile(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml'))
        #yüz tanıma için kullanılan  derin öğrenme modelinin örneği olşuturulur
        MyFaceNet = FaceNet()
        # dosyaya erişim sağlanır
        myfile = open("data.pkl", "rb")
        #dosyadan okunan verileri içerir
        database = pickle.load(myfile)
        myfile.close()
        #OpenCV ile resim dosyası okunur ve gbr1 değişkenine atanır.
        gbr1 = cv2.imread(image_path)
        #1.1 zoom faktörü genellikle 1.1 kullanılır :
        # 1.1 + ; hız ++ küçük yüzleri bulma --
        # 4 : Minimum komşu sayısı değeri
        faceCoordinates = HaarCascade.detectMultiScale(gbr1, 1.1, 4)
        # en az bir yüz tespit edilmiş ise
        if len(faceCoordinates) > 0:
            # yüzün sol üst köşesini ve boyutunu belirtir
            x1, y1, width, height = faceCoordinates[0]
        else:
            x1, y1, width, height = 1, 1, 10, 10
        # köşe değişkeniyle boyutları kullanark yüzün diğer köşesi hesaplanır
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
         #facenet girdi olarak 4 boyutlu bir girdi bekler fakat bizim elimizde 160X160x3  
         #4 boyutlu girdinin nedeni input olarak birden fazla yüz olabilceğinden kaynaklanır
         #yalnızca 1 adet yüz varsa facenet girişi (1)x160x160x3 olmalıdır     
        face = expand_dims(face, axis=0)
        signature = MyFaceNet.embeddings(face)
        # Yüzün imzası (embedding) hesaplanır.
        #başlangıçta değer ve imza arasındaki fark 100 olarak verildi
        min_dist = 100
        identity = ' '
        for key, value in database.items():
            # yüz ,mzaları arasındaki fark hesaplanır
            dist = np.linalg.norm(value - signature) 
            if dist < min_dist: # eğer fark 100 den küçükse 
                #print(dist)
                min_dist = dist # yüz imazaları arasındaki fark güncellenir
                identity = key # olası eşleşme olarak kayıt edilir
        text = identity # tanımlanan kimliğin atanması
        #yazı özellikleri
        font = cv2.FONT_HERSHEY_SIMPLEX
        font_scale = 15
        font_color = (255, 255, 0) 
        thickness = 3
        line_type = cv2.LINE_AA 

        # Yazıyı görüntüye ekleme
        text_size, _ = cv2.getTextSize(text, font, font_scale, thickness)
        text_x = (gbr1.shape[1] - text_size[0]) // 2  # Yazının x koordinatı
        text_y = (gbr1.shape[0] + text_size[1]) // 2  # Yazının y koordinatı
        cv2.putText(gbr1, text, (text_x, text_y), font, font_scale, font_color, thickness, line_type)
        cv2.rectangle(gbr1, (x1, y1), (x2, y2), (0, 255, 0), 2)
        marked_image_path = "./uplodedimages/marked_" + filename
        cv2.imwrite(marked_image_path, gbr1)

        db = DbManager()
        if text != "unknown":
            student_id = db.getStudentIdByNumber(int(text))
            # okul numarasına sahip olunan öğrencinin İd_student değerini geri verir
            if student_id is not None:
                #print("Öğrenci ID:", student_id)
                # yeni yoklama kaydı id_lesson,date,id_student
                
                atd = Attendance(None,lessonNumber,attendaceTime,student_id)
                db.addAttendance(atd)
                return jsonify({
            "message":text+ "numaralı öğrenci için yoklama işlemi gerçekleştirlmiştir. "
        })
            else:
                student_id = None
        
        text= "Kayıt"
        return jsonify({
           "message":text + " bulunamadı "
        })