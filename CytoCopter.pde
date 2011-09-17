#include "Config.h"
#include "Motors.h"

/**
 *  variables
 */
int16_t rcData[8] = {0, 0, 0, 0, 0, 0, 0, 0};
int16_t heading = 0;
int16_t angle[2] = {0, 0};
int16_t altitude = 0;
int16_t rcCommand[4] = {0, 0, 0, 0};
int16_t	command[4] = {0, 0, 0, 0};

Motors engine = Motors();

/**
 *  initializes quad
 */
void setup() {
  // read EEPROM
  //readEEPROMData();			// EEPROM.pde

  // initialize RC
  initializeReceiver();			// RC.pde

  // initialize sensors
  //initializeSensors();		// Sensors.pde

  // wait 5 seconds to not get hurt by motors ;)
  delay(5000);

  // start motors with MINTHROTTLE
  engine.initializeMotors();		// Motors.pde
}


/**
 *  ...
 */
void loop() {
  /**
   *  get RC data
   *
   *    returns:
   *      rcData[ROLL], rcData[PITCH], rcData[YAW], rcData[THROTTLE]
   */
  getRCData();				// RC.pde

  /**
   *  get IMU data
   *
   *    returns:
   *      heading, angle[ROLL], angle[PITCH], altitude
   */
  //getYawPitchRoll(yawpitchroll);	// IMU.pde

  /**
   *  check if there is an input
   *
   *    returns:
   *      rcCommand[ROLL], rcCommand[PITCH], rcCommand[YAW], rcCommand[THROTTLE]
   */
  getStickInput();			// Commands.pde

  /**
   *  attitude and generate commands out of rc commands and attitude
   *
   *    returns:
   *      command[ROLL], command[PITCH], command[YAW], command[THROTTLE]
   */
  calculateCommands();		        // Commands.pde

  /**
   *  refresh motors
   */
  outputMotors();			// Output.pde
}

