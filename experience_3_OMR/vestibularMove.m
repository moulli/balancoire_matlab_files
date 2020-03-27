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
    TailBout = false(1, Nimg);
    PatternSpeed = NaN(1, Nimg);
    
    
    % Initializing camera
    stop(handles.camera.handle) % makes sure that the vid object is stopped
    start(handles.camera.handle)
    
    % Initializing parameters
    n = 1;
    swimming = false; % this boolean is set to true when the pattern is turning

    % Loop
    tic; % timer for the whole experiment
    h=tic; % timer for the interbout time and the straighening of the fish if it is not moving
    % Create two speed variables to deal with the pattern
    speed = params.speed;
    % Launch projector pattern
    handles.proj.speedLoop;
    handles.proj.setSpeed(speed);
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
        PatternSpeed(n) = speed;

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
            if swimming == false % if the fish was not previously swimming
                speed = params.rcorrect;
                handles.proj.setSpeed(speed);
            end
            swimming = true;
        end
        % If a trigger has been done recently, give time to the motor to straighten fish
        if swimming && toc(h) > params.correctionLength
            swimming = false;
            speed = params.speed;
            handles.proj.setSpeed(speed);
        end

        % Update indexing parameter
        n = n+1;
    end


    % Stop both the camera and the projector
    stop(handles.camera.handle)
    handles.proj.stopLoop;

    % Save all time series in output structure, deleting unnecessary pre-allocated space
    % Subtracting initial time to later times
    TimeStamp = TimeStamp-TimeStamp(1);
    % Get rid of unnecessary pre-allocated space
    TimeStamp(isnan(TimeStamp)) = [];
    TailAngle = TailAngle(1:size(TimeStamp,2));
    PatternSpeed = PatternSpeed(1:size(TimeStamp,2));
    TailBout = TailBout(1:size(TimeStamp,2));
    % Save in output
    output.TimeStamp = TimeStamp;
    output.TailAngle = TailAngle;
    output.PatternSpeed = PatternSpeed;
    output.TailBout = TailBout;

end
