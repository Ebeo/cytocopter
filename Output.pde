#define MOTOR1	0
#define MOTOR2	1
#define MOTOR3	2
#define MOTOR4	3

int16_t output[4];

void calculateThrottle(void)
{	
	// Setzt Motordrehzahl mit RC-Eingabe und Lagekorrektur
	#define PIDMIX(X, Y, Z) command[THROTTLE] + command[ROLL] * X + command[PITCH] * Y + YAW_DIRECTION * command[YAW] * Z
	
	output[0] = PIDMIX(-1, +1, -1); // REAR	 RIGHT
	output[1] = PIDMIX(-1, -1, +1); // FRONT RIGHT
	output[2] = PIDMIX(+1, +1, +1); // REAR  LEFT
	output[3] = PIDMIX(+1, -1, -1); // FRONT LEFT
}

void outputMotors(void)
{
	// calculates speed
	calculateThrottle();
	
	// set new speed
	setMotorSpeed(output[0], MOTOR1);
	setMotorSpeed(output[1], MOTOR2);
	setMotorSpeed(output[2], MOTOR3);
	setMotorSpeed(output[3], MOTOR4);
	
	// update motor throttle
	writeMotors();
}