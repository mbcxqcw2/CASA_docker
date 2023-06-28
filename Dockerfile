
#NOTES
#Author: C. Walker @ 28/06/2023
#This docker contains software for analysing radio interferometry data

#FROM ubuntu:16.04
FROM nvidia/cuda:11.2.0-devel-ubuntu18.04

MAINTAINER Charles Walker "cwalker@mpifr-bonn.mpg.de"

#Declare a timezone for when we update apt
#Adapted from: https://dev.to/grigorkh/fix-tzdata-hangs-during-docker-image-build-4o9m

ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

###################################
#Install necessary system packages#
###################################

#Make sure we are in the main working directory...
WORKDIR /

#update apt-get
RUN apt-get update -y

#install other packages
RUN apt-get -y install cmake
RUN apt-get -y install git
RUN apt-get -y install gcc

#gfortran for tempo, psrchive, dspsr
#RUN apt-get update
#RUN apt-get -y install gfortran

#fftw (for PSRCHIVE)
RUN apt-get -y install libfftw3-3
RUN apt-get -y install libfftw3-bin
RUN apt-get -y install libfftw3-dev
RUN apt-get -y install libfftw3-single3

#fitsio (for DSPSR)
RUN apt-get -y install libcfitsio-dev

####################################################
#Install python version 3.9, necessary for baseband#
####################################################
#FROM python:3.9.7

#code adapted from: https://stackoverflow.com/questions/70866415/how-to-install-python-specific-version-on-docker
#and: https://dev.to/grigorkh/fix-tzdata-hangs-during-docker-image-build-4o9m
#and: https://stackoverflow.com/questions/56135497/can-i-install-python-3-7-in-ubuntu-18-04-without-having-python-3-6-in-the-system

RUN apt-get install -y curl

RUN apt update && \
    apt install --no-install-recommends -y build-essential software-properties-common && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt install --no-install-recommends -y python3.9 python3.9-dev python3.9-distutils && \
    apt clean && rm -rf /var/lib/apt/lists/*

# Register the version in alternatives (and set higher priority to 3.7)
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 1
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 2

# Upgrade pip to latest version
RUN curl -s https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python3 get-pip.py --force-reinstall && \
    rm get-pip.py

###################################
#Install necessary python packages#
###################################

#numpy
RUN pip install numpy

#matplotlib
RUN pip install matplotlib

#pyqt5 (for ipython gui backend)
RUN pip install pyqt5

#baseband by Marten van Kerkwijk
RUN git clone https://github.com/mhvk/baseband
RUN pip3 install baseband/

##############
#Install CASA#
##############
#Note: these instructions are adapted from: https://eor.cita.utoronto.ca/penwiki/CASA_(Python_3)

#RUN apt-get -y install wget

#get the casa tarball
RUN curl https://casa.nrao.edu/download/distro/casa/release/rhel/casa-6.4.3-27-py3.6.tar.xz -o casa-6.4.3-27-py3.6.tar.xz

#untar the casa tarball
RUN tar -xvf casa-6.4.3-27-py3.6.tar.xz

#add the location of CASA to path
ENV PATH="/casa-6.4.3-27/bin:${PATH}"

#add a .casarc file to main working directory pointing to casa data folder
RUN echo "measures.directory:/casa-6.4.3-27/data" > .casarc

###########
#Finish up#
###########

#force reinstall jupyter, ipython so it contains necessary packages
RUN pip install ipython --force-reinstall
RUN pip install notebook --force-reinstall
