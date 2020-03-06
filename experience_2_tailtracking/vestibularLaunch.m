function vestibularLaunch(duration, path, handles, speed, gain, proto_name, initial_angle, track_params)

    % Create video writer and save it in handles
    vw = VideoWriter([path '.avi'], 'Grayscale AVI');
    handles.vwriter = vw; % adds videowriter
    % Open video writer
    open(vw);
    
    % Build parameters structure
    params.duration = duration; % duration [minutes]
    % Vestibular parameters
    params.moment_threshold = 9; % moment threshold for triggering an action
    params.interboutTime = 0.5; % minimum time before triggering another correction [seconds]
    params.speed = speed; % rotation of motor [degrees per second]
    % Correction parameters
    params.multiplicator = 10; % multiplicator to which fish moment is multiplied by
    params.gain = gain; % coefficient by which multiplicator is multiplied (to use in adaptation)
    params.correctionAngle = params.multiplicator*params.gain; % motor angular correction per swim bout [degrees]
    params.correctionLength = 0.2;
%     params.reinitializing = 0.5; % if fish does not move, reinintialize after this time [minutes]
    % Set initial angle after shaking
    params.initial_angle = initial_angle;

    % Launch function responsible for movement
    obj = vestibularMove(params, handles, track_params);
    
    % Save additional parameters
    obj.StartTime = handles.StartTime; % sauve le temps de départ
    obj.params = params; % sauve les paramètres spécifiques
    
    % Save data
    save(path, 'obj');
    % Close video writer
    close(vw);
    
    % Display some statistics on the screen
    disp(['Type of stimulus: ', proto_name])
    disp(['Number of bouts: ', num2str(sum(obj.TailBout))])
%     disp(['Mean angle at bouts: ', num2str(mean(obj.TailBout.*obj.TailAngle))])
%     disp(['Mean angle difference at bouts: ', num2str(mean(obj.TailBout(2:end).*diff(obj.TailAngle)))])
    
end