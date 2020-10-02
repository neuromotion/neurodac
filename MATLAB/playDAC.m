% Dependencies
% MATLAB Audio Systems Toolbox
% UDAC 8 ASIO drivers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Last Updated: 10/02/2020
% Author: Marc P. Powell
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function playDAC(data, data_fs, maxValue, channel)
% Plays data out of a single channel
% INPUTS
% data: vector of data to be played
% data_fs: sample rate of data vector
% maxValue: maximum value of the data (or maximum value of the output
% signal range in same units as data) the final signal will be scaled
% between [-1 1] based on this value
% channel: channel number of NeuroDAC to be used

% Default channel is 1
if nargin < 4 || isempty(channel)
    channel = 1;
end

% Setup parameters
fs = 192e3;
sampsPerFrame = 8192;

% Resample the data if needed
[P, Q] = rat(fs./data_fs);
data = resample(double(data), P, Q);

% Add 0's to the end of the data to make an even multiple of frames
remainder = mod(length(data), sampsPerFrame);
data = [data zeros(1, sampsPerFrame - remainder)];

% Check the maxValue input
if isempty(maxValue) || nargin < 3
    maxValue = max(abs(data));
    if maxValue > 1
        warning('Data normalized to maximum input value of data. Make sure this is what you want')
    else
        maxValue = 1;
        warning('Assumed data has been normalized between -1 and 1, not being rescaled')
    end
end

% Normalize data to maxValue
data = data/maxValue;

% Store data vector length
dataLength = length(data);

% Put data in one channel of neuroDAC output and make the rest all 0's
buff = zeros(dataLength, 8);
buff(:, channel) = data;
data = buff;

% Construct the object to talk to the audio driver
aDW = audioDeviceWriter(fs, 'Driver', 'ASIO', 'Device', 'miniDSP ASIO Driver');

% Play some sines in frames
indexPointer = 1;
endPointer = indexPointer + sampsPerFrame - 1;
% Go until you run out of samples (should be an perfect number of frames)
while endPointer <= dataLength    
    frame = data(indexPointer:endPointer, :);
    numUnderrun = aDW.play(frame);
    indexPointer = endPointer + 1;
    endPointer = indexPointer + sampsPerFrame - 1;
end

% Release the device
aDW.release();

end
