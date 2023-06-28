# Notes:

Author: C. Walker @ 16/11/2022

This docker environment contains software necessary for running CASA
according to the instructions of UoT (CITA)'s Rebecca Lin.

See: https://eor.cita.utoronto.ca/penwiki/CASA_(Python_3)

# Computing notes:

- On Charlie's machine, the git repository is stored at /Users/c.walker/CASA_Docker
- The conversion to singularity is to be done on Charlie's machine
- The testing of singularity is to be done on Raven
- The conversion to charliecloud is to be done on a machine when I find one with access to both Docker and charliecloud

# To do:

- Get CASA working on the docker
- Make sure it can be converted to singularity (Charlie's machine)
- Make sure it runs on singularity
- Include casa tutorials from the EVN tutorial workshop at: https://www.jb.man.ac.uk/DARA/unit4/Workshops/EVN_continuum.html
- Include other useful packages for coherent beamforming (tempo2, pulsarbat, j2ms2, tConvert)

# Dependencies installed

- numpy
- baseband: https://github.com/mhvk/baseband (and dependencies)
- astropy: https://github.com/astropy/astropy (and dependencies)

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


# Instructions to convert to singularity
# Instructions to convert to charliecloud
