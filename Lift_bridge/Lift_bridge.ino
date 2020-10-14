// ************ Data structure definitions ************ //

enum LEDState {
  OFF,
  ON,
  FLASHING
};

class QTI {
private:
  int pin;
  int lastState;

public:
  QTI(int _pin);
  int readValue(bool storeLast = true);
  int readAndPrint(bool newLine = false);
  int readRisingEdge();
};

QTI::QTI(int _pin) {
  pin = _pin;
}

int QTI::readValue(bool storeLast = true) {
  pinMode(pin, OUTPUT);
  digitalWrite(pin, HIGH);
  delay(1);

  pinMode(pin, INPUT);
  delay(1);

  // digitalRead will return 0 if the QTI senses something and 1 otherwise, not flips this
  int reading = !digitalRead(pin);
  if(storeLast) {
    lastState = reading;
  }
  return reading;
}

int QTI::readAndPrint(bool newLine = false) {
  int reading = readValue();
  Serial.print(reading);
  if (newLine) {
    Serial.println("");
  }
  return reading;
}

int QTI::readRisingEdge() {
  int reading = readValue(false);
  if (reading != lastState && reading) {
    lastState = reading;
    return 1;
  }
  lastState = reading;
  return 0;
}

const unsigned long LEDFlashInterval = 500;

class LEDPair {
private:
  int pin1;
  int pin2;
  LEDState state = OFF;

public:
  unsigned long lastFlash = 0;
  bool powerState = false; // false = off, true = on

  LEDPair(int _pin1, int _pin2);
  void setState(LEDState _state);
  void updatePower();
  void setLastFlash(int _lastFlash);
  void getLastFlash();
  LEDState getState();
};

LEDPair::LEDPair(int _pin1, int _pin2) {
  pin1 = _pin1;
  pin2 = _pin2;
  pinMode(pin1, OUTPUT);
  pinMode(pin2, OUTPUT);
}

void LEDPair::setState(LEDState _state) {
  LEDState oldState = state;
  state = _state;
  if(state == oldState) {
    return;
  }
  updatePower();
}

void LEDPair::updatePower() {
  if (state == OFF) {
    digitalWrite(pin1, LOW);
    digitalWrite(pin2, LOW);
  }
  else if (state == ON) {
    digitalWrite(pin1, HIGH);
    digitalWrite(pin2, HIGH);
  }
  else if (state == FLASHING) {
    unsigned long timeNow = millis();
    if(timeNow - lastFlash < LEDFlashInterval) {
      return;
    }
    if (powerState) {
      digitalWrite(pin1, LOW);
      digitalWrite(pin2, LOW);
    }
    else {
      digitalWrite(pin1, HIGH);
      digitalWrite(pin2, HIGH);
    }
    powerState = !powerState;
    lastFlash = timeNow;
  }
}

LEDState LEDPair::getState() {
  return state;
}

// ************ Pins and components ************ //

// LED pin outputs
LEDPair standbyLED = LEDPair(2, 3); // Yellow LEDs that flash when a boat is waiting
LEDPair stopLED = LEDPair(4, 5); // Red LEDs that turn on while the bridge is lifting

// Motor controller outputs
int motorOutput1 = 12;
int motorOutput2 = 13;

// QTI sensors inputs
QTI boatSensor1 = QTI(6);
QTI boatSensor2 = QTI(7);
QTI leftLaneSensor1 = QTI(8); // Which side is left or right doesn't matter
QTI leftLaneSensor2 = QTI(9);
QTI rightLaneSensor1 = QTI(10);
QTI rightLaneSensor2 = QTI(11);

// ************ Globals ************ //
int leftLaneCars = 0;
int rightLaneCars = 0;
bool boatWaiting = false;
const int upMotorOut = HIGH; // The value to set to motorOutput1 when raising the bridge
const int bookendDelay = 5000;
const int liftDelay = 22000;
const int lowerDelay = 8000;
const int holdBridgeDelay = 10000;

