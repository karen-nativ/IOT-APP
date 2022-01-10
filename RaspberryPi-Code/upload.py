from firebase_admin import credentials, initialize_app, storage

def firebase_init():
    # Initialize firebase with credentials
    cred = credentials.Certificate("credentials.json")
    initialize_app(cred, {"storageBucket" : "iot-tflite.appspot.com"})

def upload_file(fileName):
    # Put your local file path
    bucket = storage.bucket()
    blob = bucket.blob("logs/"+fileName)
    blob.upload_from_filename(fileName)

    # Opt : if you want to make public access from the URL
    blob.make_public()

    print("your file url", blob.public_url)


#import pyrebase
#config = {
#        "apiKey": "",
#        "authDomain": "",
#        "databaseURL": "",
#        "storageBucket": ""
#        }
import datetime
cred = credentials.Certificate("credentials.json")
app = initialize_app(cred, {"storageBucket" : "iot-tflite.appspot.com"})
source_blob_name = "logs/result.txt"
bucket_name = "iot-tflite.appspot.com"
destination_file_name = r"TEST.txt"

bucket = storage.bucket(app=app)
blob = bucket.blob(source_blob_name)
#blob.download_to_filename(destination_file_name)
print(blob.generate_signed_url(datetime.timedelta(seconds=3000), method='GET'))


