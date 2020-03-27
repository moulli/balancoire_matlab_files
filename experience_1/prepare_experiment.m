%% the script used to prepare an experiment
% Hugo Trentesaux 2018/01/26
% No Psychtoolbox needed anymore for Hippolyte
% modified on the 24th of January 2020

addpath(genpath('C:\Users\Jean Perrin\Desktop\Hippolyte\balancoire\Matlab'))

% to reinit the motor
instrfind; delete(ans); clear ans;  %#ok<NOANS> 
% inits image aquisition toolbox
imaqreset
% clear the variables
clear
% clears screen
clc


%% communiation with the camera

disp('initializing camera connection')
camera = Camera();
disp('camera initialized')


%% communication with the motor

disp('initializing motor connection')
motor = DMAC();
disp('motor initialized')


%% sets the ROI

camera.setROI()


%% pre run (test)
prerun(camera, 10) % pre-run (you can run it verify the fish is well detected)


