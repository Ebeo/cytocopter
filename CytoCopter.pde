#include "Config.h"

/**
 *	Variablen
 */
int16_t	command[4]	 = {0, 0, 0, 0};
int16_t rcData[8]	 = {0, 0, 0, 0, 0, 0, 0, 0};
int16_t rcCommand[4] = {0, 0, 0, 0};


/**
 *	Initialisiert Quad
 */
void setup() {
	// Liesst EEPROM
	
	// Initialisiert RC
	initializeReceiver();
	
	// Initialisiert Sensoren
	
	// Warte 5 Sekunden
	delay(5000);
	
	// Initialisiert Motoren und prueft vorher, ob Start erlaubt ist
	initializeMotors();
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
	getRCData();
	
	/**
	 *	Holt IMU-Daten
	 *
	 *	Liefert:
	 *		heading, angle[ROLL], angle[PITCH], altitude
	 */
	 //getIMUData();
	
	/***********************************************************************************
	 *	Checks																  	       *
	 **********************************************************************************/

	/**
	 *	Ueberprueft, ob manueller Steuerbefehl einging
	 *
	 *	Liefert:
	 *		rcCommand[ROLL], rcCommand[PITCH], rcCommand[YAW], rcCommand[THROTTLE]
	 */
	 getStickInput();
	 
	/***********************************************************************************
	 *	Calculation																  	   *
	 **********************************************************************************/
	
	/**
	 *	Aktualisiert anhand von alter Fluglage und Input
	 *
	 *	Liefert:
	 *		command[ROLL], command[PITCH], command[YAW], command[THROTTLE]
	 */
	//calculateCommands();
	 
	/***********************************************************************************
	 *	Output																	  	   *
	 **********************************************************************************/
	
	/**
	 *	Gibt Throttle an Motoren weiter
	 */
	outputMotors();	
}