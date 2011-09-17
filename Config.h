/**
 *	Configuration
 */
#define MINTHROTTLE		1150			 // minimal throttle
#define	MAXTHROTTLE		2000			// maximal throttle
#define MOTORPINS		9, 10, 11, 3  // motor pins

#define MINCOMMAND		1000			  // minimal rc throttle command
#define MAXCOMMAND		2000			  // maximal rc throttle command
#define MIDRC 1500						    // rc middle position

#define YAW_DIRECTION	1				  // yaw inverted?


/**
 *	Definitions
 */
#define ROLL       				0
#define PITCH      				1
#define YAW        				2
#define THROTTLE   				3

//RX PIN assignment inside the port //for PORTD
#define THROTTLEPIN				2
#define ROLLPIN					  4
#define PITCHPIN				   5
#define YAWPIN					   6
#define AUX1PIN					  7
#define AUX2PIN					  7   // unused just for compatibility with MEGA
#define CAM1PIN				  	7   // unused just for compatibility with MEGA
#define CAM2PIN					  7   // unused just for compatibility with MEGA
