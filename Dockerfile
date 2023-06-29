
#NOTES
#Author: C. Walker @ 28/06/2023
#This docker contains software for analysing radio interferometry data

FROM ubuntu:20.04
#FROM nvidia/cuda:11.2.0-devel-ubuntu18.04

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

#install curl for downloading files from the web
RUN apt-get install -y curl

# install python, pip
RUN apt-get -y install python
RUN apt-get -y install python3-pip
RUN pip install --upgrade pip


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

#make a new directory to hold casa
RUN mkdir casa

#navigate to directory
WORKDIR /casa

#get the casa tarball
RUN curl https://casa.nrao.edu/download/distro/casa/release/rhel/casa-6.4.3-27-py3.6.tar.xz -o casa-6.4.3-27-py3.6.tar.xz

#untar the casa tarball
RUN tar -xvf casa-6.4.3-27-py3.6.tar.xz

#add the location of CASA to path
ENV PATH="/casa/casa-6.4.3-27/bin:${PATH}"

#navigate back to main working directory
WORKDIR /

#add a .casarc file to main working directory pointing to casa data folder
RUN echo "measures.directory:/casa/casa-6.4.3-27/data" > .casarc

#run and exit casa for the first time so we can create config files
RUN casa
RUN exit

#create simplest version of a casa config file
RUN echo 'datapath=["/casa/casa-6.4.3-27/data"]\ntelemetry_enabled = True\ncrashreporter_enabled = True' > ${HOME}/.casa/config.py

###########
#Finish up#
###########

#force reinstall jupyter, ipython so it contains necessary packages
RUN pip install ipython --force-reinstall
RUN pip install notebook --force-reinstall
