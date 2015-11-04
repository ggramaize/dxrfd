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

.PHONY: dist-clean
dist-clean: clean

.PHONY: install
install: all
	addgroup $(DXRFD_USER) --system
	adduser $(DXRFD_USER) --ingroup $(DXRFD_USER) --system --disabled-login --home $(DXRFD_HOME)
	install -m 0755 dxrfd $(prefix)/dxrfd
	install -m 0755 xrf_lh $(prefix)/xrf_lh
	install -m 0644 -o $(DXRFD_USER) -g $(DXRFD_USER) apache.conf $(DXRFD_HOME)/apache.conf
	install -m 0644 -o $(DXRFD_USER) -g $(DXRFD_USER) dxrfd.cfg $(DXRFD_HOME)/dxrfd.cfg
	install -m 0644 -o $(DXRFD_USER) -g $(DXRFD_USER) blocks.txt $(DXRFD_HOME)/blocks.txt
	install -m 0644 -o $(DXRFD_USER) -g $(DXRFD_USER) xrfs.txt $(DXRFD_HOME)/xrfs.txt
	install -m 0644 -o $(DXRFD_USER) -g $(DXRFD_USER) xrf_README.txt $(DXRFD_HOME)/xrf_README.txt
	install -m 0755 -o $(DXRFD_USER) -g $(DXRFD_USER) refresh-stats.sh $(DXRFD_HOME)/refresh-stats.sh
	mkdir -p $(DXRFD_HOME)/www/g2_ircddb
	install -m 0644 -o $(DXRFD_USER) -g $(DXRFD_USER) mm_spacer.gif $(DXRFD_HOME)/www/g2_ircddb/mm_spacer.gif
	install -m 0644 -o $(DXRFD_USER) -g $(DXRFD_USER) mm_training.css $(DXRFD_HOME)/www/g2_ircddb/mm_training.css
	ln -s $(DXRFD_HOME)/www/status.html $(DXRFD_HOME)/www/index.html
	chown -R $(DXRFD_USER):$(DXRFD_USER) $(DXRFD_HOME)/www
	[ -e /etc/apache2/conf-available ] && ln -s $(DXRFD_HOME)/apache.conf /etc/apache2/conf-available/dxrfd.conf
	[ -e /etc/apache2/conf-enabled ] && ln -s /etc/apache2/conf-available/dxrfd.conf /etc/apache2/conf-enabled/dxrfd.conf
	[ -e /etc/apache2/conf.d ] && ln -s $(DXRFD_HOME)/apache.conf /etc/apache2/conf.d/dxrfd.conf

.PHONY: svcinst_debsysv
svcinst_debsysv: all
	install -m 0755 dxrfd.lsb-init /etc/init.d/dxrfd
	update-rc.d dxrfd defaults

.PHONY: svcinst_systemd
svcinst_systemd: all
	install -m 0755 systemd-wrapper.sh $(DXRFD_HOME)/systemd-wrapper.sh
	install -m 0644 dxrfd.service /etc/systemd/system/dxrfd.service
	systemctl enable dxrfd

.PHONY: svcrem
svcrem: 
	[ -e /etc/init.d/dxrfd ] && update-rc.d dxrfd remove
	[ -e /etc/init.d/dxrfd ] && rm -f /etc/init.d/dxrfd
	[ -e /etc/systemd/system/dxrfd.service ] && systemctl disable dxrfd
	[ -e /etc/systemd/system/dxrfd.service ] && rm -f /etc/systemd/system/dxrfd.service
	[ -e $(DXRFD_HOME)/systemd-wrapper.sh ] && rm -f $(DXRFD_HOME)/systemd-wrapper.sh

.PHONY: uninstall
uninstall:
	[ -e /etc/apache2/conf.d/dxrfd.conf ] && rm -f /etc/apache2/conf.d/dxrfd.conf
	[ -e /etc/apache2/conf-enabled/dxrfd.conf ] && rm -f /etc/apache2/conf-enabled/dxrfd.conf
	[ -e /etc/apache2/conf-available/dxrfd.conf ] && rm -f /etc/apache2/conf-available/dxrfd.conf
	rm -rf $(DXRFD_HOME)
	rm -f $(prefix)/dxrfd
	rm -f $(prefix)/xrf_lh
	deluser $(DXRFD_USER) --force --remove-home
	
