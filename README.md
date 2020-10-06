[![DOI](https://zenodo.org/badge/220079207.svg)](https://zenodo.org/badge/latestdoi/220079207)

# Installation
## Python
The python code relies on the "sounddevice" package. Install this using:
'''pip install sounddevice"
## MATLAB
The MATLAB code relies on the Audio Systems Toolbox. To install it go to the add-on manager in MATLAB IDE,
search for this toolbox and install it. This is not a standard toolbox so you may need to check with your
insitution to make sure you have access to it (I had to get Brown to purchase it). If you cannot get access 
the Python code works just as well.
# Description of files
## eagle-schematic/
Contains the eagle schematics for the NeuroDAC signal conditioning PCB.
## MATLAB/
Contains example code for using NeuroDAC with MATLAB
### playSine.m
This is a script to play 30 seconds of a sine wave a different frequencies on each channel.
This is helpful for testing the system and making sure that you have all the software installed properly.
### playDAC.m
A function for playing a vector of data using a single channel of NeuroDAC
### playDACSimul.m
A function for playing 8 channels of data out of NeuroDAC simultaneously
## Python/
Contains example code for using the NeuroDAC with Python
### playSine.py
This is a Python file that works similarly to the MATLAB_Sine script described above. It plays 8 sine waves each at 10 Hz out of all channels of the NeuroDAC. Use this to test your system.
# DOI
This is the digital identifier for this repository published using Zenodo
[![DOI](https://zenodo.org/badge/220079207.svg)](https://zenodo.org/badge/latestdoi/220079207)
