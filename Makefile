all: help help_buildout

help_buildout:
	@echo "-----------------------------------------"
	@echo "  bootstrap  bootstraps the plone project
	@echo "  buildout   to run buildout"
	@echo "  restart    to restart instance1/2/3"

# include docs/Makefile

bootstrap_common:
	test -e cache || mkdir cache
	test -e eggs || mkdir eggs
	virtualenv -p python2.7 .
	bin/pip install zc.buildout
	sudo apt-get install libpcre3 libpcre3-dev

bootstrap_development_specific:
	ln -sf development.cfg buildout.cfg

bootstrap_production_specific:
	bin/pip install supervisor superlance
	sudo apt-get install libpcre3 libpcre3-dev varnish nginx socat python-docutils libncurses5-dev libreadline6-dev pkg-config
	ln -sf production.cfg buildout.cfg
	touch secret.cfg

bootstrap_production: bootstrap_common bootstrap_production_specific

bootstrap_development: bootstrap_common bootstrap_development_specific

buildout: buildout.cfg
	bin/buildout -Nvt 2

stop: stop1 stop2 stop3
stop1:
	utils/hactl.sh stop 1
	sleep 10
	bin/supervisorctl stop instance1
stop2:
	utils/hactl.sh stop 2
	sleep 10
	bin/supervisorctl stop instance2

stop3:
	utils/hactl.sh stop 3
	sleep 10
	bin/supervisorctl stop instance3
stopvarnish: 
	bin/supervisorctl stop varnish

start: start1 start2 start3
start1:
	bin/supervisorctl start instance1
	sleep 10
	bash utils/up.sh instance1 && utils/hactl.sh start 1
start2:
	bin/supervisorctl start instance2
	sleep 10
	bash utils/up.sh instance2 && utils/hactl.sh start 2

start3:
	bin/supervisorctl start instance3
	sleep 10
	bash utils/up.sh instance2 && utils/hactl.sh start 3
startvarnish: 
	bin/supervisorctl start varnish

restart: restart1 restart2 restart3 restartvarnish
restart1: stop1 start1
restart2: stop2 start2
restart3: stop3 start3
restartvarnish: stopvarnish startvarnish


status:
	bin/supervisorctl status

theme:
	bin/buildout -Nvt 2 install compile

fixperms:
	bin/buildout -Nvt 2 install fixperms

quicktheme:
	bin/buildout -Nov install compile fixperms
