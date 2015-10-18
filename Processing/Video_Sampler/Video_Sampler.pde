import processing.video.*;

Capture camera;

void setup () {
  
  frame.setTitle ("Video Sampler");
  size (640, 360); // size (640, 320, P3D);

  String[] cameras = Capture.list ();
  
  if (cameras.length == 0) {
    println ("No cameras are available.");
    exit ();
  } else {
    
    // List the available cameras.
    println ("Cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println (i + ". " + cameras[i]);
    }
    
    // Select camera to serve as the video source.
    camera = new Capture (this, cameras[0]);
    
    // Start the camera.
    camera.start ();     
  }      
}

void draw () {

  // Capture a frame from the camera.
  if (camera.available ()) {
    camera.read ();
  }

  // Flip the captured frame horizontally and display it. 
  scale (-1, 1);
  image (camera, 0, 0, -width, height);
}