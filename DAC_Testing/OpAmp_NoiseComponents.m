In = 1e-12; % A/rtHz
Rs = 1e3; % ohm
Temp = 25 +273.15; % K

In_Rs = (In.*Rs)./1e-9; % nV/rtHz
E_Rs = sqrt(4.*1.38e-23.*Temp.*Rs)./1e-9; % nV/rtHz

