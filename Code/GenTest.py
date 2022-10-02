import trainerProperties

mydata = 0x0000


MORE_DATA = bool(0)
AVERAGE_SPEED = bool(0)
INSTANTANIOUS_CADENCE = True

value = [1,2,2,4]

in_spd = 0
av_spd = 0
in_cad = 0
av_cad = 0
in_pow = 1
av_pow = 0

mydata |= av_spd << 1
mydata |= in_cad << 2
mydata |= av_cad << 3
mydata |= in_pow << 6
mydata |= av_pow << 7 

print(bin(mydata))

print(value)