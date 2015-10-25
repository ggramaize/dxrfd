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

.PHONY: install
install: all
	adduser $(DXRFD_USER) --system --disabled-login --home $(DXRFD_HOME)
	install -m 0755 dxrfd $(prefix)/dxrfd
	install -m 0755 xrf_lh $(prefix)/xrf_lh
	install -m 0644 -o $(DXRFD_USER) -g $(DXRFD_USER) dxrfd.cfg $(DXRFD_HOME)/dxrfd.cfg
	install -m 0644 -o $(DXRFD_USER) -g $(DXRFD_USER) blocks.txt $(DXRFD_HOME)/blocks.txt
	install -m 0644 -o $(DXRFD_USER) -g $(DXRFD_USER) xrfs.txt $(DXRFD_HOME)/xrfs.txt
	install -m 0644 -o $(DXRFD_USER) -g $(DXRFD_USER) xrf_README.txt $(DXRFD_HOME)/xrf_README.txt
	install -m 0755 -o $(DXRFD_USER) -g $(DXRFD_USER) refresh-stats.sh $(DXRFD_HOME)/refresh-stats.sh
	mkdir -p $(DXRFD_HOME)/www/g2_ircddb
	install -m 0644 -o $(DXRFD_USER) -g $(DXRFD_USER) mm_spacer.gif $(DXRFD_HOME)/www/g2_ircddb/mm_spacer.gif
	install -m 0644 -o $(DXRFD_USER) -g $(DXRFD_USER) mm_training.css $(DXRFD_HOME)/www/g2_ircddb/mm_training.css
	ln -s $(DXRFD_HOME)/www/status.html $(DXRFD_HOME)/www/index.html
#
#.PHONY: uninstall
#uninstall:
#rm -f 
	
