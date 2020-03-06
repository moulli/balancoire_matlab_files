function output = vestibularMove_old(params, handles)
%vestibularVisual does a vestibular and visual feedback for each tail bout
% params.speed is the falling speed
% params.duration is the duration of the loop or the maximum duration if params.sleepTime is defined
% params.moment_threshold is the threshold of detection
% params.correctionTime is the duration of the visual correction
% handles.vid,.vwriter,.motor are the handles

    % Output components (memory allocation)
    Nimg = round(params.duration * 60 * 50);
    TimeStamp = NaN(1, Nimg);
    TailAngle = NaN(1, Nimg);
    MotorAngle = NaN(1, Nimg);
    MotorAngleGuess = zeros(1, Nimg);
    TailBout = false(1, Nimg);
    
    
    % Initializing camera
    stop(handles.camera.handle) % makes sure that the vid object is stopped
    start(handles.camera.handle)
    
    % Initializing parameters
    n = 1;
    turning = false; % this boolean is set to true when the motor is turning
%     reinitializing = false; % gets set to true if fish has not moved in a long time
    soft_lims = handles.motor.getSoftLimits();
    
    % Shake fish to possibly trigger brain
    handles.motor.moveAbs(soft_lims(2))
    pause(2)
    handles.motor.moveAbs(soft_lims(1))
    pause(2)
    handles.motor.moveAbs(soft_lims(2)-20)
    pause(2)
    % Loop
    handles.motor.setSpeed(params.speed) % starts the motor rotation
    pause(0.01)
    tic; % timer for the whole experiment
    h=tic; % timer for the interbout time and the straighening of the fish if it is not moving

    % Main loop
    while toc < params.duration * 60
        
        % Get fish information
        % [~, timeStamp, ex, theta] = Fish(handles.camera);    % gets the binfish and timestamp
        [frame, timeStamp, ~, theta] = Fish(handles.camera);    % gets the fish and timestamp
        % writeVideo(handles.vwriter, uint8(ex)*255);
        writeVideo(handles.vwriter, frame);

        % Save information in what will be outputted from this function
        TimeStamp(n) = timeStamp;
        TailAngle(n) = theta;
        motor_pos = handles.motor.readPos();
        MotorAngle(n) = motor_pos;
        if n > 1
            dt = TimeStamp(n) - TimeStamp(n-1);
            if turning
                mag = MotorAngleGuess(n-1) + true_correctionAngle*dt/get_straight;
            else
                mag = MotorAngleGuess(n-1) + params.speed*dt;
            end
            MotorAngleGuess(n) = soft_lims(1)*(mag<soft_lims(1)) + soft_lims(2)*(soft_lims(2)<mag) + ...
                                 mag*(soft_lims(1)<=mag&mag<=soft_lims(2));
        end

        % Compute differential of tail movement
        if n == 1 % the first diff is null
            dm = 0;
        else % computes the diff of the tail movement (speed of tail)
            dm = TailAngle(n) - TailAngle(n-1);
        end

        % Trigger straightening if differential is above specified value
        if abs(dm) > params.moment_threshold && toc(h) > params.interboutTime
            TailBout(n) = true;
            h = tic; % reference time for the interbout
            turning = true;
%             true_correctionAngle = params.correctionAngle*abs(dm);
            true_correctionAngle = 4 ./ (1 + exp(-0.3*(abs(dm)-10))) + 9;
            true_correctionAngle = true_correctionAngle * params.gain;
            get_straight = true_correctionAngle/50; % time left to the motor to straighten fish after bout
            get_straight = 0.1*(get_straight<0.1) + 0.4*(0.4<get_straight) + ...
                           get_straight*(0.1<=get_straight&get_straight<=0.4);
            disp([dm, true_correctionAngle, get_straight]);
            handles.motor.moveRel(true_correctionAngle);
        end
        % If a trigger has been done recently, give time to the motor to straighten fish
        if turning && toc(h) > get_straight
            turning = false;
            handles.motor.setSpeed(params.speed)
        end

%         % If the fish is inactive for too long, reinitialize motor angle
%         if toc(h) > params.reinitializing * 60
%             h = tic; % fake bout to set timer to 0
%             reinitializing = true;
%             handles.motor.moveRel(-motor_pos + sign(motor_pos)*5);
%         end
%         % If reinintializing has been done recently, give time to the motor to straighten fish
%         if reinitializing && toc(h) > 1.2
%             reinitializing = false;
%             handles.motor.setSpeed(params.speed)
%         end

        % Update indexing parameter
        n = n+1;
    end


    % Stop both the motor and the camera
    handles.motor.home()
    stop(handles.camera.handle)

    % Save all time series in output structure, deleting unnecessary pre-allocated space
    % Subtracting initial time to later times
    TimeStamp = TimeStamp-TimeStamp(1);
    % Get rid of unnecessary pre-allocated space
    TimeStamp(isnan(TimeStamp)) = [];
    TailAngle = TailAngle(1:size(TimeStamp,2));
    MotorAngle = MotorAngle(1:size(TimeStamp,2));
    MotorAngleGuess = MotorAngleGuess(1:size(TimeStamp,2));
    TailBout = TailBout(1:size(TimeStamp,2));
    % Save in output
    output.TimeStamp = TimeStamp;
    output.TailAngle = TailAngle;
    output.MotorAngle = MotorAngle;
    output.MotorAngleGuess = MotorAngleGuess;
    output.TailBout = TailBout;

end
