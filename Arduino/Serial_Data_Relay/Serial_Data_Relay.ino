int sensorData;

void setup() {
  Serial.begin(115200);
}

void loop() {
  sensorData = analogRead(0);  // Read sensor data from analog input 0.
  Serial.println(sensorData, DEC); // Print the sensor data to the serial port.
  delay(100); // Wait 100 ms before for next reading.
}
