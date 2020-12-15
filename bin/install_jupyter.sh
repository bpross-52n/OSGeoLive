#!/bin/sh
# Copyright (c) 2013-2020 The Open Source Geospatial Foundation and others.
# Licensed under the GNU LGPL version >= 2.1.
#
# This library is free software; you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 2.1 of the License,
# or any later version.  This library is distributed in the hope that
# it will be useful, but WITHOUT ANY WARRANTY, without even the implied
# warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU Lesser General Public License for more details, either
# in the "LICENSE.LGPL.txt" file distributed with this software or at
# web page "http://www.fsf.org/licenses/lgpl.html".
#
# About:
# =====
# This script will install jupyter and jupyter-notebook in ubuntu
# The future may hold interesting graphical examples using notebook + tools

./diskspace_probe.sh "`basename $0`" begin
####

if [ -z "$USER_NAME" ] ; then
   USER_NAME="user"
fi
USER_HOME="/home/${USER_NAME}"
USER_DESKTOP="${USER_HOME}/Desktop"
BUILD_DIR=`pwd`
JUPYTER_BUILD_DIR='/tmp/jupyter_build'
mkdir -p ${JUPYTER_BUILD_DIR}
cd ${JUPYTER_BUILD_DIR}

# Install jupyter notebook
apt-get install --assume-yes jupyter-notebook jupyter-client jupyter-nbconvert \
  python3-ipykernel python3-nbformat python3-ipywidgets

# 12dev -- note ticket #1965 for trial log

# ipython CLI and R kernel as well
apt-get install --assume-yes ipython3 r-cran-irkernel


##=============================================================
## Add Kernels and Jupyter Mods
##

##--  IRKernel via github (assumes R core)
##--   v13  IRKernel is on cran

# su - -c "R -e \"install.packages('pbdZMQ')\""
# su - -c "R -e \"install.packages('uuid')\""
# su - -c "R -e \"install.packages('digest')\""

# su - -c "R -e \"install.packages('repr')\""
# su - -c "R -e \"install.packages('evaluate')\""
# su - -c "R -e \"install.packages('crayon')\""

# su - -c "R -e \"install.packages('IRdisplay')\""

# apt-get install --assume-yes libssl-dev openssl
# su - -c "R -e \"install.packages('devtools')\""

## Install method minus-one -- pull directly from Github dot com
#su - -c "R -e \"devtools::install_github('IRkernel/IRkernel')\""
#su - -c "R -e \"IRkernel::installspec(user = FALSE)\""

## Install method one -- git snapshot+ID on download.osgeo.org
#JOVYAN_R='IRkernel-master-97c492b2.zip'
#wget -c http://download.osgeo.org/livedvd/12/jupyter/${JOVYAN_R}
#unzip ${JOVYAN_R}
#R CMD INSTALL IRkernel-master
#- TODO check status

## IRkernel    master  1.0.0     0.8.15
## commit 79baf3f1cf3438e8c8b739a3fdab545f4e3cc906
##  install.package('IRkernel/IRkernel')
# su - -c "R -e \"install.packages('IRkernel')\""

## global kernel
# su - -c "R -e \"IRkernel::installspec(user = FALSE)\""

#- cleanup
# cd ${USER_HOME}
# apt-get remove --yes libssl-dev

##=============================================================


# Get Jupyter logo
cp "$BUILD_DIR"/../app-data/jupyter/jupyter.svg \
   /usr/share/icons/hicolor/scalable/apps/jupyter.svg

cp "$BUILD_DIR"/../app-data/jupyter/jupyter-notebook.desktop \
   "$USER_DESKTOP"/
chown "$USER_NAME:$USER_NAME" "$USER_DESKTOP"/jupyter-notebook.desktop

cp "$BUILD_DIR"/../app-data/jupyter/jupyter_start.sh \
   /usr/local/bin/
chmod a+x /usr/local/bin/jupyter_start.sh

# TODO: Test if these notebooks work fine
# mkdir -p "$USER_HOME/jupyter"
# git clone https://github.com/OSGeo/OSGeoLive-Notebooks.git \
#    "$USER_HOME/jupyter/notebooks"
# chown -R "$USER_NAME:$USER_NAME" "$USER_HOME/jupyter"

cd "$BUILD_DIR"

##-- o13 rm cartopy_simple ---------------------------------------
#mkdir -p "$USER_HOME/jupyter/notebook_gallery/SciTools"
#cp "$BUILD_DIR"/../app-data/jupyter/cartopy_simple.ipynb \
#   "$USER_HOME/jupyter/notebook_gallery/SciTools/"
##----------------------------------------------------------------

##-- o13 R notebook sample ---------------------------------------
mkdir -p "$USER_HOME/jupyter/notebook_gallery/R"
cp "$BUILD_DIR"/../app-data/jupyter/R_spatial_introduction.ipynb \
   "$USER_HOME/jupyter/notebook_gallery/R/"

## -- add R sf Intro page -- minimal size embed
cp "$BUILD_DIR"/../app-data/jupyter/R_Notebooks_splash/*.html \
   "$USER_HOME/jupyter/notebook_gallery/R/"
cp "$BUILD_DIR"/../app-data/jupyter/R_Notebooks_splash/sf_logo.gif \
   "$USER_HOME/jupyter/notebook_gallery/R/"
cp "$BUILD_DIR"/../app-data/jupyter/R_Notebooks_splash/RConsortium.png \
   "$USER_HOME/jupyter/notebook_gallery/R/"

##-- o13  copy tested content -dbb
cd ${JUPYTER_BUILD_DIR}
wget -c --progress=dot:mega \
    -O OSGeoLive-Notebooks-13.x.zip \
    https://github.com/OSGeo/OSGeoLive-Notebooks/archive/13.x.zip
unzip -o -q OSGeoLive-Notebooks-13.x.zip
cd OSGeoLive-Notebooks-13.x
cp -R notebooks/* ${USER_HOME}/jupyter/notebook_gallery/
cd ..
rm -rf OSGeoLive-Notebooks-13.x
rm OSGeoLive-Notebooks-13.x.zip

cd "$BUILD_DIR"
rm -rf ${JUPYTER_BUILD_DIR}
##--------------------------------------------
cp -r ${USER_HOME}/jupyter /etc/skel

chown -R ${USER_NAME}:${USER_NAME} ${USER_HOME}/jupyter

####
"$BUILD_DIR"/diskspace_probe.sh "`basename $0`" end
