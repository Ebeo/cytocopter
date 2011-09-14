void getStickInput() {
	rcCommand[ROLL]		= abs(MIDRC - rcData[ROLL]);
	rcCommand[PITCH] 	= abs(MIDRC - rcData[PITCH]);
	rcCommand[YAW]		= abs(MIDRC - rcData[YAW]);
	rcCommand[THROTTLE] = rcData[THROTTLE];
}

void calculateCommands() {
}