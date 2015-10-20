// Audio Sampler
// Demo for "Connected Expression" Masterclass
// http://deviceofmind.net/blik/
//
// "You get crazy beats with it." - Maarten Lamers
//
// Code by @mokogobo

import ddf.minim.*;

Minim minim;
AudioInput in;
AudioRecorder recorder;
AudioPlayer player;
String timestamp;

ArrayList<String> samples = new ArrayList<String> ();
int currentSample = -1;
int backgroundColor = color (255, 255, 255);

void setup () {
  
  frame.setTitle ("Audio Sampler");
  size (640, 300, P2D); // size (640, 300, P3D);
  
  minim = new Minim (this);
  in = minim.getLineIn ();
  recorder = null; // Create a recorder that will record from the input to the filename specified.
}

void draw () {
  
  // Draw the background (a solid color).
  background (backgroundColor);
  stroke (0); 
  
  // Draw the audio waves.
  for (int i = 0; i < in.bufferSize () - 1; i++) {
    line (i, 75 + in.left.get (i) * 75, i + 1, 75 + in.left.get (i+1) * 75);
    line (i, (height - 75) + in.right.get (i) * 75, i + 1, (height - 75) + in.right.get (i+1) * 75);
  }

  // Play samples.
  if (samples.size () > 0) {
    
    if (currentSample == -1) {
      currentSample = 0;
    } else {
      
      // Load the next sample for playback and play it.
      if (player == null) {
        currentSample = (currentSample + 1) % samples.size (); // Get next sample filename.
        String sampleFileName = samples.get (currentSample); // Get the next sample's filename.
        player = minim.loadFile (sampleFileName); // Load the next sample into memory.
        player.play (); // Play the sample.
        
        // Returns the length of the sample in milliseconds.
        println ("Playing " + sampleFileName + ".");
      }
      
      // Stop the player.
      if (!player.isPlaying ()) {
        player.close (); // Remove the sample from memory and close the sample file.
        player = null; // Remove the player from memory.
      }
      
    }
  }
}

// Handle keyboard input.
void keyReleased () {
  if (key == ' ') {
    if (recorder != null) {
      if (recorder.isRecording ()) {
        
        // Stop the recording.
        recorder.endRecord();
        println("Stopped recording.");
        recorder.save();
        println("Saved recording to file " + timestamp + ".wav.");
        samples.add(timestamp + ".wav");
        recorder = null;
        timestamp = "";
        
        // Print the array of recordings
        for (String sampleFileName : samples) {
          println (sampleFileName);
        }
        
        // Set background color
        backgroundColor = color (255, 255, 255);
      }
      
    } else {
      
      // Create recorder with name equal to the current time formatted like "2015_10_17_12_48_28".
      timestamp = String.valueOf (year ()) + "_" + String.valueOf (month ()) + "_" + String.valueOf (day ()) + "_" + String.valueOf (hour ()) + "_" + String.valueOf (minute ()) + "_" + String.valueOf (second ());
      recorder = minim.createRecorder(in, timestamp + ".wav");
  
      // Start recording
      recorder.beginRecord();
      println("Started recording.");
      
      // Set background color
      backgroundColor = color (255, 0, 0);
      
    }
  }
}