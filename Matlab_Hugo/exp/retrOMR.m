function [output] = retrOMR(params, handles)
%retrOMR does OMR with feedback
% params.rspeed is the rotation speed
% params.duration is the duration of the loop
% params.moment_threshold is the threshold of detection
% handles.vid,.vwriter are the handles

% local variables
rspeed = params.rspeed;
speed = rspeed; % initial value
rcorrect = params.rcorrect;

% memory allocation
Nimg = params.duration * 60 * 100;
TimeStamp = NaN(1,Nimg);
TailAngle = NaN(1,Nimg);
TailBout = false(1,Nimg);
% PatternAngle=NaN(1,Nimg);
PatternSpeed=NaN(1,Nimg);


% initialisation
n = 1;
swimming = 0;
stop(handles.camera.handle)
start(handles.camera.handle)

% loop

tic;
h=tic;

handles.proj.speedLoop;
handles.proj.setSpeed(-speed);
 
while toc < params.duration * 60

    [frame, timeStamp, ~, theta] = Fish(handles.camera);
    
    writeVideo(handles.vwriter, frame);
    TimeStamp(n) = timeStamp;
    TailAngle(n) = theta;
%     PatternAngle(n) = handles.projector.windmill.angle;
    PatternSpeed(n) = speed;
    
    if n == 1
        dm = 0;
    else
        dm = TailAngle(n) - TailAngle(n-1);
    end
    
    % if the tails does a first large movement, adds a negative speed to the rspeed
    if abs(dm) > params.moment_threshold && toc(h) > params.interboutTime
        TailBout(n) = true;
        h = tic;
        if swimming == 0 % if the fish was not previously swimming
            speed = rcorrect;
            handles.proj.setSpeed(-speed);
        end
        swimming = 1;
    end
    
    % swim inertia
    if swimming && toc(h) > params.correctionTime
        swimming = 0;
        speed = rspeed;
        handles.proj.setSpeed(-speed);
    end
    
    n = n+1;
end


% stop
stop(handles.camera.handle)
handles.proj.stopLoop;

% save

TimeStamp = TimeStamp-TimeStamp(1);
TimeStamp(isnan(TimeStamp))=[]; % on vire les NaN en trop
output.TimeStamp = TimeStamp;
TailAngle=TailAngle(1:size(TimeStamp,2)); % on coupe � la fin des temps
output.TailAngle = TailAngle;
% PatternAngle = PatternAngle(1:size(TimeStamp,2));    % idem
% output.PatternAngle = PatternAngle;
PatternSpeed = PatternSpeed(1:size(TimeStamp,2));
output.PatternSpeed = PatternSpeed;
TailBout = TailBout(1:size(TimeStamp,2));
output.TailBout = TailBout;

end
