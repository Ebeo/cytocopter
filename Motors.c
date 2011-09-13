/*
 * Motors.c
 *
 * Created: 13.09.2011 17:48:31
 *  Author: admin
 */ 
/**
	Arduino pins to AVR port+bit
	digital
	0 	PORTD,0
	1 	PORTD,1
	2 	PORTD,2
	3 	PORTD,3
	4 	PORTD,4
	5 	PORTD,5
	6 	PORTD,6
	7 	PORTD,7
	8 	PORTB,0
	9 	PORTB,1
	10 	PORTB,2
	11 	PORTB,3
	12 	PORTB,4
	13 	PORTB,5
	analog
	0 	PORTC,0
	1 	PORTC,1
	2 	PORTC,2
	3 	PORTC,3
	4 	PORTC,4
	5 	PORTC,5
	
	#define MOTORPINS		9, 10, 11, 3
*/

// includes
#include <avr/io.h>
#include <stdint.h>

// definitions
#define MINTHROTTLE		1000
#define	MAXTHROTTLE		2000

// prototypes
void initializeMotors(void);
void setMotorSpeed(int16_t, uint8_t);
void setAllMotorSpeed(int16_t);
void contrainMotorSpeed(void);
void writeMotors(void);

// variables
int16_t motor[4];

/**
 *  Initializes all motors with MINTHROTTLE
 */
void initializeMotors(void)
{
	// set analog pins
	DDRB |= _BV(1);		// pinMode(9, OUTPUT);
	DDRB |= _BV(2);		// pinMode(10, OUTPUT);
	DDRB |= _BV(3);		// pinMode(11, OUTPUT);
	DDRD |= _BV(3);		// pinMode(3, OUTPUT);
	
	// set min speed
	setAllMotorSpeed(MINTHROTTLE);
	
	// start engines
	writeMotors();
}


/**
 *  Sets motor speed for a single motors
 *
 *	@param
 *		int16_t speed	motor speed
 *		int8_t	num		motor number [0;4]
 */
void setMotorSpeed(int16_t speed, uint8_t num)
{
	motor[num] = speed;
}

/**
 *  Sets motor speed for all motors
 *
 *	@param
 *		int16_t speed	motor speed
 */
void setAllMotorSpeed(int16_t speed)
{
	motor[0] = speed;
	motor[1] = speed;
	motor[2] = speed;
	motor[3] = speed;
}

/**
 *  Limits motor speed to [MINTHROTTLE;MAXTHROTTLE] while
 *	keeping up proportion between them
 */
void contrainMotorSpeed(void)
{
	int16_t minSpeed = motor[0];
	int16_t maxSpeed = motor[0];
	int16_t diffToMin, diffToMax;
	
	// find slowest motor
	if (motor[1] < minSpeed) { minSpeed = motor[1];	}
	if (motor[2] < minSpeed) { minSpeed = motor[2];	}
	if (motor[3] < minSpeed) { minSpeed = motor[3];	}
	
	// find fastest motor
	if (motor[1] > maxSpeed) { maxSpeed = motor[1];	}
	if (motor[2] > maxSpeed) { maxSpeed = motor[2];	}
	if (motor[3] > maxSpeed) { maxSpeed = motor[3];	}
	
	// limit min speed
	if (minSpeed < MINTHROTTLE)
	{
		diffToMin = MINTHROTTLE - minSpeed;
		
		motor[0] = motor[0] + diffToMin;
		motor[1] = motor[1] + diffToMin;
		motor[2] = motor[2] + diffToMin;
		motor[3] = motor[3] + diffToMin;
	}
	
	// limit max speed
	if (maxSpeed > MAXTHROTTLE)
	{
		diffToMax = maxSpeed - MAXTHROTTLE;
		
		motor[0] = motor[0] - diffToMax;
		motor[1] = motor[1] - diffToMax;
		motor[2] = motor[2] - diffToMax;
		motor[3] = motor[3] - diffToMax;
	}
}

/**
 *  Updates PWM-output
 */
void writeMotors(void)
{
	// contrain to [MINTHROTTLE;MAXTHROTTLE]
	contrainMotorSpeed();

	// analogWrite(9, motor[0]>>3);
	TCCR1A |= _BV(COM1A1);
	OCR1A = motor[0]>>3;
	
	// analogWrite(10, motor[1]>>3);
	TCCR1A |= _BV(COM1B1);
	OCR1B = motor[1]>>3;
	
	// analogWrite(11, motor[2]>>3);
	TCCR2A |= _BV(COM2A1);
	OCR2A = motor[2]>>3;
	
	// analogWrite(3, motor[3]>>3);
	TCCR2A |= _BV(COM2B1);
	OCR2B = motor[3]>>3;
}
