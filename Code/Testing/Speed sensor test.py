import time
import datetime
import RPi.GPIO as GPIO

def Int17R ( channel ):
    global Count
    
    Count += 1
    print("Trigger")

GPIO.setmode(GPIO.BCM)

SENSOR = 17

GPIO.setup(SENSOR, GPIO.IN, pull_up_down = GPIO.PUD_OFF)
GPIO.add_event_detect(SENSOR, GPIO.BOTH, callback = Int17R)

Count = 0
while True:
    try:       
        Time = datetime.datetime.now()
        print( "%s - Count = %6d RPM = %6d" % (Time, Count, Count * 60.0))
        RPM = Count * 60.0
        Count = 0
        t = time.time()
        Wait = 1 - (t - int(t))
        time.sleep(Wait)
    except KeyboardInterrupt:
        break
    finally:
        GPIO.cleanup()