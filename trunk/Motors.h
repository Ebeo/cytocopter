#ifndef Motors_H
#define Motors_H

#include "WProgram.h"

class Motors
{
private:
  int16_t motor[4];
  uint8_t PWM_PINS[4];  
  void contrainMotorSpeed(void);

public:
  Motors();
  void setMotorSpeed(int16_t speed, uint8_t num);
  void writeMotors(void);
  void initializeMotors(void);
};

#endif


