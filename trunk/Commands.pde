void getStickInput() {
	// calculates difference to rc middle
	rcCommand[ROLL]		= abs(MIDRC - rcData[ROLL]);
	rcCommand[PITCH] 	= abs(MIDRC - rcData[PITCH]);
	rcCommand[YAW]		= abs(MIDRC - rcData[YAW]);
	
	// Limits throttle to [MINTHROTTLE;MAXTHROTTLE]
	rcCommand[THROTTLE] = MINTHROTTLE + (int32_t)(MAXTHROTTLE - MINTHROTTLE) * (rcData[THROTTLE] - MINCOMMAND) / (MAXCOMMAND - MINCOMMAND);
}

void calculateCommands() {
}