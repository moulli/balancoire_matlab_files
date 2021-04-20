function [output] = vestibularVisual(params, handles)
%vestibularVisual does a vestibular and visual feedback for each tail bout
% params.speed is the falling speed
% params.duration is the duration of the loop or the maximum duration if params.sleepTime is defined
% params.moment_threshold is the threshold of detection
% params.correctionTime is the duration of the visual correction
% handles.vid,.vwriter,.motor are the handles

rspeed = params.rspeed; % usually zero
speed = rspeed; % initial value

% memory allocation
Nimg = params.duration * 60 * 50;
Nimg = round(Nimg);
TimeStamp = NaN(1,Nimg);
TailAngle = NaN(1,Nimg);
TailBout = false(1,Nimg);
MotorAngle = NaN(1,Nimg);
% PatternAngle=NaN(1,Nimg);
PatternSpeed=NaN(1,Nimg);

% initialisation
n = 1;
turning = false;    % this boolean is set to true when the motor is turning
swimming = false;   % this boolean is set to true when the pattern is moving

stop(handles.camera.handle)    % makes sure that the vid object is stopped (optionnal)
start(handles.camera.handle)   %

% loop

handles.motor.setSpeed(params.speed) % starts the motor rotation
pause(0.01)

tic;    % timer for the whole experiment
h=tic;  % timer for the interbout time
s=tic;  % timer for the sleep time

handles.proj.speedLoop;
handles.proj.setSpeed(-speed);

while toc < params.duration * 60
%     [~, timeStamp, ex, theta] = Fish(handles.camera);    % gets the binfish and timestamp
    [frame, timeStamp, ~, theta] = Fish(handles.camera);    % gets the fish and timestamp
%     writeVideo(handles.vwriter, uint8(ex)*255);
    writeVideo(handles.vwriter, frame);
    
    TimeStamp(n) = timeStamp;
    TailAngle(n) = theta;
%     PatternAngle(n) = handles.projector.windmill.angle;
    PatternSpeed(n) = speed;
    MotorAngle(n) = handles.motor.readPos();
    
    if n == 1   % the first diff is null
        dm = 0;
    else        % computes the diff of the tail movement (speed of tail)
        dm = TailAngle(n) - TailAngle(n-1);
    end
    
    % if the tails does a large movement, triggers the motor
    if abs(dm) > params.moment_threshold && toc(h) > params.interboutTime
        TailBout(n) = true;
        h = tic;    % reference time for the interbout
        s = tic;    % reference time for the sleep
        turning = true;
        handles.motor.moveRel(params.correctionAngle);
        if ~swimming % if the visual pattern is not already moving
            speed = params.rcorrect; % set speed to rcorrect
        end
        swimming = true;
        handles.proj.setSpeed(-speed);
    end
        
    % stops the pattern after the inertia time
    if swimming && toc(h) > params.correctionTime
        swimming = false;
        speed = rspeed; % sets back the speed to rspeed (zero, usually)
        handles.proj.setSpeed(-speed);
    end
    
    % lets enough time to move the motor
    if turning && toc(h) > 0.2
        turning = false;
        handles.motor.setSpeed(params.speed)
    end
    
    % if the fish is inactive for more than params.sleepTime, ends the function
    if isfield(params, 'sleepTime') && toc(s) > params.sleepTime * 60
        break
    end
    
    n = n+1;
end


% stop
handles.proj.stopLoop;
handles.motor.home()
stop(handles.camera.handle)

% save

TimeStamp = TimeStamp-TimeStamp(1);
TimeStamp(isnan(TimeStamp))=[]; % get rid of the unnecessary pre-allocated space
output.TimeStamp = TimeStamp;

TailAngle=TailAngle(1:size(TimeStamp,2)); % idem
output.TailAngle = TailAngle;

MotorAngle = MotorAngle(1:size(TimeStamp,2)); % idem
output.MotorAngle = MotorAngle;

% PatternAngle = PatternAngle(1:size(TimeStamp,2)); % idem
% output.PatternAngle = PatternAngle;

PatternSpeed = PatternSpeed(1:size(TimeStamp,2)); % idem
output.PatternSpeed = PatternSpeed;

TailBout = TailBout(1:size(TimeStamp,2)); % idem
output.TailBout = TailBout;

end
