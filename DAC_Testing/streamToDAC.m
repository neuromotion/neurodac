% Code for taking processed neural data, resampling it to be the right
% sample rate for streaming to the U-DAC 8 device, and then streaming the
% data

function status = streamToDAC(processedData, chans, dataSampRate, streamSampRate, sampsPerFrame)
% STATUS: True if data stream successfully completes
% PROCESSEDDATA: A NxM matrix of processed data (N channels x M samples) for streaming
% CHANS: A vector of up to 8 channels that will be streamed from the DAC.
% If nothing is specified, the first 8 channels will be used.
% DATASAMPRATE: Specifiy the sample rate that the data was collected at. If
% nothing is specified, a sample rate of 30000 samples/sec is assumed.
% STREAMSAMPRATE: The sample rate to be streamed from the DAC device. If
% nothing is specified, a value of 44100 will be used. This should match
% one of the sample rate options of the UDAC-8 device.
% SAMPSPERFRAME: Specify the number of samples contained within a single
% buffer frame for the DAC. If nothing is specified, a value of 8192 will
% be used.

% Created by Marc Powell
% Last Updated: 04/24/2017

% Initialize status
status = false;

% Check for input arguments
if nargin < 5 || isempty(sampsPerFrame)
    sampsPerFrame = 8192;
end

if nargin < 4 || isempty(streamSampRate)
    streamSampRate = 44100;
end

if nargin < 3 || isempty(dataSampRate)
    dataSampRate = 30000;
end

if nargin < 2 || isempty(chans)
    numChans = size(processedData, 1);
    if numChans > 8
        chans = 1:8;
    else
        chans = 1:numChans;
    end
end

% Perform resampling
[P, Q] = rat(streamSampRate./dataSampRate);
streamData = resample(double(processedData(chans,:)'), P, Q);

% % Normalize values in data stream
% maxVal = max(abs(streamData));
% streamData = streamData./maxVal;

% Normalize values based on Blackrock voltage mappings and clip anything
% going above 1 or below -1
streamData = streamData./1280;
streamData(streamData > 1) = 1;
streamData(streamData < -1) = -1;

% Clean up some memory
% clear processedData

% Initialize audio streaming object
aDW = audioDeviceWriter('Driver', 'ASIO', 'Device', 'miniDSP ASIO Driver');

% Stream data
% TODO: Use numUnderrun to keep track of dropped samples
indexPointer = 1;
numSamps = size(streamData, 1);
sampsRem = numSamps;
while sampsRem > sampsPerFrame
    endPointer = indexPointer + sampsPerFrame - 1;
    frame = streamData(indexPointer:endPointer, :);
    numUnderrun = aDW.play(frame);
    indexPointer = endPointer + 1;
    sampsRem = numSamps - indexPointer + 1;
end

% Release the device
aDW.release();

% Update status
status = true;

end