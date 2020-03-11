function vestibularLaunch(duration, path, handles, speed, gain, proto_name, track_params)

    % Create video writer and save it in handles
    vw = VideoWriter([path '.avi'], 'Grayscale AVI');
    handles.vwriter = vw; % adds videowriter
    % Open video writer
    open(vw);
    
    % Build parameters structure
    params.duration = duration; % duration [minutes]
    % Vestibular parameters
    params.moment_threshold = 6; % moment threshold for triggering an action
    params.interboutTime = 0.5; % minimum time before triggering another correction [seconds]
    params.speed = speed; % rotation of pattern [degrees per second]
    % Correction parameters
    params.multiplicator = 0.4; % multiplicator to which pattern correction length is multiplied by
    params.gain = gain; % coefficient by which multiplicator is multiplied (to use in adaptation)
    params.correctionLength = params.multiplicator * abs(params.gain); % length of correction [seconds]
    params.rcorrect = sign(gain) * 60; % pattern correction speed [degrees per second]
    
    % Delete pattern if baseline mode
    if isequal(proto_name, 'baseline')
        windmillWingNumber = 8;
        horizonAngle = 180;
        power = 0.5;
    else
        windmillWingNumber = 8;
        horizonAngle = 180;
        power = 1;
    end
    handles.proj.changePattern(windmillWingNumber, horizonAngle, power);

    % Launch function responsible for movement
    obj = vestibularMove(params, handles, track_params);
    
    % Save additional parameters
    obj.StartTime = handles.StartTime; % sauve le temps de départ
    obj.params = params; % sauve les paramètres spécifiques
    % And parameters related to pattern
    obj.pattern.windmillWingNumber = windmillWingNumber;
    obj.pattern.horizonAngle = horizonAngle;
    obj.pattern.power = power;
    
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