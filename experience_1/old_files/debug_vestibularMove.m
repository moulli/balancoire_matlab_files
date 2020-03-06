params.duration = 1;
params.speed = -6;
params.reinitializing = 0.2;

% Initializing parameters
motor.moveAbs(0)
pause(2)
n = 1;
turning = false; % this boolean is set to true when the motor is turning
reinitializing = false; % gets set to true if fish has not moved in a long time
% Loop
handles.motor.setSpeed(params.speed) % starts the motor rotation
pause(0.01)
tic; % timer for the whole experiment
h=tic; % timer for the interbout time and the straighening of the fish if it is not moving

motor_POS = zeros(1, 0);

time_pos = zeros(0, 1);

% Main loop
while toc < params.duration * 60
    
    handles.motor.DMAC_serial('READ #POS');
    get_motor_message = 0;
    a = 0;
    while a(end) ~= 26 % lecture jusqu'à la fin
        fa = fread(handles.motor.handle, 1, 'char');
        if sum(fa == [127, 151, 183, 191, 247, 255]) == 1
            a = 0;
            break
        end
        a = cat(1, a, fa);
    end
    if a == 0
        pos = NaN;
    else
        pos = str2double(char(a(17:end-4))');
    end
    motor_POS = cat(2, motor_POS, pos);
    
    % If the fish is inactive for too long, reinitialize motor angle
    if toc(h) > params.reinitializing * 60 && abs(motor_pos) > 55 && reinitializing == false
        disp(toc(h)), disp(motor_pos), disp(-motor_pos + sign(motor_pos)*5)
        h = tic; % fake bout to set timer to 0
        reinitializing = true;
        softlims = handles.motor.getSoftLimits();
        motor_goal = (sign(params.speed) == -1)*softlims(2) + (sign(params.speed) == 1)*softlims(1);
        handles.motor.moveAbs(motor_goal);
    end
    % If reinintializing has been done recently, give time to the motor to straighten fish
    if reinitializing && toc(h) > 1.2
        disp(toc(h))
        reinitializing = false;
        handles.motor.setSpeed(params.speed)
    end

    % Update indexing parameter
    n = n+1;
end