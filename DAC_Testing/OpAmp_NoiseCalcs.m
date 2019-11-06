% This code is to help select an op-amp for low noise buffering of the DAC
% output

% Initialize variables
Rs = 1e3; % Source resistance (ohm)
En = 1.1e-9; % Op-amp voltage noise density (V/sqrt(Hz))
In = 1.6e-12; % Op-amp current noise density (A/sqrt(Hz))
LF_pkpk = 75e-9; % pk-pk noise in the 0.1 - 10 Hz band (V)
Fc_V = 14; % 1/f noise cuttoff frequency (Hz) of voltage noise
Fc_I = 800; % 1/f noise cuttoff frequency (Hz) of current noise
F_high = 10e3; % 10 kHz based on intan amplifier bandwidth (for comparison)
F_low = 0.1; % 0.1 Hz also based on intan bandwidth
Temp = 25 + 273.15; % Temperature in K (room temp 25C)

% The following calculations are based on the linear technology design note
% 15.
% http://cds.linear.com/docs/en/design-note/dn015f.pdf

% Equation for calculating RMS noise in a certain bandwidth taking into
% account 1/f noise and the op-amp's cutoff frequnecy
noise = @(NO, FC, FH, FL)NO.*sqrt((FC.*log(FH/FL)) + (FH-FL));
johnson = @(T, R, FH, FL)sqrt(4.*1.39e-23.*T.*R.*(FH - FL));

% The base input referred voltage noise of the op-amp
En_rms = noise(En, Fc_V, F_high, F_low);

% The voltage noise caused by the op-amp's current noise being pulled
% through the source resistnace
In_rms = noise(In, Fc_I, F_high, F_low);
En_Rs_rms = In_rms.*Rs;

% The voltage noise caused by Johnson noise from the source resistnace
E_Rs_rms = johnson(Temp, Rs, F_high, F_low);

% Add up the rms voltages in the power domain
total_noise = sqrt((En_rms.^2) + (En_Rs_rms.^2) + (E_Rs_rms.^2));

% The following calculations are a rough estimate using the LF noise values
% often quoted in datasheets which will be easier to find, but will be less
% accurate because it does not take into account the 1/f cuttoff frequency

% Convert from pk-pk to RMS for the LF band:
% https://www.allaboutcircuits.com/tools/rms-voltage-calculator/
LF_rms = LF_pkpk./(2.*sqrt(2));

% Calculate a flat noise density for the bandwidth from 10 Hz to F_high
En_rms_2 = En .* sqrt(F_high - 10);

% Calculate a flat noise density for current noise
In_rms_2 = In .* sqrt(F_high - 10);
En_Rs_rms_2 = In_rms_2.*Rs;

% Johnson noise should remain unchanged
E_Rs_rms_2 = E_Rs_rms;

% Find the new total noise
total_noise_2 = sqrt((LF_rms.^2) + (En_rms_2.^2) + (En_Rs_rms_2.^2) + (E_Rs_rms_2.^2));