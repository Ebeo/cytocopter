/**
 *  Arduino:
 *
 *	pinMode()
 *	analogWrite()
 */

// includes
#include <stdint.h>

// definitions
#define MOTORPINS		9, 10, 11, 3
#define MINTHROTTLE		1000
#define	MAXTHROTTLE		2000

// prototypes
void initializeMotors(void);
void setMotorSpeed(int16_t, uint8_t);
void setAllMotorSpeed(int16_t);
void contrainMotorSpeed(void);
void writeMotors(void);

// variables
uint8_t PWM_PIN[4] = {MOTORPINS};
int16_t motor[4];

/**
 *  Initializes all motors with MINTHROTTLE
 */
void initializeMotors(void)
{
	// set analog pins
	pinMode(PWM_PIN[0], OUTPUT);
	pinMode(PWM_PIN[1], OUTPUT);
	pinMode(PWM_PIN[2], OUTPUT);
	pinMode(PWM_PIN[3], OUTPUT);
	
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
	
	// writes PWN to motors
	analogWrite(PWM_PIN[0], motor[0]>>3);
	analogWrite(PWM_PIN[1], motor[1]>>3);
	analogWrite(PWM_PIN[2], motor[2]>>3);
	analogWrite(PWM_PIN[3], motor[3]>>3);
}
