/**
 * This sketch reads numeric data from the serial stream separated by a newline character, prints it to the console, and renders it to the screen.
 */

/*
int sensorData;

void setup() {
  Serial.begin(115200);
}

void loop() {
  sensorData = analogRead(0);  // Read sensor data from analog input 0.
  Serial.println(sensorValue1, DEC); // Print the sensor data to the serial port.
  delay(100); // Wait 100 ms before for next reading.
}
*/

import processing.serial.*;

Serial serialPort;

int data;       // array to read the 4 values
// TODO: Store the recent data history.

// Meter
int dataFloor = 0;
int dataCeiling = 800;

void setup() {
  
  frame.setTitle ("Serial Stream Relay"); // Set the window title
  size(640, 300, P3D); // size(640, 300);
  
  // List the available serial ports.
  String[] serialPorts = Serial.list ();
  println ("Serial ports:");
  for (int i = 0; i < serialPorts.length; i++) {
    println(i + " " + serialPorts[i]);
  }
  
  // TODO: Read serialPortIndex and baud rate interactively.
  int serialPortIndex = 9;
  int serialPortBaudRate = 115200;
  
  serialPort = new Serial (this, Serial.list()[serialPortIndex], serialPortBaudRate);
  serialPort.bufferUntil ('\n'); // Read bytes into a buffer until you get a newline character.
  
  // Set up the font.
  textFont (createFont ("Arial", 12));
}

void draw () {
  
  // Display the window.
  background (255);
  
  // Display the meter
  stroke (0);
  int dataMeterValue = (int) map (data, dataFloor, dataCeiling, 0, width);
  line (dataMeterValue, 0, dataMeterValue, height);
  
  // Display the data
  fill (0);
  textSize (32);
  text ("" + data, dataMeterValue + 5, 35);
}

void serialEvent (Serial myPort) {

  String serialData = myPort.readStringUntil ('\n'); // Read the serial buffer.
  
  if (serialData != null) {
    
    serialData = trim (serialData);
    data = int (serialData);
    
    println (data); // Print the data to the console.
    
  }
}