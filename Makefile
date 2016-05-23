all: help help_buildout

help_buildout:
	@echo "-----------------------------------------"
	@echo "  bootstrap  bootstraps the plone project
	@echo "  buildout   to run buildout"
	@echo "  restart    to restart instance1/2"

# include docs/Makefile

bootstrap_common:
	mkdir -p eggs
	virtualenv -p python2.7 .
	bin/pip install zc.buildout
	apt-get install libpcre3 libpcre3-dev

bootstrap_development_specific:
	ln -sf development.cfg buildout.cfg

bootstrap_production_specific:
	bin/pip install supervisor superlance
	apt-get install libpcre3 libpcre3-dev varnish nginx socat python-docutils libncurses5-dev libreadline6-dev pkg-config
	ln -sf production.cfg buildout.cfg
	touch secret.cfg

bootstrap_production: bootstrap_common bootstrap_production_specific

bootstrap_development: bootstrap_common bootstrap_development_specific

buildout: buildout.cfg
	bin/buildout -Nvt 2

stop: stop1 stop2
stop1:
	utils/hactl.sh stop 1
	sleep 10
	bin/supervisorctl stop instance1
stop2:
	utils/hactl.sh stop 2
	sleep 10
	bin/supervisorctl stop instance2

start: start1 start2
start1:
	bin/supervisorctl start instance1
	sleep 10
	bash utils/up.sh instance1 && utils/hactl.sh start 1
start2:
	bin/supervisorctl start instance2
	sleep 10
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
