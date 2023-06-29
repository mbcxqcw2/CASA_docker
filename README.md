# Notes:

Author: C. Walker @ 16/11/2022

This docker environment contains software necessary for running CASA
according to the instructions of UoT (CITA)'s Rebecca Lin.

# Computing notes:

- On Charlie's machine, the git repository is stored at /Users/c.walker/CASA_Docker
- The conversion to singularity is done on Charlie's machine
- The testing of singularity is to be done on Raven
- The conversion to charliecloud is to be done on Raven

# To do:

- Get CASA working on the docker
-- CASA loads, now must get GUIs working on the docker
- Make sure it can be converted to singularity (Charlie's machine)
-- Complete
- Make sure it runs on singularity (Raven)
-- Singularity image runs, but casa doesn't work correctly.
-- Must make $HOME area work correctly
-- Must make GUIs work correctly
- Make sure it can be converted to charliecloud
- Include casa tutorials from the EVN tutorial workshop at: https://www.jb.man.ac.uk/DARA/unit4/Workshops/EVN_continuum.html
- Include other useful packages for coherent beamforming (tempo2, pulsarbat, j2ms2, tConvert)

# Dependencies installed

- numpy
- baseband: https://github.com/mhvk/baseband (and dependencies)
- astropy: https://github.com/astropy/astropy (and dependencies)
- casa (v6.4.3-27): https://casa.nrao.edu/download/distro/casa/release/rhel/casa-6.4.3-27-py3.6.tar.xz 
# Instructions to build Docker image

To build docker image from this repository:

a) git clone the repository

b) navigate to the directory containing the dockerfile

c) run:

```
docker build -f Dockerfile -t casa .
```

d) to find the created image, run:

```
docker images
```

# Instructions to run Docker image

a) to run your created docker image, run:

```
docker run --rm -ti casa bash
```

Note: currently we cannot run GUIs (e.g. ipython, casa GUIs) within this docker. We need to enable this somehow. Adding `-e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix` after `docker run` gets a little further through the process, but it is not completely fixed yet.

# Instructions to convert to singularity

a) to turn docker image into a singularity image, run:

```
docker run -v /var/run/docker.sock:/var/run/docker.sock -v <LOCATION>:/output --privileged -t --rm singularityware/docker2singularity casa
```

where `<LOCATION>` is the place you want to store your singularity image

# Instructions to run singularity

a) to run the created singularity shell, do:

```
singularity shell <IMAGE>
```

where `<IMAGE>` is the name of your created singularity image.

Note: doing this, your image `$HOME` area is overwritten by your local `$HOME` area, which is automatically mounted to the image. Therefore the necessary `$HOME/.casa/` directory is overwritten, which is necessary to run casa properly. If you include `--contain` and `--no-home` in the singularity command, it does not mount the home area, but also doesn't let you see `$HOME` at all, which breaks casa. This must be fixed.

# Instructions to convert to charliecloud

- In the directory containing the Dockerfile, this will be something like: `ch-image build --force -t <NAME> -f Dockerfile .` where `<NAME>` is the name of the image to be created, however this currently fails.
