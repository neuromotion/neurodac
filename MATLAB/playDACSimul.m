% Dependencies
% MATLAB Audio Systems Toolbox
% UDAC 8 ASIO drivers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Last Updated: 10/02/2020
% Author: Marc P. Powell
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Asumes all data is already scaled between -1 and 1 and at a sample rate
% of 192 kSPS and in double format
function playDACSimul(data)
% Plays data out of all channels simultaneously.
% INPUTS
% data: the data to be played, should be an Nx8 matrix of values

% Setup parameters
fs = 192e3;
sampsPerFrame = 8192;

% Construct the object to talk to the audio driver
aDW = audioDeviceWriter(fs, 'Driver', 'ASIO', 'Device', 'miniDSP ASIO Driver');

% Points to indicies to be extraced in a frame
indexPointer = 1;
endPointer = indexPointer + sampsPerFrame - 1;

% Determine length of data
dataLength = size(data, 1);

% Go until you run out of samples (should be an perfect number of frames)
while endPointer <= dataLength
    % Extract frame
    frame = data(indexPointer:endPointer, :);
    % Play frame
    numUnderrun = aDW.play(frame);
    % Update indicies
    indexPointer = endPointer + 1;
    endPointer = indexPointer + sampsPerFrame - 1;
end

% Release the device
aDW.release();

end
