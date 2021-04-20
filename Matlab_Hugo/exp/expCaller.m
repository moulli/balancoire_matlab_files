function expCaller( exp, duration, path, handles, varargin )
%expCaller( exp, duration, path, handles, varargin )
%calls an experiment (retro, static, simpleloop, OMR)
%   exp: type of experiment (retro, static, rotate, omr...)
%   duration: duration in minutes of the experiment
%   path: full path of the experiment folder plus name of files
%   handles: objects containing different handles (camera, projector, motor, [vw])
%   VARARGIN ex : ('speed', 2, 'correct', 4)
%   Use to change the default parameters  (degrees per second, degrees)
    
    vw = VideoWriter([path '.avi'], 'Grayscale AVI');
    
    handles.vwriter = vw;  % adds videowriter
    params.duration = duration; % duration (minutes)
    
    p = inputParser;
       % general
       addParameter(p,'interboutTime',0.4);      % minimum time before triggering another correction (seconds)
       addParameter(p,'threshold',1);            % moment threshold for triggering an action
       
       % vestibular
       addParameter(p,'speed',-2);               % rotation of motor, degrees per second
       addParameter(p,'correctionAngle',8);      % motor angular correction per swim bout (degrees)
       
       % visual / OMR
       addParameter(p,'rspeed',-5);              % rotation speed of the visual pattern, degrees per second (negative means backwards)
       addParameter(p,'rcorrect',25);            % replaces rspeed when the fish is swimming, degrees per second
       addParameter(p,'correctionTime',0.3);     % duration of the fish's action for OMR, 'intertia'
       addParameter(p,'rangle',0);               % if set to a non null value, overwrites rcorrect with rangle/correctionTime
       
       % auto
       addParameter(p,'retrOMRduration',.5);     % duration of the retrOMR experiment after sleep (minutes)
       addParameter(p,'sleepTime', .3);          % authorized sleep time before retrOMR (minutes)  
        
       % pattern
       addParameter(p,'WindmillWingNumber', 14); % WindmillWingNumber
       addParameter(p,'HorizonAngle', 120);      % HorizonAngle (degrees)
       addParameter(p,'Power', 1);               % light intensity

    parse(p,varargin{:});
        
    if strcmp(exp, 'static') % calls static
    open(vw);
        obj = static(params, handles);
        
    elseif strcmp(exp, 'retrOMR') % calls retrOMR with specific parameters
    open(vw);
        params.moment_threshold     = p.Results.threshold;      % arbitrary unit
        params.interboutTime    = p.Results.interboutTime;  % seconds
        params.rspeed           = -12;    % degrees per second
        params.rcorrect         = 60;  % degrees per second
        params.correctionTime   = 0.2; % seconds
        params.rangle = params.correctionTime * params.rcorrect; % to have an idea of the corrected angle
        obj = retrOMR(params, handles);
        
    elseif strcmp(exp, 'visual') % calls retrOMR with given parameters
    open(vw);
        params.moment_threshold     = p.Results.threshold;      % arbitrary unit
        params.interboutTime    = p.Results.interboutTime;  % seconds
        params.rspeed           = p.Results.rspeed;    % degrees per second
        params.rcorrect         = p.Results.rcorrect;  % degrees per second
        params.correctionTime   = p.Results.correctionTime; % seconds
        if p.Results.rangle ~= 0 % sets rcorrect to the value such as the angle corrected is rangle
            params.rcorrect = p.Results.rangle / params.correctionTime;
        else
            params.rangle = params.correctionTime * params.rcorrect;
        end
        obj = retrOMR(params, handles);
        
    elseif strcmp(exp, 'vestibular') % calls vestibular without visual feedback
    open(vw);
        % vestibular parameters
        params.moment_threshold     = p.Results.threshold;      % arbitrary unit
        params.interboutTime        = p.Results.interboutTime;  % seconds
        params.speed                = p.Results.speed;          % degrees per second
        params.correctionAngle      = p.Results.correctionAngle;% degrees
        % visual parameters
        params.rspeed               = 0;                        % degrees per second
        params.rcorrect             = 0;                        % degrees per second
        params.correctionTime       = p.Results.correctionTime; % seconds
        obj = vestibularVisual(params, handles);
        
    elseif strcmp(exp, 'vestiVis') % calls vestibular with visual feedback
    open(vw);
        % vestibular parameters
        params.moment_threshold     = p.Results.threshold;      % arbitrary unit
        params.interboutTime        = p.Results.interboutTime;  % seconds
        params.speed                = p.Results.speed;          % degrees per second
        params.correctionAngle      = p.Results.correctionAngle;% degrees
        % visual parameters
        params.rspeed               = 0;                        % degrees per second
        params.rcorrect             = p.Results.rcorrect;       % degrees per second
        params.correctionTime       = p.Results.correctionTime; % seconds
        obj = vestibularVisual(params, handles);
        
    elseif strcmp(exp, 'auto') % calls automatic function which call vestibularVisual with sleep support
        % general parameters
        params.path                 = path;                     % the base path to which will be added the phase number
        % vestibular parameters
        params.moment_threshold     = p.Results.threshold;      % arbitrary unit
        params.interboutTime        = p.Results.interboutTime;  % seconds
        params.speed                = p.Results.speed;          % degrees per second
        params.correctionAngle      = p.Results.correctionAngle;% degrees
        params.sleepTime            = p.Results.sleepTime;      % minutes
        % visual parameters
        params.rspeed               = 0;                        % degrees per second
        params.rcorrect             = p.Results.rcorrect;       % degrees per second
        params.correctionTime       = p.Results.correctionTime; % seconds
        % omr parameters
        params.OMRrspeed            = -12;
        params.OMRrcorrect          = 60;
        params.OMRcorrectionTime    = 0.2; % seconds
        params.retrOMRduration      = p.Results.retrOMRduration;
        obj.autoNumber = auto(params, handles);
        
    elseif strcmp(exp, 'changePattern')        
        handles.proj.changePattern(p.Results.WindmillWingNumber, p.Results.HorizonAngle, p.Results.Power);
    end
    
    obj.StartTime = handles.StartTime;  % sauve le temps de d�part
    obj.params = params;                % sauve les param�tres sp�cifiques
%     obj.windmill = handles.projector.windmill; % sauve les param�tres globaux (utile si le moulin change)
    % ↑ miss pattern parameters (TODO change how it is recorded)
    
    save(path, 'obj');
    close(vw);
    
end

