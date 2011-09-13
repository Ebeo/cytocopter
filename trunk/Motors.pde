// Legt PWM-Pinbelegung fest
uint8_t PWM_PIN[8] = {9, 10, 11, 3};  // MOTORORDER = 9,10,11,3 aus def.h

/**
 *  Spricht Motoren an, wobei motor[i] den Drehzahlwert des Motors beinhaltet
 *  Der Wert in motor[i] wird /4
 */
void writeMotors() { 
  // Begrenzt [1000;2000] => [125;250]
  analogWrite(PWM_PIN[0], motor[0]>>3);
  analogWrite(PWM_PIN[1], motor[1]>>3);
  analogWrite(PWM_PIN[2], motor[2]>>3);
  analogWrite(PWM_PIN[3], motor[3]>>3);
}

/**
 *  Setzt den Drehzahlwert aller Motoren
 *
 *	@param
 *	  int16_t mc	Drehzahlwert
 */
 void setAllMotors(int16_t mc) {
  motor[0] = mc;
  motor[1] = mc;
  motor[2] = mc;
  motor[3] = mc;
}

/**
 *  Definiert Motorenpins und beschreibt alle Motoren mit 1000 bzw. 125
 */
void initMotors() {
  // Setzt Motorpins
  pinMode(PWM_PIN[0], OUTPUT);
  pinMode(PWM_PIN[1], OUTPUT);
  pinMode(PWM_PIN[2], OUTPUT);
  pinMode(PWM_PIN[3], OUTPUT);
  
  // Setzt alle Motoren = 1000 bzw. 125 nach Verringerung
  setAllMotors(1000);
  writeMotors();
  
  // Warte 300 ms
  delay(300);
}

/**
 * 	Setzt Motordrehzahl anhand RC-Eingabe und Lagekorrektur.
 *  Falls der Copter unarmed ist, setze minimale Drehzahl.
 *
 *  Wird aus MultiWii_18_lite aufgerufen
 */
void updateThrottle() { 
  int16_t maxMotor, diffToMax;
  
  if (armed == 0)
  {
    // Wenn der Copter nicht im Flugmodus ist, setze Motoren auf min. Drehzahl
    setAllMotors(MINCOMMAND);
  }
  else
  {
    // Begrenzt axisPID[YAW] und beugt dadurch "yaw jumps" waehrend der Korrektur vor
    axisPID[YAW] = constrain(axisPID[YAW], -100 - abs(rcCommand[YAW]), +100 + abs(rcCommand[YAW]));
   
    // Setzt Motordrehzahl mit RC-Eingabe und Lagekorrektur
    #define PIDMIX(X, Y, Z) rcCommand[THROTTLE] + axisPID[ROLL] * X + axisPID[PITCH] * Y + YAW_DIRECTION * axisPID[YAW] * Z
	
    motor[0] = PIDMIX(-1, +1, -1); //REAR_R
    motor[1] = PIDMIX(-1, -1, +1); //FRONT_R
    motor[2] = PIDMIX(+1, +1, +1); //REAR_L
    motor[3] = PIDMIX(+1, -1, -1); //FRONT_L
	
	// Pruefe, ob Gasstand hoch genug ist
    if ((rcData[THROTTLE]) < MINCHECK)
    {
	  // Setzt minimale Drehzahl
      #ifndef MOTOR_STOP
	    setAllMotors(MINTHROTTLE);
      #else
        setAllMotors(MINCOMMAND);
      #endif
    }
	else
    {
      // Findet den schnellsten Motor und setzt dessen Wert in maxMotor
      maxMotor = motor[0];
      if (motor[1] > maxMotor) { maxMotor = motor[1]; }
      if (motor[2] > maxMotor) { maxMotor = motor[2]; }
      if (motor[3] > maxMotor) { maxMotor = motor[3]; }
    
      // Falls Motor am Limit ist, wird die Drehzahl des Motors nicht erhoeht, sondern die der anderen reduziert
      if (maxMotor > MAXTHROTTLE)
      {
      	diffToMax = maxMotor - MAXTHROTTLE;
	
        // Reduziert Motorgeschwindigkeit um die Differenz aus maxMotor - MAXTHROTTLE
        motor[0] -= diffToMax;
	    motor[1] -= diffToMax;
	    motor[2] -= diffToMax;
	    motor[3] -= diffToMax;
      }

      // Setze MinDrehzahl
      if (motor[0] < MINTHROTTLE) { motor[0] = MINTHROTTLE; }
      if (motor[1] < MINTHROTTLE) { motor[1] = MINTHROTTLE; }
      if (motor[2] < MINTHROTTLE) { motor[2] = MINTHROTTLE; }
      if (motor[3] < MINTHROTTLE) { motor[3] = MINTHROTTLE; }
    }
  }
  
  // Leite neue Werte weiter
  writeMotors();
}

