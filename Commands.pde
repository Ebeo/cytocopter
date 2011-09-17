/**
 *  calculates real rc commands
 */
void getStickInput() {
  // calculates difference to rc middle
  rcCommand[ROLL]  = rcData[ROLL]  - MIDRC;
  rcCommand[PITCH] = rcData[PITCH] - MIDRC;
  rcCommand[YAW]   = rcData[YAW]   - MIDRC;

  // limits throttle to [MINTHROTTLE;MAXTHROTTLE]
  rcCommand[THROTTLE] = MINTHROTTLE + (int32_t)(MAXTHROTTLE - MINTHROTTLE) * (rcData[THROTTLE] - MINCOMMAND) / (MAXCOMMAND - MINCOMMAND);
}

/**
 *  PID
 */
void calculateCommands() {
  // for test purposes
  command[THROTTLE] = rcCommand[THROTTLE];
}

