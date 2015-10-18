import processing.video.*;

Movie video;
String videoFilePath;
int videoFramesPerSecond = 60;

void setup() {
  
  surface.setTitle ("Video Player");
  size (640, 320);
  frameRate (videoFramesPerSecond);
  
  videoFilePath = "";
  selectInput ("Select a video file.", "videoFileSelected");
}

void draw () {
  if (video != null) {
    
    // Get the next frame from the video.
    if (video.available ()) {
      video.read ();
    }
    
    // Apply effects to the frame.
    // tint (255, 20);
    
    // Display the frame.
    image (video, 0, 0);
    
  }
}

void videoFileSelected (File selection) {
  if (selection == null) {
    println ("Window was closed or the user hit cancel.");
  } else {
    println ("Loading video from \"" + selection.getAbsolutePath () + "\"");
    videoFilePath = selection.getAbsolutePath ();
    
    // Ask for the location of a video file.
    video = new Movie (this, videoFilePath);
    video.frameRate (videoFramesPerSecond);
    video.play ();
  }
}

// "This event function is run when a new movie frame is available. Use the read() method to capture this frame."
void movieEvent (Movie m) {
  m.read ();
}