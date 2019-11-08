% Dependencies
% MATLAB Audio Systems Toolbox
% UDAC 8 ASIO drivers

% Setup parameters
fs = 48000;
streamLength = 30; % sec
t = 0:1/fs:streamLength;
% frameSize = 1; %sec
sampsPerFrame = 8192;

% Bank of frequencies for each channel
freqs = [1, 10, 25, 50, 100, 150, 200, 250];
amps = [1, 1, 1, 1, 1, 1, 1, 1];

% Initialize variables
data = zeros(length(t), length(freqs));

% Build some sample waveforms to be played through the device
for ind = 1:length(freqs)
    data(:,ind) = amps(ind).*sin(2.*pi.*freqs(ind).*t);
end

% Construct the object to talk to the audio driver
aDW = audioDeviceWriter('Driver', 'ASIO', 'Device', 'miniDSP ASIO Driver');

% Play some sines in frames
indexPointer = 1;
sampsRem = length(t);
while sampsRem > sampsPerFrame
    endPointer = indexPointer + sampsPerFrame - 1;
    frame = data(indexPointer:endPointer, :);
    numUnderrun = aDW.play(frame);
    indexPointer = endPointer + 1;
    sampsRem = length(t) - indexPointer + 1;
end

% Release the device
aDW.release();
