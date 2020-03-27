function baselineLaunch(duration, path, handles)

    % Create video writer and save it in handles
    vw = VideoWriter([path '.avi'], 'Grayscale AVI');
    handles.vwriter = vw; % adds videowriter
    % Open video writer
    open(vw);
    
    % Build parameters structure
    params.duration = duration; % duration [minutes]
    % Vestibular parameters
    params.moment_threshold = 2; % moment threshold for triggering an action
    params.interboutTime = 0.4; % minimum time before triggering another correction [seconds]
    
    % Launch function responsible for movement
    obj = goBaseline(params, handles);
    % Save additional parameters
    obj.StartTime = handles.StartTime; % sauve le temps de départ
    obj.params = params; % sauve les paramètres spécifiques
    
    % Save data
    save(path, 'obj');
    % Close video writer
    close(vw);
    
end