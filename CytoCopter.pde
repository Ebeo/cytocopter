#include "Config.h"

/**
 *	Variablen
 */
int16_t	command[4] = {0, 0, 0, 0};

/**
 *	Initialisiert Quad
 */
void setup() {
	// Liesst EEPROM
	
	// Initialisiert RC
	
	// Initialisiert Sensoren
	
	// Initialisiert Motoren und prueft vorher, ob Start erlaubt ist
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
	 *		rcValue[ROLL], rcValue[PITCH], rcValue[YAW], rcValue[THROTTLE]
	 */	 
	//getRCValues();
	
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
	 //checkStickInput();
	 
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