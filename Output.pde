int16_t output[4];

void calculateThrottle(void)
{	
	// Setzt Motordrehzahl mit RC-Eingabe und Lagekorrektur
	#define PIDMIX(X, Y, Z) command[THROTTLE] + command[ROLL] * X + command[PITCH] * Y + YAW_DIRECTION * command[YAW] * Z
	
	output[0] = PIDMIX(-1, +1, -1); //REAR_R
	output[1] = PIDMIX(-1, -1, +1); //FRONT_R
	output[2] = PIDMIX(+1, +1, +1); //REAR_L
	output[3] = PIDMIX(+1, -1, -1); //FRONT_L
}

void outputMotors(void)
{
	// calculates speed
	calculateThrottle();
	
	// set new speed
	setMotorSpeed(output[0], 0);
	setMotorSpeed(output[1], 1);
	setMotorSpeed(output[2], 2);
	setMotorSpeed(output[3], 3);
	
	// update motor throttle
	writeMotors();
}