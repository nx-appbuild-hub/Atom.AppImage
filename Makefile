# Copyright 2020 Alex Woroschilow (alex.woroschilow@gmail.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
PWD:=$(shell pwd)

all: clean
	mkdir --parents $(PWD)/build/Boilerplate.AppDir/atom
	apprepo --destination=$(PWD)/build appdir boilerplate libatk1.0-0 libatk-bridge2.0-0 libgtk-3-0 libreadline8

	wget --output-document="$(PWD)/build/build.deb" "https://atom.io/download/deb"
	dpkg -x $(PWD)/build/build.deb $(PWD)/build

	echo '' 																		>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '' 																		>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo 'LD_LIBRARY_PATH=$${LD_LIBRARY_PATH}:$${APPDIR}/atom' 						>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo 'export LD_LIBRARY_PATH=$${LD_LIBRARY_PATH}' 								>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '' 																		>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '' 																		>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo 'UUC_VALUE=`cat /proc/sys/kernel/unprivileged_userns_clone 2> /dev/null`' 	>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '' 																		>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '' 																		>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '' 																		>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo 'if [ -z "$${UUC_VALUE}" ]' 												>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '    then' 																>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '        exec $${APPDIR}/atom/atom --no-sandbox "$${@}"' 					>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '    else' 																>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '        exec $${APPDIR}/atom/atom "$${@}"' 								>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '    fi' 																	>> $(PWD)/build/Boilerplate.AppDir/AppRun

	cp --force --recursive $(PWD)/build/usr/share/atom*/* $(PWD)/build/Boilerplate.AppDir/atom
	
	rm --force $(PWD)/build/Boilerplate.AppDir/*.desktop
	cp --force $(PWD)/AppDir/*.desktop $(PWD)/build/Boilerplate.AppDir/
	cp --force $(PWD)/AppDir/*.png $(PWD)/build/Boilerplate.AppDir/ || true
	cp --force $(PWD)/AppDir/*.svg $(PWD)/build/Boilerplate.AppDir/ || true

	export ARCH=x86_64 && $(PWD)/bin/appimagetool.AppImage $(PWD)/build/Boilerplate.AppDir $(PWD)/Atom.AppImage
	chmod +x $(PWD)/Atom.AppImage


clean:
	rm -rf $(PWD)/build
