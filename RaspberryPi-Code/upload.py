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

