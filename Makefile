all: help help_buildout

help_buildout:
	@echo "-----------------------------------------"
	@echo "  bootstrap  bootstraps the plone project
	@echo "  buildout   to run buildout"
	@echo "  restart    to restart instance1/2"

# include docs/Makefile

bootstrap:
	virtualenv -p python2.7 .
	bin/pip install zc.buildout
	apt-get install libpcre3 libpcre3-dev varnish nginx

buildout: buildout.cfg
	bin/buildout -Nvt 2

stop: stop1 stop2
stop1:
	utils/hactl.sh stop 1
	sleep 20
	bin/supervisorctl stop instance1
stop2:
	utils/hactl.sh stop 2
	sleep 20
	bin/supervisorctl stop instance2

start: start1 start2
start1:
	bin/supervisorctl start instance1
	sleep 60
	bash utils/up.sh instance1 && utils/hactl.sh start 1
start2:
	bin/supervisorctl start instance2
	sleep 30
	bash utils/up.sh instance2 && utils/hactl.sh start 2

restart: restart1 restart2
restart1: stop1 start1
restart2: stop2 start2

status:
	bin/supervisorctl status

theme:
	bin/buildout -Nvt 2 install compile

fixperms:
	bin/buildout -Nvt 2 install fixperms

quicktheme:
	bin/buildout -Nov install compile fixperms
