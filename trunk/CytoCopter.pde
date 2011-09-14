#include "Config.h"

/**
 *	Variablen
 */
// input
int16_t rcData[8]	 = {0, 0, 0, 0, 0, 0, 0, 0};
int16_t heading = 0;
int16_t	angle[2] = {0, 0};
in16_t altitude = 0;

// checks
int16_t rcCommand[4] = {0, 0, 0, 0};

// calculations
int16_t	command[4]	 = {0, 0, 0, 0};




/**
 *	Initialisiert Quad
 */
void setup() {
	// Liesst EEPROM
	//readEEPROMData();					// EEPROM.pde
	
	// Initialisiert RC
	initializeReceiver();				// RC.pde
	
	// Initialisiert Sensoren
	//initializeSensors();				// Sensors.pde
	
	// Warte 5 Sekunden
	delay(5000);
	
	// Startet Motoren
	initializeMotors();					// Motors.pde
}


/**
 *	...
 */
void loop() {
	/***********************************************************************************
	 *	Input																		   *
	 **********************************************************************************/
	
	/**
	 *	Holt RC-Daten
	 *
	 *	Liefert:
	 *		rcData[ROLL], rcData[PITCH], rcData[YAW], rcData[THROTTLE]
	 */	 
	getRCData();						// RC.pde
	
	/**
	 *	Holt IMU-Daten
	 *
	 *	Liefert:
	 *		heading, angle[ROLL], angle[PITCH], altitude
	 */
	 //getIMUData();					// IMU.pde
	
	/***********************************************************************************
	 *	Checks																  	       *
	 **********************************************************************************/

	/**
	 *	Ueberprueft, ob manueller Steuerbefehl einging
	 *
	 *	Liefert:
	 *		rcCommand[ROLL], rcCommand[PITCH], rcCommand[YAW], rcCommand[THROTTLE]
	 */
	 getStickInput();					// Commands.pde
	 
	/***********************************************************************************
	 *	Calculation																  	   *
	 **********************************************************************************/
	
	/**
	 *	Aktualisiert anhand von alter Fluglage und Input
	 *
	 *	Liefert:
	 *		command[ROLL], command[PITCH], command[YAW], command[THROTTLE]
	 */
	//calculateCommands();				// Commands.pde
	 
	/***********************************************************************************
	 *	Output																	  	   *
	 **********************************************************************************/
	
	/**
	 *	Gibt Throttle an Motoren weiter
	 */
	outputMotors();						// Output.pde
}