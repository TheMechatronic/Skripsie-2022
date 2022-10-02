import RPi.GPIO as GPIO
import time
from threading import Event, Thread

class RepeatedTimer:

    """Repeat `function` every `interval` seconds."""

    def __init__(self, interval, function, *args, **kwargs):
        self.interval = interval
        self.function = function
        self.args = args
        self.kwargs = kwargs
        self.start = time.time()
        self.event = Event()
        self.thread = Thread(target=self._target)
        self.thread.start()

    def _target(self):
        while not self.event.wait(self._time):
            self.function(*self.args, **self.kwargs)

    @property
    def _time(self):
        return self.interval - ((time.time() - self.start) % self.interval)

    def stop(self):
        self.event.set()
        self.thread.join()


FrontPin = 27
RearPin = 17

FrontSegments = 10
RearSegments = 60

FrontCount = 0
RearCount = 0

FrontRPM = 0
RearRPM = 0
LastCalc = 0
LastPrint = 0

def my_callback_Front(channel):
    FrontCount += 1

def my_callback_Rear(channel):
    RearCount += 1

GPIO.setmode(GPIO.BCM)

GPIO.setup(FrontPin, GPIO.IN, pull_up_down = GPIO.PUD_OFF)
GPIO.setup(RearPin, GPIO.IN, pull_up_down = GPIO.PUD_OFF)

GPIO.add_event_detect(FrontPin, GPIO.BOTH, my_callback_Front)    
GPIO.add_event_detect(FrontPin, GPIO.BOTH, my_callback_Rear)

def SpeedCalc():
    LastCalc = time.time()
    Period = time.time() - LastCalc
    FrontRPM = 60 * FrontCount / (FrontSegments * Period)
    RearRPM = 60 * RearCount / (RearSegments * Period)
    FrontCount = 0
    RearCount = 0

speedTimer = RepeatedTimer(0.5, SpeedCalc, [])

while True:
    try: 
        if LastPrint > (time.time() + 5):
            LastPrint = time.time()
            print('Front RPM:' + repr(FrontRPM))
            print('Rear RPM:' + repr(RearRPM))
    finally:
        speedTimer.stop
        GPIO.cleanup()