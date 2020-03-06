%% the script used to prepare an experiment
% Hugo Trentesaux 2018/01/26
% No Psychtoolbox needed anymore for Hippolyte
% modified on the 24th of January 2020

addpath(genpath('C:\Users\Jean Perrin\Desktop\Hippolyte\balancoire\Matlab\balancoire_matlab_files\experience_2_tailtracking'))
addpath(genpath('C:\Users\Jean Perrin\Desktop\Hippolyte\balancoire\Matlab\balancoire_matlab_files\bouts_detection'));

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


%% pre run (set parameters)
duration = 10;
num_segments = 10;
inertia = 0.6;
body_length = 0;
tail_length = 115;
prerun(camera, 'duration', 10, 'num_segments', num_segments, 'inertia', inertia, 'body_length', body_length, 'tail_length', tail_length) 
% pre-run (you can run it to verify the fish is well detected, and adapt parameters)


