% http://psychtoolbox.org/
% http://peterscarfe.com/contrastradialcheckerboarddemo.html

classdef Psychtoolbox < handle
    %Psychtoolbox is a class for communicationg with psychtoolbox
    %   Detailed explanation goes here
    
    properties
        handle
            % struc with handles on the window...
        windmill
            % struct dedicated to the windmill parameters including angle
        screenNumber
            % number of the screen used for projection
    end
    
    methods
        function obj = Psychtoolbox()
            % choose the number of the screen
            obj.screenNumber = 2;
            %Psychtoolbox constructor : inits the psychtoolbox
            %   Detailed explanation goes here
            % to prevent syncing
            Screen('Preference', 'SkipSyncTests', obj.screenNumber); 
            % Here we call some default settings for setting up Psychtoolbox
            PsychDefaultSetup(2);
            % Open an on screen window (Screen('Screens') to see the screens)
            [obj.handle.window, obj.handle.windowRect] = PsychImaging('OpenWindow', obj.screenNumber, 0.0);
            % Set up alpha-blending for smooth (anti-aliased) lines
            Screen('BlendFunction', obj.handle.window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
            
            obj.defaultSettings();            
            obj.drawWindmill();
            obj.demoWindmill();
        end
        
        function defaultSettings(obj)
            obj.windmill.WindmillWingNumber = 12;     % gives the angular size of the stripes ex: 360�/(2*8) = 22.5�
            obj.windmill.CentralSpotSize = 120;       % central spot for keeping fish in dark
            obj.windmill.HorizonAngle = 200;          % angular size of the horizon
            obj.windmill.WindmillBorder = 0.3;        % percentage of the max circle size
            obj.windmill.color = [ 1 0.7 0.3 ];       % color of windmill (rgb)
            obj.windmill.power = 1;                   % power of windmill 0 < x < 1
            obj.windmill.angle = 0;                   % sets the angle of the stripes
            obj.drawWindmill();                       % draws the mill
        end
        
        function drawWindmill(obj)
            %drawWindmill updates the mill in obj.windmill
            
            % Number of white/black angular segment pairs (integer)
            tcycles = obj.windmill.WindmillWingNumber;
            sizefactor = obj.windmill.WindmillBorder; % size of the circle in which are the stripes

            % Now we make our checkerboard pattern
            xylim = 2 * pi;
            [x, y] = meshgrid(-xylim: 2 * xylim / (1024 - 1): xylim,...
                -xylim: 2 * xylim / (1024 - 1): xylim);
            at = atan2(y, x);
            stripes = (1 + sign(sin(at * tcycles) + eps)) / 2;

            black_ring = x.^2 + y.^2 <= xylim^2;
            circle = x.^2 + y.^2 <= sizefactor*xylim^2;
            stripes = circle .* stripes + 0.0 * ~black_ring;

            % rgb version
            rgbVersion = zeros(1024,1024,3);
            factor = obj.windmill.power;
            color = factor * obj.windmill.color;
            rgbVersion(:,:,1) = color(1)*double(stripes); % r
            rgbVersion(:,:,2) = color(2)*double(stripes); % g
            rgbVersion(:,:,3) = color(3)*double(stripes); % b
            stripes = rgbVersion;

            % Now we make this into a PTB texture
            obj.windmill.mill = Screen('MakeTexture', obj.handle.window, stripes);
        end
        
        function demoWindmill(obj)
            %demoWindmill plots the windmill with different grays for the different regions
            Screen('DrawTexture', obj.handle.window, obj.windmill.mill, [], [], obj.windmill.angle);
            Screen('FillArc', obj.handle.window, 0.1, ...
            CenterRectOnPointd([0 0 obj.handle.windowRect(4) obj.handle.windowRect(4)], ...
                obj.handle.windowRect(3)/2, obj.handle.windowRect(4)/2), ...
                180+(180-obj.windmill.HorizonAngle)/2, obj.windmill.HorizonAngle);
            Screen('FillArc', obj.handle.window, 0.2, ...
            CenterRectOnPointd([0 0 obj.windmill.CentralSpotSize obj.windmill.CentralSpotSize], ...
                obj.handle.windowRect(3)/2, obj.handle.windowRect(4)/2), 0, 360);

            % Flip to the screen
            Screen('Flip', obj.handle.window);
        end
        
        function changeAngle(obj, addAngle)
            %changeAngle is an alias for addAngle (depreciated)
            obj.addAngle(addAngle);
        end
        
        function addAngle(obj, angle)
            %addAngle adds addangle to the angle
            obj.windmill.angle = obj.windmill.angle + angle;
        end
        
        function setAngle(obj, angle)
            obj.windmill.angle = angle;
        end
        
        function translate(obj,x,y)
            Screen('glTranslate', obj.handle.window, x,y)
            obj.refresh();
        end
        
        function refresh(obj)
            %refresh plots the windmill, then the horizon, then the central spot
            Screen('DrawTexture', obj.handle.window, obj.windmill.mill, [], [], obj.windmill.angle);
            % then the horizon
            Screen('FillArc', obj.handle.window, 0, ...
            CenterRectOnPointd([0 0 obj.handle.windowRect(4) obj.handle.windowRect(4)], ...
                obj.handle.windowRect(3)/2, obj.handle.windowRect(4)/2), ...
                180+(180-obj.windmill.HorizonAngle)/2, obj.windmill.HorizonAngle);
            % finally the central spot
            Screen('FillArc', obj.handle.window, 0, ...
            CenterRectOnPointd([0 0 obj.windmill.CentralSpotSize obj.windmill.CentralSpotSize], ...
                obj.handle.windowRect(3)/2, obj.handle.windowRect(4)/2), 0, 360);
            
            Screen('Flip', obj.handle.window);  % double buffering (displays the buffer)
        end
    end
end






