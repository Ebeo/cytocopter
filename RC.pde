// interval [1000;2000]
volatile uint16_t rcValue[8] = {1502, 1502, 1502, 1502, 1502, 1502, 1502, 1502};
static uint8_t rcChannel[8]  = {ROLLPIN, PITCHPIN, YAWPIN, THROTTLEPIN, AUX1PIN, AUX2PIN, CAM1PIN, CAM2PIN};

// configure each rc pin for PCINT
void initializeReceiver() {
  // PCINT activated only for specific pin inside [D0-D7], [D2 D4 D5 D6 D7] for this multicopter
  // enable internal pull ups on the PINs of PORTD (no high impedence PINs)
  PORTD   = (1<<2) | (1<<4) | (1<<5) | (1<<6) | (1<<7); 
  PCMSK2 |= (1<<2) | (1<<4) | (1<<5) | (1<<6) | (1<<7); 

  PORTB   = (1<<0) ; 
  PCMSK0 |= (1<<0) ; 

  // PCINT activated only for the port dealing with [D0-D7] PINs
  PCICR   = (1<<2); 
}

// this ISR is common to every receiver channel, it is call everytime a change state occurs on a digital pin [D2-D7]
ISR(PCINT2_vect) { 
  uint8_t mask;
  uint8_t pin;
  uint16_t cTime;
  uint16_t dTime;
  static uint16_t edgeTime[8];
  static uint8_t PCintLast;

  // PIND indicates the state of each PIN for the arduino port dealing with [D0-D7] digital pins (8 bits variable)
  pin = PIND;          

  // doing a ^ between the current interruption and the last one indicates wich pin changed
  mask = pin ^ PCintLast;    

  // re enable other interrupts at this point, the rest of this interrupt is not so time critical and can be interrupted safely
  sei();                

  // we memorize the current state of all PINs [D0-D7]
  PCintLast = pin;      

  // micros() return a uint32_t, but it is not usefull to keep the whole bits => we keep only 16 bits
  cTime = micros();           

  // mask is pins [D0-D7] that have changed
  // the principle is the same on the MEGA for PORTK and [A8-A15] PINs
  // chan = pin sequence of the port. chan begins at D2 and ends at D7
  // indicates the bit 2 of the arduino port [D0-D7], that is to say digital pin 2, if 1 => this pin has just changed
  // rcValue[2]
  if (mask & 1<<2)             
  {
    // indicates if the bit 2 of the arduino port [D0-D7] is not at a high state (so that we match here only descending PPM pulse)
    if (!(pin & 1<<2))
    {     
      dTime = cTime - edgeTime[2];

      if (900 < dTime && dTime < 2200)
      {
        // just a verification: the value must be in the range [1000;2000] + some margin
        rcValue[2] = dTime; 
      }
    }
    else
    {
      // if the bit 2 of the arduino port [D0-D7] is at a high state (ascending PPM pulse), we memorize the time
      edgeTime[2] = cTime;    
    }
  }

  // same principle for other channels
  // avoiding a for() is more than twice faster, and it's important to minimize execution time in ISR
  // rcValue[4]
  if (mask & 1<<4)   
  {
    if (!(pin & 1<<4))
    {
      dTime = cTime - edgeTime[4];

      if (900 < dTime && dTime < 2200)
      {
        rcValue[4] = dTime;
      }
    }
    else
    {
      edgeTime[4] = cTime;
    }
  }

  // rcValue[5]
  if (mask & 1<<5)
  {
    if (!(pin & 1<<5))
    {
      dTime = cTime - edgeTime[5];

      if (900 < dTime && dTime < 2200)
      {
        rcValue[5] = dTime;
      }
    }
    else
    {
      edgeTime[5] = cTime;
    }
  }

  // rcValue[6]
  if (mask & 1<<6)
    if (!(pin & 1<<6)) {
      dTime = cTime - edgeTime[6];

      if (900 < dTime && dTime < 2200)
      {
        rcValue[6] = dTime;
      }
    }
    else
    {
      edgeTime[6] = cTime;
    }

  // rcValue[7]
  if (mask & 1<<7)
  {
    if (!(pin & 1<<7))
    {
      dTime = cTime - edgeTime[7];

      if (900 < dTime && dTime < 2200)
      {
        rcValue[7] = dTime;
      }
    }
    else
    {
      edgeTime[7] = cTime;
    }
  }
}

// read raw rc data
uint16_t readRawRC(uint8_t chan) {
  uint16_t data;
  uint8_t oldSREG;
  oldSREG = SREG;
    cli();        		    // Let's disable interrupts
  data = rcValue[rcChannel[chan]];  // Let's copy the data Atomically
  SREG = oldSREG;
  sei();        		    // Let's enable the interrupts

  // We return the value correctly copied when the IRQ's where disabled
  return data;
}

// generate rc data
void getRCData() {
  static int16_t rcData4Values[8][4], rcDataMean[8];
  static uint8_t rc4ValuesIndex = 0;
  uint8_t chan, a;

  rc4ValuesIndex++;

  for (chan = 0; chan < 8; chan++)
  {
    rcData4Values[chan][rc4ValuesIndex%4] = readRawRC(chan);
    rcDataMean[chan] = 0;

    for (a=0; a < 4; a++)
    {
      rcDataMean[chan] += rcData4Values[chan][a];
    }

    rcDataMean[chan] = (rcDataMean[chan] + 2) / 4;

    if (rcDataMean[chan] < rcData[chan] - 3)
    {  
      rcData[chan] = rcDataMean[chan] + 2;
    }

    if (rcDataMean[chan] > rcData[chan] + 3)
    {
      rcData[chan] = rcDataMean[chan] - 2;
    }
  }
}
