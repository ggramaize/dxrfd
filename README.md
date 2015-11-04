# dxrfd
Open Source G2 DSTAR Reflectors (XRF reflectors)

So far, this repo is _not_ production ready. Check back later for updates.

Last update: 2015-10-25 07:10 UTC

## About this fork
The purpose of this fork is to properly repackage this software.

The major objectives are:
 * To provide a proper Makefile instead of the 'doit' files (done)
 * To strengthen the build of the binaries by adding Hardened build flags (done)
 * To remove the need to run the program as root (done)
 * To provide an install procedure based on make (WIP)
 * To provide an uninstall procedure based on make (WIP)
 * To provide a systemd service file (done)
 * To provide a debian-compatible init script, with PID tracking (done)

Some bonuses if I'm motivated/have free time:
 * Adding an Apache config file for the reflector web interface (WIP)
 * Adding the option to run this program as a daemon
 * Autotooling the build process?
 * Automatic init system probing
 * Logging in /var/log/dxrfd 
 * Providing selinux modules
 * Providing an ncurses-based configuration utility
 * Packaging the software for Debian 

## Building dxrfd
All instructions are to be executed as user ID root.
The original program was assumed to run on a CentOS Linux box

1. Get the source code either by downloading the zip file or by cloning the repository.
2. Get the build essentials: (g++, make).
3. Build the binaries by running 'make all'

## Installing dxrfd
Now you will configure the dxrfd service. Execute the following command as root:

> make install

If you are on a Red Hat-like box with the SystemV init, run this command:

> make svcinst_rhsysv

If you are on a Debian-like box with the SystemV init, run this one:

> make svcinst_debsysv

If you are on a systemd linux box, run this one:

> make svcinst_systemd

## Setting up dxrfd
To setup the Dstar reflector, edit /srv/dxrfd/dxrfd.cfg

Set the OWNER value. The OWNER value is the callsign of the DSTAR Reflector.
It must start with the letters XRF and followed by 3 digits which identify the
Reflector number.

Set the ADMIN value to be your personal callsign.

Set the MAX_USERS value to an appropriate number.
That is the maximum numnber of Dstar Gateways that can link to your Reflector.

Set the MAX_OTHER_USERS value to an appropriate number.
That is the maximum number of dongle/user connections(dvTool, dvapTool, ...)

Leave the other options the way they are.

The file blocks.txt can contain user callsigns or repeater callsigns that are
being blocked. These callsigns will be denied access by the reflector.

## Setting up your network
The following ports must be opened (and forwarded if you're behind a NAPT device):

* UDP/20001, is used to accept connections from dongles and/or users.
* UDP/30001, is used to accept connections from repeater links.

## Controlling dxrfd using shell commands
dxrfd server software can be controlled from the shell using netcat(nc) 
commands on Linux.

In dxrfd.cfg there is a COMMAND_PORT that is used to gain access to either
software.

The default COMMAND_PORT for dxrfd is COMMAND_PORT=30002 as listed in dxrfd.cfg

The following commands can be sent to dxrfd from 
within netcat(nc) for Linux.

First start netcat by executing this command:   nc  -u  127.0.0.1  30002

Note: In the above netcat command, we use local IP address 127.0.0.1  because
we have set: LISTEN_IP=0.0.0.0 in dxrfd.cfg.

After you executed the above netcat command, nc will wait there for you to type
a specific sub-command.
The sub-commands that you can use are listed below:

| Command   | Role                                |
|-----------|-------------------------------------|
| pu        | print users                         |
| mu        | mute users                          |
| uu        | unmute users                        |
| pl        | print links                         |
| sh        | shut it down                        |
| pb        | print blocked callsigns             |
| ab KI4LKF | add a block on KI4LKF               |
| rb KI4LKF | remove the block on KI4LKF          |
| mc KI4LKF | mute the callsign KI4LKF            |
| uc KI4LKF | unmute the callsign KI4LKF          |
| qsoy      | qso details set to YES              |
| qson      | qso details set to NO               |
| pv        | print the current software version  |


Here is an example of the output of the command pu

   nc -u  127.0.0.1  30002
   pu

   KJ4NHF  ,1.2.3.4,REPEATER,062909,22:43:23,notMuted

Notes:
The above 3 lines are explaied as follows:
The first 2 lines, is what you typed.
The third line is the reply back from your XRF reflector.

After you get the reply from the XRF reflector, you can choose to type another
sub-command or you can choose to hit Control-C on the keyboard to exit the 
netcat and return back to the Linux prompt.

The third line says that the connected item is a LINKED dstar Repeater and it 
was linked at 062909,22:43:23  

The status file for dxrfd is XRF_STATUS.txt which lists all the links for the 
5 reflector modules if any module is linked.

## Displaying the dstar reflector activity on your web site
This repository natively embeds an apache configuration file. This file sets up
an alias to display the web interface on /xrf.

The web page refresh script is still in WIP.
