import argparse
import serial
import time

parser = argparse.ArgumentParser(description='Planet command')


parser.add_argument('-u', '--up', dest='pull_up', default=False, action="store_true")
parser.add_argument('-d', '--doww', dest='pull_down', default=False, action="store_true")
args = parser.parse_args()

ser = serial.Serial('/dev/ttyUSB0', 115200)#, timeout=1)
time.sleep(2)
if args.pull_up:
    ser.write(b'+')
    print("up")

if args.pull_down:
    ser.write(b'-')
    print("down")

ser.close()