// Setup pins and serial monitor
void setup() {
  Serial.begin(9600); // Set up serial monitor for debug output

  pinMode(motorOutput1, OUTPUT);
  digitalWrite(motorOutput1, LOW);
  pinMode(motorOutput2, OUTPUT);
  digitalWrite(motorOutput2, LOW);
}

// Delay while keeping blinking LEDs ticking
void delayWithSubroutines(unsigned long delayLength) {
  unsigned long startTime = millis();
  Serial.print("START ");
  Serial.print(startTime);
  while(millis() - startTime < delayLength) {
    LEDUpdate();
    delay(50);
  }
  Serial.print(" END ");
  Serial.println(millis());
}

// Start the motors in a specific direction, up or down
void engageMotors(bool up) {
  // Using the not operator on an integer returns true if 0, false otherwise
  // A true value is then converted to an integer 1, meaning the value is flipped from 0 to 1 (LOW to HIGH) or vice versa
  digitalWrite(motorOutput1, up ? upMotorOut : !upMotorOut);
  // Other output needs the opposite for the motors to run
  digitalWrite(motorOutput2, up ? !upMotorOut : upMotorOut);
}

// Stop the motors
void stopMotors() {
  digitalWrite(motorOutput1, LOW);
  digitalWrite(motorOutput2, LOW);
}

// Move the bridge. If up = true, move it up, otherwise move it down
void moveBridge(bool up) {
  //Make both LEDs flash at the same time, but alternating
  stopLED.lastFlash = standbyLED.lastFlash;
  stopLED.powerState = !standbyLED.powerState;
  standbyLED.setState(FLASHING);
  stopLED.setState(FLASHING);

  // Delay before lifting/lowering
  delayWithSubroutines(bookendDelay * (up ? 2 : 1));
  if(up) {
    standbyLED.setState(ON);
  }
  // Lift/lower
  engageMotors(up);
  delayWithSubroutines(up ? liftDelay : lowerDelay);
  stopMotors();

  //LED control
  if(!up) {
    standbyLED.setState(OFF);
  }
  else {
    stopLED.setState(ON);
  }

  // Delay before reallowing traffic
  delayWithSubroutines(bookendDelay * (up ? 1 : 2));

  if(!up) {
    stopLED.setState(OFF);
  }
}

// Update LED state machines
void LEDUpdate() {
  Serial.print(standbyLED.getState());
  Serial.print(" ");
  Serial.println(stopLED.getState());
  standbyLED.updatePower();
  stopLED.updatePower();
}

// Main loop
void loop() {
  
  // Track cars
  rightLaneCars += rightLaneSensor1.readRisingEdge();
  rightLaneCars -= rightLaneSensor2.readRisingEdge();

  leftLaneCars += leftLaneSensor1.readRisingEdge();
  leftLaneCars -= leftLaneSensor2.readRisingEdge();

  // Check for boats
  if(!boatWaiting) {
    boatWaiting = boatSensor1.readValue();
  }
  if(!boatWaiting) {
    boatWaiting = boatSensor2.readValue();
  }

  // Debug output
  Serial.print(rightLaneCars);
  Serial.print(leftLaneCars);
  Serial.print(boatWaiting);
  Serial.println("");

  // Serial.print(' ');
  // leftLaneSensor1.readAndPrint();
  // leftLaneSensor2.readAndPrint();
  // boatSensor2.readAndPrint(true);

  // Update LEDs based on whether there's a boat request
  if (boatWaiting) {
    standbyLED.setState(FLASHING);
  }
  else {
    standbyLED.setState(OFF);
  }

  // Move bridge if boat and no cars
  if(boatWaiting && rightLaneCars ==0 && leftLaneCars == 0) {
    moveBridge(true);
    delayWithSubroutines(holdBridgeDelay);
    moveBridge(false);
    boatWaiting = false;
  }

  // Update LED state machine
  LEDUpdate();

  delay(50);
}
