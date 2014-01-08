#define motorAPin 12
#define motorBPin 11
#define motorPlusPin 6
#define motorMinusPin 5
#define motorEncoderPin 4
#define rssiPin 8

double Kp =  0.0011202*20,
Kd =  0.000075302*10,
Ki =  0.00013175,
Tau = 0.00001;
int Fmax = 255;

int conversion = 7162, // 45000/(2*pi) line/rad
period = 150000*2, 
amplitude = 45000/6, 
center = 0;

int lastCaller = 0,
moveDirection = 1,
motorPosition = 0,
rssiVal,
lastLeastVal = 100,
stopMoving = 0;

// pid values
int integrator, ydot, error_d1, y_d1;

