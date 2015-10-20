import processing.video.*;

Capture camera;
int numPixels;

String timestamp;

ArrayList<int[]> frames = new ArrayList<int[]>();
ArrayList<String> samples = new ArrayList<String>();
int currentSample = -1;
int currentFrame = 0;
boolean isCapturingSample = false;

void setup () {
  
  frame.setTitle ("Video Sampler");
  size (640, 480); // size (640, 320, P3D);
  frameRate (30);

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
    camera = new Capture (this, width, height); // camera = new Capture (this, 640, 480, "Built-in iSight", 30);
  }
}

void draw () {

  if (isCapturingSample) {
    if (camera.available()) {
      camera.read (); // Get the next frame from the camera.
      camera.loadPixels ();
      loadPixels();
      int[] framePixels = new int[numPixels];
      for (int i = 0; i < numPixels; i++) {
        framePixels[i] = camera.pixels[i]; // Save the current pixel from the camera.
        pixels[i] = framePixels[i]; // Copy the pixel from the camera to the window.
      }
      frames.add (framePixels); // Save the frame in a list.
      println ("Added frame to video.");
      updatePixels();
    }
  } else {
    // Play back frames in sequenced
    if (frames.size () > 0) {
      currentFrame = (currentFrame + 1) % frames.size ();
      int[] framePixels = frames.get (currentFrame);
      println ("Showing frame " + currentFrame + " of " + framePixels.length + " pixels.");
      loadPixels ();
      for (int i = 0; i < framePixels.length; i++) {
        pixels[i] = framePixels[i];
      }
      updatePixels ();
    }
  }
}

void keyReleased () {
  if (key == ' ') {
    if (isCapturingSample) {
      
      camera.stop ();
      isCapturingSample = false;
      println("Stopped recording.");
      
    } else {
      
      // Create recorder with name equal to the current time formatted like "2015_10_17_12_48_28".
      timestamp = String.valueOf(year()) + "_" + String.valueOf(month()) + "_" + String.valueOf(day()) + "_" + String.valueOf(hour()) + "_" + String.valueOf(minute()) + "_" + String.valueOf(second());
      camera.start();
      numPixels = camera.width * camera.height;
      isCapturingSample = true;
      println("Started recording.");
    }
  }
}