import argparse
import serial
import time
import os
import urwid


def update_ip(ip):
    print(ip)
    f = open(os.path.expanduser("~/.ipPortia.txt"),'w')
    f.write(ip)
    f.close()

'''
import urwid

palette = [('I say', 'default,bold', 'default', 'bold'),]
ask = urwid.Edit(('I say', u"What is your name?\n"))
reply = urwid.Text(u"")
button = urwid.Button(u'Exit')
div = urwid.Divider()
pile = urwid.Pile([ask, div, reply, div, button])
top = urwid.Filler(pile, valign='top')

def on_ask_change(edit, new_edit_text):
    reply.set_text(('I say', u"Nice to meet you, %s" % new_edit_text))

def on_exit_clicked(button):
    raise urwid.ExitMainLoop()

urwid.connect_signal(ask, 'change', on_ask_change)
urwid.connect_signal(button, 'click', on_exit_clicked)

urwid.MainLoop(top, palette).run()
'''
parser = argparse.ArgumentParser(description='Planet command')
#parser.add_argument('-u', '--up', dest='pull_up', default=False, action="store_true")
#parser.add_argument('-d', '--doww', dest='pull_down', default=False, action="store_true")
#args = parser.parse_args()
login_in = False

ser = serial.Serial('/dev/ttyUSB2', 115200)#, timeout=1)
time.sleep(1)
try:
    while 1:
        #pass
        #ser.write(b'+')
        #print(ser.readline())
        try:
            line_read = str(ser.readline().rstrip(),"utf-8")
            print(line_read)
            #ser.write(b'')
            if ("login" in line_read ):
                #print ("root")
                ser.write(b'root\n')
            elif ( "Password" in line_read ):
                #print ("a")
                ser.write(b'a\n')
                login_in = True

            elif ( "Sending select for " in line_read ):
                ip = line_read.split("Sending select for")[1].split("...")[0].strip()
                update_ip(ip)

            if login_in:
                #ser.write(b'reboot\n')
                login_in = False
        except:
            pass

        #print(line_read)

except KeyboardInterrupt:
    ser.write(b'reboot\n')
    print("########BOOOOOM#########")

finally:
    ser.close()


