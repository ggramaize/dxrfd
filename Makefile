# Build flags
CXX      = g++
CXXFLAGS = -W -Wall -g -lrt -D_FORTIFY_SOURCE=2 -Werror=format-security -fstack-protector-strong -fPIE -pie

# Install flags
DXRFD_USER=dxrfd
DXRFD_HOME=/srv/dxrfd
prefix=/usr/bin

# Targets 

all: dxrfd xrf_lh

dxrfd: dxrfd.cpp
	$(CXX) $(CXXFLAGS) -pthread $^ -o $@

xrf_lh: xrf_lh.cpp
	$(CXX) $(CXXFLAGS) $^ -o $@

.PHONY: clean
clean:
	rm -f dxrfd xrf_lh

#.PHONY: install
#install: all
#	adduser $(DXRFD_USER) --system --disabled-login --home $(DXRFD_HOME)
#	install -m 0755 dxrfd $(prefix)/dxrfd
#	install -m 0755 xrf_lh $(prefix)/xrf_lh
#	install -m 0644 -o $(DXRFD_USER) -g $(DXRFD_USER) blocks.txt $(DXRFD_HOME)/blocks.txt
#	install -m 0644 -o $(DXRFD_USER) -g $(DXRFD_USER) xrfs.txt $(DXRFD_HOME)/xrfs.txt
#	install -m 0644 -o $(DXRFD_USER) -g $(DXRFD_USER) xrf_README.txt $(DXRFD_HOME)/xrf_README.txt
#
#.PHONY: uninstall
#uninstall:
#rm -f 
	
