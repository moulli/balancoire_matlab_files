function output = vestibularMove(params, handles, track_params)
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
    soft_lims = handles.motor.getSoftLimits();
    
    % Shake fish to possibly trigger brain
    handles.motor.moveAbs(soft_lims(2)-30)
    pause(1.5)
    handles.motor.moveAbs(soft_lims(1)+30)
    pause(1.5)
    handles.motor.moveAbs(params.initial_angle)
    pause(6)     
    MotorAngleGuess(1) = params.initial_angle;

    % Loop
    handles.motor.setSpeed(params.speed) % starts the motor rotation
    pause(0.01)
    tic; % timer for the whole experiment
    h=tic; % timer for the interbout time and the straighening of the fish if it is not moving
    % Main loop
    while toc < params.duration * 60   
        
        % Get fish information
        [frame, timeStamp, theta] = getAngle(handles.camera, 'num_segments', track_params.num_segments, 'inertia', track_params.inertia, ...
                                             'body_length', track_params.body_length, 'tail_length', track_params.tail_length, ...
                                             'initial_box', track_params.initial_box, 'box_increment', track_params.box_increment, ...
                                             'num_pix1', track_params.num_pix1, 'num_pix2', track_params.num_pix2);
        writeVideo(handles.vwriter, frame);

        % Save information in what will be outputted from this function
        TimeStamp(n) = timeStamp;
        TailAngle(n) = theta;
        motor_pos = handles.motor.readPos();
        MotorAngle(n) = motor_pos;
        % Defining motor angle guess
        if n > 1
            dt = TimeStamp(n) - TimeStamp(n-1);
            if turning
                % Adapting angle, for no overshooting
                angle_corrected = params.correctionAngle*dt/params.correctionLength;
                angle_corrected = min([angle_corrected, params.correctionAngle - motor_angle_corrected]);
                motor_angle_corrected = motor_angle_corrected + angle_corrected;
                mag = MotorAngleGuess(n-1) + angle_corrected;
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
            motor_angle_corrected = 0;
            handles.motor.moveRel(params.correctionAngle);
        end
        % If a trigger has been done recently, give time to the motor to straighten fish
        if turning && toc(h) > params.correctionLength
            turning = false;
            handles.motor.setSpeed(params.speed)
        end

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
