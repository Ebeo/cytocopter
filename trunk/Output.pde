// definitions
#define MOTOR1	0
#define MOTOR2	1
#define MOTOR3	2
#define MOTOR4	3

// variables
int16_t output[4];

// generates output speed
void calculateThrottle(void)
{	
  // combines throttle with commands
  #define PIDMIX(X, Y, Z) command[THROTTLE] + command[ROLL] * X + command[PITCH] * Y + YAW_DIRECTION * command[YAW] * Z

  output[0] = PIDMIX(-1, +1, -1); // REAR  RIGHT
  output[1] = PIDMIX(-1, -1, +1); // FRONT RIGHT
  output[2] = PIDMIX(+1, +1, +1); // REAR  LEFT
  output[3] = PIDMIX(+1, -1, -1); // FRONT LEFT
}

/**
 *  sets the engines
 */
void outputMotors(void)
{
  // calculates speed
  calculateThrottle();

  // set new speed
  engine.setMotorSpeed(output[0], MOTOR1);
  engine.setMotorSpeed(output[1], MOTOR2);
  engine.setMotorSpeed(output[2], MOTOR3);
  engine.setMotorSpeed(output[3], MOTOR4);

  // update motor throttle
  engine.writeMotors();
}
