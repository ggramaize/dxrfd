# dxrfd
Open Source G2 DSTAR Reflectors (XRF reflectors)

## About this fork
The purpose of this fork is to repackage properly this software.

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
 * Providing selinux modules 

So far, this repo is _not_ production ready. Check back later for updates.

Last update: 2015-10-25 07:10 UTC

