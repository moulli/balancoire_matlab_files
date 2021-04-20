function [output] = static(params, handles)
%static does nothing to the fish and records its tail movement
% params.duration is the duration
% handles.vid,.vwriter,.serialMotor are the handles


% memory allocation
Nimg = params.duration * 60 * 50;
TimeStamp = NaN(1,Nimg);
TailAngle = NaN(1,Nimg);

% initialisation
n = 1;
stop(handles.camera.handle)
start(handles.camera.handle)

% loop
tic;
 
while toc < params.duration * 60
    [frame, timeStamp, ~, theta] = Fish(handles.camera);
    
    writeVideo(handles.vwriter, frame);
    TimeStamp(n) = timeStamp;
    TailAngle(n) = theta;

    n = n+1;
end


% stop

stop(handles.camera.handle)

% save

TimeStamp = TimeStamp-TimeStamp(1);
TimeStamp(isnan(TimeStamp))=[]; % on vire les NaN en trop
output.TimeStamp = TimeStamp;
TailAngle=TailAngle(1:size(TimeStamp,2)); % on coupe � la fin des temps
output.TailAngle = TailAngle;

end
