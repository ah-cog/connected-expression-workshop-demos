int pingPin = 2;
float v = 331.5 + 0.6 * 20; // m/s

void setup () {
  Serial.begin (115200);
}

float distanceCm () {
  
  // Send sound pulse.
  pinMode (pingPin, OUTPUT);
  digitalWrite (pingPin, LOW);
  delayMicroseconds (3); // <3>
  digitalWrite (pingPin, HIGH);
  delayMicroseconds (5); // <4>
  digitalWrite (pingPin, LOW);

  // Listen for pulse response.
  pinMode (pingPin, INPUT); 
  float tUs = pulseIn (pingPin, HIGH); // Time betwen pulse and response in microseconds.
  float t = tUs / 1000.0 / 1000.0 / 2; // Response time in seconds.
  float d = t * v; // Distance in meters.
  return d * 100; // Distance in centimeters.
}

void loop () {
  int d = distanceCm ();
  Serial.println (d, DEC); // Print the sensor data to the serial port.
  delay (50);
}

