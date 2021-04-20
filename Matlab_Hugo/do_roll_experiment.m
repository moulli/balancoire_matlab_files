%% --- defines parameters of experiments and programs motor

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% /!\ you must run the prepare_experiment script before to communicate with
% the motor and camera
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

%% sets the limits for the motor

motor.home()
motor.setSoftLimits(-100,100)
motor.degreePerStep = 0.006;

%% sets natalia's parameters for projection

projector.windmill.HorizonAngle = 0;
projector.windmill.WindmillWingNumber = 14;
% projector.windmill.CentralSpotSize =

% projector.windmill.WindmillBorder = 
% projector.windmill.color =
% projector.windmill.power =
projector.windmill.angle = 0;
projector.drawWindmill
projector.refresh


%% constants
clc

DURATION = 105; % sets the duration (in seconds)
GAIN = 1; % sets the conflict gain


% ----- path folder template -----
path = 'D:\Natalia\2018-10\';
folder = '\2018-10-17\Run.8\';
% motor_program_template ='step10_test.txt';     % already existing template to write 
% motor_program_template = 'step20_test.txt';     % already existing template to write 
% motor_program_template = 'step10_15_20_25_30.txt';     % already existing template to write 
% motor_program_template = 'step10_15_20.txt';     % already existing template to write 
motor_program_template = 'step40_test.txt';     % already existing template to write 
% % motor_program_template = 'do_nothing.txt';     % already existing template to write 
% --------------------------------

if exist([path folder], 'dir')
    disp('/!\ please delete the existing directory');
else
    mkdir([path folder])
    disp(['directory : ' folder]);
    
    f = fopen([path folder 'MOTOR.txt'], 'wt'); % demo
    template = fopen(fullfile(path, motor_program_template), 'rt'); % template motor file
    while ~feof(template)
        cmd = fgetl(template);
        fprintf(f, cmd);
        fprintf(f, '\n');
    end
    fclose(template);
    fclose(f);
end


%% write motor program

disp('write commands in the file !')
system(['notepad ' path folder 'MOTOR.txt']);

%% program motor

disp('wait ~ 30 seconds');
tic
motor.program([path folder 'MOTOR.txt']);
toc

%% --test motor program--
motor.startProgram()
pause(0.2);
MotorAngle = []
TimeS = []


k = 0
tic

figure
while toc < DURATION
    MotorAngle(end+1) = motor.readPos();
    TimeS (end + 1) = toc;
     if ~mod(k,20);
         plot (TimeS, MotorAngle);
         pause (0.2);
    end
    k = k+1;
   
end
%%
motor.moveAbs(0)
pause(1)
motor.setSpeed(0)
pause (1)
pos24 = motor.readPos()


%% -------- STOP ---------
motor.stop()
pause(1)
motor.moveAbs(0)
pause (1)
motor.setSpeed(0)
pause(1)
pos0 = motor.readPos()


%%
% --- third section : do the experiment

%% start sequence

motor.startProgram() % start sequence at step 1
pause(0.2);

% init

vw = VideoWriter([path folder 'video'], 'Grayscale AVI'); % /!\ I changed this to grayscale AVI
open(vw);
TimeStamp = [];     % timestamp
TailAngle = [];     % angle of the tail
MotorAngle = [];    % angle of the motor
% PatternAngle = [];


start(camera.handle)

i=0;
tic

while toc < DURATION
  
    [fish, TimeStamp(end+1), ~, TailAngle(end+1)] = Fish(camera); %#ok<SAGROW>
    TailAngle(end) = TailAngle(end) + (TailAngle(end)<0)*180;
    MotorAngle(end+1) = motor.readPos(); %#ok<SAGROW>
    
    writeVideo(vw, fish); % uint8(BinFish)*255
    
%     projector.setAngle(MotorAngle(end) * GAIN)
%     projector.refresh()
%     follow(motor, projector, 1)
%     PatternAngle(end+1) = projector.windmill.angle; %#ok<SAGROW>

    if ~mod(i,20)
        
        subplot(211); plot(TimeStamp,TailAngle);
        ylim([70 100])
        subplot(212); plot(TimeStamp,MotorAngle);
        
    end
    i=i+1;

end
title (folder)
%if you interrupt the progtram during the loop, you have to run this to
%close the video object and the video writer
stop(camera.handle)
close(vw);

% stop 

motor.stop()
pause(0.2)
motor.home()

% save data

Data.MotorAngle = MotorAngle;
Data.TailAngle = TailAngle;
Data.TimeStamp = TimeStamp;
% Data.PatternAngle = PatternAngle;

save([path folder 'data'], 'Data');
savefig([path folder 'fig']);

%% if erreor or program interrupted, run this, and then delete the empty video file

delete(vw)
clear vw
stop(camera.handle)

%%

figure 
hold on
plot (Data.TimeStamp, Data.MotorAngle) 
plot (Data.TimeStamp, Data.TailAngle -96)


