import RPi.GPIO as GPIO
import time
import threading

class SpeedSensor:

    def __init__(self, pin, segments, debounce_ms):
        self.pin = pin
        self.segments = segments
        self.debounce = debounce_ms
        self.Count = 0

        GPIO.setup(self.pin, GPIO.IN, pull_up_down = GPIO.PUD_OFF)
        GPIO.add_event_detect(self.pin, GPIO.BOTH, self.add_Detect(self)) 

    def add_Detect(self):
        self.Count += 1

    def get_RPM(self):
        period = time.time() - self.lastRead
        rpm = spd*60/(period*self.segments)
        return rpm

class FrontSensor(SpeedSensor):
    GPIO_pin = 27
    WHEEL_segments = 10
    debounce = 20
    def __init__(self):
        SpeedSensor.__init__(self,self.GPIO_pin,self.WHEEL_segments,self.debounce)

# Speed sensor GPIO pins
SPD_PIN_R = 17
SPD_R_DB = 40
SPD_F_SGMNTS = 10
SPD_R_SGMNTS = 60

SPD_PERIOD = 0.5

GPIO.setmode(GPIO.BCM)

GPIO.setup(SPD_PIN_F, GPIO.IN, pull_up_down = GPIO.PUD_OFF)
GPIO.setup(SPD_PIN_R, GPIO.IN, pull_up_down = GPIO.PUD_OFF)

def spd_F_cb(channel):
    global SPD_F_COUNT
    SPD_F_COUNT += 1

def spd_R_cb(channel):
    global SPD_R_COUNT
    SPD_R_COUNT += 1

    GPIO.add_event_detect(SpeedSensor_Front.GPIO_Pin, GPIO.BOTH, self.)


#PrevTime = time.time()
PrevDisplay = time.time()
while True:
    
GPIO.cleanup()