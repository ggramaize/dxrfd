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
 * To provide a debian-compatible init script, with PID tracking (TODO)

Some bonuses if I'm motivated/have free time:
 * Adding the option to run this program as a daemon
 * Autotooling the build process?
 * Automatic init system probing
 * Logging in /var/log/dxrfd 
 * Providing selinux modules
 * Packaging the software for Debian 

## Building dxrfd
All instructions are to be executed as user ID root.
The original program was assumed to run on a CentOS Linux box

1. Get the source code either by downloading the zip file or by cloning the repository.
2. Get the build essentials: (g++, make), if .
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

