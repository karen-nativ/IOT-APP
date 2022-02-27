# TFLITE MICRO IOT Project 

# Project description:
The project is essentialy a remote controlled system which recognizes and classifies objects, using a neural network running on the edge devices.

# How to use the project:
In order to use the project please follow these steps:
1. Clone the repository and open the code in Android Studio.
2. Install the application to your android device or to an emulator.
3. Turn on the raspberry pi and connect it to the internet.
4. Point the camera towards objects you want recognized.
5. Control the camera using the app.

# Architecture:

![image](https://user-images.githubusercontent.com/97453576/152567363-f313eea6-da8a-41c6-b9fd-7213fbb365a5.png)

1. The raspberry pi sends the classification result to Firebase server, and the app reads it from the same location.
2. Using raspberry pi Zero device, running a neural network built in Edge-Impulse.
3. The model can recognize the following objects:
  * Bottle
  * Phone
  * Face
  * Bag
  * Watch


