/**
 * Soundsampler
 * http://github.com/mokogobo/soundsampler
 * @mokogobo
 * moko.im
 
 
 * This sketch demonstrates how to an <code>AudioRecorder</code> to record audio to disk. 
 * To use this sketch you need to have something plugged into the line-in on your computer, 
 * or else be working on a laptop with an active built-in microphone. 
 * <p>
 * Press 'r' to toggle recording on and off and the press 's' to save to disk. 
 * The recorded file will be placed in the sketch folder of the sketch.
 * <p>
 * For more information about Minim and additional features, 
 * visit http://code.compartmental.net/minim/
 */

import ddf.minim.*;

Minim minim;
AudioInput in;
AudioRecorder recorder;
AudioPlayer player;
String timestamp;

ArrayList<String> samples = new ArrayList<String>();
int currentSample = -1;
boolean isPlayingSample = false;

void setup()
{
  size (640, 300, P3D);
  
  minim = new Minim (this);

  in = minim.getLineIn ();
  
  // create a recorder that will record from the input to the filename specified
  // the file will be located in the sketch's root folder.
  //String timestamp = String.valueOf(year()) + "_" + String.valueOf(month()) + "_" + String.valueOf(day()) + "_" + String.valueOf(hour()) + "_" + String.valueOf(minute()) + "_" + String.valueOf(second()); // 2015_10_17_12_48_28
  //recorder = minim.createRecorder(in, timestamp + ".wav");
  recorder = null;
  
  textFont (createFont ("Arial", 12));
}

void draw()
{
  background(255); 
  stroke(0);
  // draw the waveforms
  // the values returned by left.get() and right.get() will be between -1 and 1,
  // so we need to scale them up to see the waveform
  for(int i = 0; i < in.bufferSize() - 1; i++)
  {
    line(i, 50 + in.left.get(i)*50, i+1, 50 + in.left.get(i+1)*50);
    line(i, 150 + in.right.get(i)*50, i+1, 150 + in.right.get(i+1)*50);
  }
  
  if (recorder != null) {
    if ( recorder.isRecording() )
    {
      text("Currently recording...", 5, 15);
    }
    else
    {
      text("Not recording.", 5, 15);
    }
  } else {
    
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
          // TODO: Start playing at a specified start millisecond to a specified stop millisecond.
          
          //// player.length (); // Returns the length of the sample in milliseconds.
          println ("Playing " + sampleFileName + ".");
        }
        
        if (!player.isPlaying ()) {
          
          // Remove the sample from memory and close the sample file.
          player.close ();
          
          // Remove the player from memory.
          player = null;
        }
      }
    }
  }
}

void keyReleased()
{
  if (key == ' ') 
  {
    // to indicate that you want to start or stop capturing audio data, you must call
    // beginRecord() and endRecord() on the AudioRecorder object. You can start and stop
    // as many times as you like, the audio data will be appended to the end of the buffer 
    // (in the case of buffered recording) or to the end of the file (in the case of streamed recording).
    if (recorder != null) {
      if ( recorder.isRecording() )
      {
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
      }
    }
    else 
    {
      // Create recorder with name equal to the current time formatted like "2015_10_17_12_48_28".
      timestamp = String.valueOf(year()) + "_" + String.valueOf(month()) + "_" + String.valueOf(day()) + "_" + String.valueOf(hour()) + "_" + String.valueOf(minute()) + "_" + String.valueOf(second());
      recorder = minim.createRecorder(in, timestamp + ".wav");
  
      // Start recording
      recorder.beginRecord();
      println("Started recording.");
    }

  }
}