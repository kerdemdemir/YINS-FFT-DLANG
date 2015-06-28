# YINS-FFT-DLANG

This project aims to get fundemental frequency from speech or musical enstrumants. 
To get fundemental frequency this project implements the algorithm called YINS-FFT which can be read from link: 
http://recherche.ircam.fr/equipes/pcm/cheveign/pss/2002_JASA_YIN.pdf

Source codes:  source/YinsFFT.d and source/FFTUtilities.d can be directly added to project and be used. 
Since D language has build in FFT, IFFT etc..., they have no depency to other libraries.  
 
Wave folder is just added for user who may want to build example.d. The code in wave file directly taken from : 
http://code.dlang.org/packages/wave-d
It is for reading wav files.

I tested the code with results of well know tool "Praat". Result are almost identical. 
I haven't test the performance yet but I am hoping it should run faster than other libraies who implemented the same paper. 

