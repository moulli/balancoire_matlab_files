%% the script used to prepare an experiment
% Hugo Trentesaux 2018/01/26
% No Psychtoolbox needed anymore for Hippolyte
% modified on the 24th of January 2020

addpath(genpath('C:\Users\Jean Perrin\Desktop\Hippolyte\balancoire\Matlab\balancoire_matlab_files\experience_3_OMR'))
addpath(genpath('C:\Users\Jean Perrin\Desktop\Hippolyte\balancoire\Matlab\balancoire_matlab_files\bouts_detection'));

%% inits psychtoolbox
sca
% inits image aquisition toolbox
imaqreset
% clear the variables
clear
% clears screen
clc


%% communication with psychtoolbox

% run in command line
%   "C:\Program Files\MATLAB\R2018a\bin\matlab.exe" -nodesktop -r "loop"
%   "C:\Program Files\MATLAB\R2019a\bin\matlab.exe" -nodesktop
% then type in new matlab command
%   PsychLoop()

proj = PsychCli; % get client to talk with the other matlab
pause(1);
proj.initProj(); % do not re-do it when there is already a pattern
pause(10); % Psychtoolbox is long to start

% Optional: change pattern:
windmillWingNumber = 8;
horizonAngle = 180;
power = 1;
proj.changePattern(windmillWingNumber, horizonAngle, power);


%% communiation with the camera

disp('initializing camera connection')
camera = Camera();
disp('camera initialized')


%% sets the ROI

camera.setROI()


%% pre run (set parameters)
duration = 10;
num_segments = 10;
inertia = 0.6;
body_length = 0;
tail_length = 115;
prerun(camera, 'duration', 10, 'num_segments', num_segments, 'inertia', inertia, 'body_length', body_length, 'tail_length', tail_length) 
% pre-run (you can run it to verify the fish is well detected, and adapt parameters)


%% rotate pattern

proj.speedLoop;
proj.setSpeed(20);
pause(5);
proj.stopLoop;


