%% the script used to prepare an experiment
% Hugo Trentesaux 2018/01/26

% addpath(genpath('/home/ljp/Science/Hugo/behaviour_tilt_hugo/Program/balancoire/Matlab'))
addpath(genpath('C:\Users\Jean Perrin\Desktop\Hugo\balancoire\Matlab'))
%% reinits everything

%% to reinit the motor
instrfind; delete(ans); clear ans;  %#ok<NOANS> 
%% inits psychtoolbox
sca
%% inits image aquisition toolbox
imaqreset
%% clear the variables
clear
%% clears screen
clc
%% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


%% communiation with the camera

disp('initializing camera connection')
camera = Camera();
disp('camera initialized')

%% communication with the motor

disp('initializing motor connection')
motor = DMAC();
disp('motor initialized')

%% communication with psychtoolbox

% run in command line
%   "C:\Program Files\MATLAB\R2018a\bin\matlab.exe" -nodesktop -r "loop"

proj = PsychCli; % get client to talk with the other matlab
pause(1);
proj.initProj(); % do not re-do it when there is already a pattern
pause(10); % Psychtoolbox is long to start

%% sets the ROI

camera.setROI()

%% % % % % % % % % % % % % tests functions % % % % % % % % % % % % % % % % 
%% pre run
prerun(camera, 10) % pre-run (you can run it verify the fish is well detected)

%% rotate pattern

proj.speedLoop;
proj.setSpeed(-20);
pause(2);
proj.stopLoop;

%%

