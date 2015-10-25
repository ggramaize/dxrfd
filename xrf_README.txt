Open Source G2 DSTAR Reflectors(XRF reflectors)
==============================================
dxrfd is the software to use to create
a D-Star reflector. It will run on any Linux box.
It communicates with dstar Gateways/repeaters
and it also communicates with dvap,dvtool,... users.
Add udp port 30001 to your router, port 30001 is for REPEATER links.
Add udp port 20001 to your router, port 20001 is for dongle/user connections.

Note: For Dstar gateways/repeaters, we recommend the use of g2_link linking software
      (included in our g2_ircddb Gateway software or g2_ccs Gateway software)
      located under the G2_LINK directory posted on our site,
      to use to link the Dstar Gateway/repeater to the Dstar reflector.

Note:  To connect as a dongle/hotspot/user to the Dstar reflector, we recommend
       to use hotspot r2g2_p(posted on our site) or DVTool/DVAPTool(posted on our site).

Note: You can NOT run both the Reflector and the G2 Gateway/repeater on the same Linux box.
The Reflector and the Gateway must have a different PUBLIC ip address.
That is the same for REF reflectors.

BUILDING dxrfd
==============
All instructions are to be executed as user ID root.
We will assume that the installation is on a CentOS Linux box

1)
Download dxrfd.zip

Create an empty directory under the root directory:   /root/dxrfd
Unpack zrf.zip into /root/dxrfd directory

    unzip  dxrfd.zip

2)
Install/update the C++ compiler with the command:

     yum install gcc-c++

3)
Go to /root/dxrfd directory and execute the following commands:

  chmod  +x  *.doit

  ./dxrfd.doit

  ./xrf_lh.doit


You should have these binary programs at this point:

dxrfd
xrf_lh

SETUP 
=====
To setup the Dstar reflector, edit dxrfd.cfg configuration file.

Set the OWNER value. The OWNER value is the callsign of the DSTAR Reflector.
It must start with the letters XRF and followed by 3 digits which identify the
Reflector number.

Set the ADMIN value to be your personal callsign.

Set the MAX_USERS value to an appropriate number.
That is the maximum numnber of Dstar Gateways that can link to your Reflector.

Set the MAX_OTHER_USERS value to an appropriate number.
That is the maximum number of dongle/user connections(dvTool, dvapTool, ...)

Leave the other options the way they are.

The file blocks.txt can contain user callsigns or repeater callsigns
that are being blocked. These callsigns will be denied access by the reflector.

Now you will configure the dxrfd Linux service:
Execute these commands:

    chmod +x dxrfd.SVC
    mv dxrfd.SVC /etc/init.d/dxrfd
    chkconfig --add dxrfd
    chkconfig dxrfd on

Now, start the Linux service dxrfd with the command:   service  dxrfd  start

The log file is /var/log/dxrfd.log

Check that it is running with the command:  service  dxrfd  status

CONTROLLING dxrfd using shell commands
==============================================================
dxrfd server software can be controlled
from the shell using netcat(nc) commands on Linux

In dxrfd.cfg there is a
COMMAND_PORT that is used to gain access to either software.

The default COMMAND_PORT for dxrfd is COMMAND_PORT=30002
as listed in dxrfd.cfg

The following commands can be sent to dxrfd from 
within netcat(nc) for Linux.

First start netcat by executing this command:   nc  -u  127.0.0.1  30002

Note: In the above netcat command, 
we use local IP address 127.0.0.1  because in dxrfd.cfg, we have set: LISTEN_IP=0.0.0.0

After you executed the above netcat command, nc will wait there for you to type a specific sub-command.
The sub-commands that you can use are listed below:

pu                   "print users"
mu                   "mute users"
uu                   "unmute users"
pl                   "print links"
sh                   "shut it down"
pb                   "print blocked callsigns"
ab KI4LKF            "add a block on KI4LKF"
rb KI4LKF            "remove the block on KI4LKF"
mc KI4LKF            "mute the callsign KI4LKF"
uc KI4LKF            "unmute the callsign KI4LKF"
qsoy                 "qso details set to YES"
qson                 "qso details set to NO"
pv                   "print the current software version"


Here is an example of the output of the command pu

   nc -u  127.0.0.1  30002
   pu

   KJ4NHF  ,1.2.3.4,REPEATER,062909,22:43:23,notMuted

Notes:
The above 3 lines are explaied as follows:
The first 2 lines, is what you typed.
The third line is the reply back from your XRF reflector.

After you get the reply from the XRF reflector, you can choose to type another sub-command
or you can choose to hit Control-C on the keyboard to exit the netcat and return back to the Linux prompt.

The third line says that the connected item is a LINKED dstar Repeater and it was linked at 062909,22:43:23  

The status file for dxrfd is XRF_STATUS.txt
which lists all the links for the 5 reflector modules if any module is linked.

DISPLAYING the dstar reflector activity on your web site
=========================================================
First go to the HTML directory of your web server.
That directory is usually /var/www/html/
Note:  On some Web servers, the HTML directory is /var/www/
Under the HTML directory of your web server, create a sub-directory g2_ircddb
Under that sub-directory g2_ircddb, place the files:  mm_spacer.gif and mm_training.css

Now go to the directory where you installed dxrfd.
Use the program xrf_lh as follows, by executing it like this:
   ./xrf_lh  1NFO  ReflectorCallsign  description  127.0.0.1  >  status.html

Example: (We use a local XRF reflector XRF999 for testing )
   ./xrf_lh  1NFO  XRF999  "testing"  127.0.0.1  > status.html

You can take the generated status.html file and place it under the HTML directory
of your web server.
To make things fast and simple, you can add this line to your CRONTAB (for root)

*/2  *  *  *  *  /root/dxrfd/xrf_lh  1NFO  XRF999  "testing"  127.0.0.1  >/var/www/html/XRF999_status.html   2>/dev/null

The above line tells your CRON Linux service to execute the xrf_lh every 2 minutes.
That means that your dashboard for the XRF999 reflector will be created every 2 minutes.

73
KI4LKF
