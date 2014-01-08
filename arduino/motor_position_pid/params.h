#define motorAPin 12
#define motorBPin 11
#define motorPlusPin 7
#define motorMinusPin 8
#define motorEncoderPin 6

double Kp =  0.0011202,
Kd =  0.000075302,
Ki =  0.00013175,
Tau = 0.00001;
int Fmax = 255;

int conversion = 7162, // 45000/(2*pi) line/rad
period = 100000, 
amplitude = 50000, 
center = 0;

int lastCaller = 0,
moveDirection = 1,
motorPosition = 0;

