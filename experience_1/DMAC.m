classdef DMAC < Motor
    %DMAC subclass of motor for the communication with the DMAC motor
    %   This uses a custom written serial function and should be used with
    %   care. In particular, writing something takes time. If you want to
    %   write several things, you should wait at least 0.2 seconds to have
    %   a chance that it is correctly written in the motor
    
    properties
        degreePerStep
        softlim_min
        softlim_max
    end
    
    methods
        function obj = DMAC()
            %DMACmotor contructor : inits the communication with the motor on port COM3
            %   this constructor keeps the serial port opened, if you mant
            %   to use a serial communication from an other program, you
            %   have to close the serial port before
            obj.degreePerStep = 0.006;
            obj.softlim_min = -10;
            obj.softlim_max = 10;
            obj.handle = serial('COM3','BaudRate',38400);
            fopen(obj.handle); pause(0.1)
            obj.defaultSettings()
        end
        
        function defaultSettings(obj)
            obj.home(); pause(0.1)
            obj.setSoftLimits(-10,10)
        end
        
        function setSoftLimits(obj, min, max)
            % Save limits
            obj.softlim_min = min;
            obj.softlim_max = max;            
            % Add them to motor
            DMAC_serial(obj, 'SEN ON')
            pause(0.2) % gives the time to send the line to the program
            DMAC_serial(obj, ['#NEN:=' int2str(min/abs(obj.degreePerStep))])
            pause(0.2) % gives the time to send the line to the program
            DMAC_serial(obj, ['#PEN:=' int2str(max/abs(obj.degreePerStep))])
            pause(0.2) % gives the time to send the line to the program
        end
        
        function softlims = getSoftLimits(obj)
            softlims = [obj.softlim_min, obj.softlim_max];
        end
        
        % --- the following functions could be generalized to the motor
        
        function moveAbs(obj, angle)
            obj.DMAC_serial(['MTO ' int2str(round(angle / obj.degreePerStep))])
        end
        
        function moveRel(obj, angle)
            obj.DMAC_serial(['MON ' int2str(round(angle / obj.degreePerStep))])
        end
        
        function setSpeed(obj, speed)
            obj.DMAC_serial(['MSP ' int2str(round(speed / obj.degreePerStep))])
        end
        
        function startProgram(obj)
            obj.DMAC_serial('SSE 1'); % start sequence at step 1
        end
        
        function stop(obj)
            obj.DMAC_serial('STO'); % stops the loop / motor
        end
        
        function home(obj)
            obj.moveAbs(0)
            pause(2)
            obj.DMAC_serial('STOP')
        end
        
        function pow(obj)
            obj.DMAC_serial('POW')
        end
        
        function setZero(obj)
            obj.DMAC_serial('#POS:=0')
        end
            
        
        function pos = readPos(obj)
            pos = obj.DMAC_readpos() * obj.degreePerStep;
        end
        
        % --- the following functions are specific to the DMAC
        function DMAC_serial(obj, chaine)
            %DMAC_serial sends a command to serial port in argument
            % modèle dans SYNTAXE_DMAC.pdf
            % summary : \x2(début) | taille_message | 00(module) | message | checksum_hexadécimal | \x3(fin)
            fprintf(obj.handle,...                  % handle on the serial port
                upper(...                           % for hexadecimal letters
                sprintf('\x2%03d00%s%02x\x3',...    % see summary
                size(chaine, 2)+2,...               % 00 plus size of the chain
                chaine,...                          % the command
                mod(sum(double(['00', chaine])),... % the checksum
                256))));                            
        end

        function pos = DMAC_readpos(obj)
            %DMAC_readpos reads the motor position
                % ask the motor to write its position in the serial buffer
            % [Hippolyte] OK just a bit of an explanation:
            % When we ask the motor for its position using 'READ #POS',
            % the motor sends us one caracter after the other. When we get
            % to caracter 61, which corresponds to '=', we can read the 
            % proper message. At this point we store this message in a. 
            % The caracter 26, which corresponds to \x3, marks the end of
            % the message. After this value, we will not be able to acquire
            % another value from the motor, and this operation will be 
            % very long if we still force. The problem I had was that
            % somehow, there was no '=' after reading position, after
            % instructing motor to reach an absolute position. But the 
            % caracter 26 appeared at some time. So what happened was this
            % program got stuck in the first while loop for tens of
            % seconds. So I added the possibility that the caracter given
            % by the motor can be 26. 
            obj.DMAC_serial('READ #POS');
            isnanpos = false;
            get_motor_message = 0;
            while get_motor_message ~= 61 % lecture jusqu'au signe égal '='
                get_motor_message = fread(obj.handle, 1, 'char');
                if get_motor_message == 26
                    pos = NaN;
                    isnanpos = true;
                end
            end
            if ~isnanpos
                a=0;
                while a(end) ~= 26 % lecture jusqu'à la fin '\x3'
                    tic
                    a = [a ; fread(obj.handle, 1, 'char')]; %#ok<AGROW>
                    if toc > 1
                        disp(a)
                    end
                end
                % does not check the checksum
                pos = str2double(char(a(2:end-4))');
                if size(pos,1) == 0 % if I can not read
                    pos = NaN;
                end   
            end
        end
        
        % --- this function reads a text file and programs the motor
        function program(obj, file)
            f = fopen(file, 'rt');  % opens file in write text mode
            while ~feof(f)          % until End Of File is reached
                cmd = fgetl(f);     % get line
                % cheks if the string is empty or contains a comment mark ('%')
                if ~isempty(cmd) && isempty(strfind(cmd, '%'))    
                    disp(cmd)
                    obj.DMAC_serial(cmd)     % sends the line to the motor
                    pause(0.3);         % wait enought time to let the motor read
                end
            end
            fclose(f);      % close the file
        end
    end   
end

% TODO write the destructor

% find out why the communication is so slow (0.2 seconds between each line)

% could add lambda functions for converting the degrees into steps and the oposite
% round(x / obj.degreePerStep)
% x * obj.degreePerStep;


