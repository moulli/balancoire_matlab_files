classdef PsychLoop < Server
% the PsychLoop class helps handling the TCP/IP communication with psychtoolbox
    properties
        proj % psychtoolbox wrapper object
    end
    properties (Constant)
        MAX_REFRESH_RATE = 60
    end
    methods
        function commandParser(self)
            command = commandParser@Server(self);
            % single commands
            switch command
                case 'proj'
                    self.initProj()
                case 'start'
                    self.demoLoop()
                case 'stop'
                    disp('not implemented')
                case 'speedLoop'
                    self.speedLoop()
                case 'sine'
                    self.demoSine();
                otherwise
                % multiple part commands
                if startsWith(command, "pause") % EX: pause 2
                    cmd = split(command);
                    pause(str2double(cmd(2)));
                elseif startsWith(command, "changePattern")
                    cmd = split(command);
                    self.changePattern(str2double(cmd(2)), str2double(cmd(3)), str2double(cmd(4)));
                elseif startsWith(command, "translate")
                    cmd = split(command);
                    self.translate(str2double(cmd(2)), str2double(cmd(3)));
                end
            end
        end
        
        function speedLoop(self)
            % no newline character should be send during the loop
            % only double should be send during the loop
            speed = 0;
            while true
                pause(1/self.MAX_REFRESH_RATE);
                if self.socket.BytesAvailable
                    speed = fread(self.socket, 1, 'double');
                    if isnan(speed)
                        break
                    else
                        fprintf('%f', self.proj.windmill.angle);
                    end
                else
                    self.proj.addAngle(speed / self.MAX_REFRESH_RATE);
                    self.proj.refresh;
                end
            end
        end
        
        function initProj(self)
            self.proj = Psychtoolbox;
        end
        function changePattern(self, windmillWingNumber, horizonAngle, power)
            self.proj.windmill.WindmillWingNumber = windmillWingNumber;
            self.proj.windmill.HorizonAngle = horizonAngle;
            self.proj.windmill.power = power;
            self.proj.drawWindmill()
            self.proj.refresh()     % rafraichit l'�cran
        end
        function translate(self, x,y)
            self.proj.translate(x,y)
        end
    end
end