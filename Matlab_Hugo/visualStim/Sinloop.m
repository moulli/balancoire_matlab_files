classdef Sinloop < Server % for test purpose
    properties (Constant)
        MAX_REFRESH_RATE = 60
    end
    properties (Hidden) % for testing purpose
        f % figure 
        phi % phase
        freq % frequence
        dphi % speed
    end
    methods
        function commandParser(self)
            command = commandParser@Server(self);
            % single commands
            switch command
                case 'start'
                    self.demoLoop()
                case 'stop'
                    disp('not implemented')
                case 'sine'
                    self.demoSine();
                case 'initsine'
                    self.f = figure;
                    xlim([0 2*pi]);
                    ylim([-1 1]);
                    self.phi = 0;
                    self.freq = 1;
                    self.dphi = 0.05;
                    self.demoSine();
                otherwise
                % multiple part commands
                if startsWith(command, "pause") % EX: pause 2
                    cmd = split(command);
                    pause(str2double(cmd(2)));
                elseif startsWith(command, "setfreq")
                    cmd = split(command);
                    self.freq = str2double(cmd(2));
                    self.demoSine();
                end
            end
        end
    end
        
    methods (Hidden)
        function demoLoop(self)
            % no newline character should be send during the loop
            % only double should be send during the loop
            msg = "wait";
            while true
                pause(1/self.MAX_REFRESH_RATE);
                if self.socket.BytesAvailable
                    num = fread(self.socket, 1, 'double');
                    if isnan(num)
                        break
                    else
                        fprintf('num = %f\n', num);
                    end
                else
                    fprintf('%s\n', msg);
                end
            end
        end
        function demoSine(self)
            % this demo function is here for developping purpose
            figure(self.f);
            t = linspace(0,2*pi,500);
            s = @(phi) sin(self.freq*t + phi);
            while true
                pause(1/self.MAX_REFRESH_RATE);
                if self.socket.BytesAvailable
                    ndphi = fread(self.socket, 1, 'double');
                    if ~isnan(ndphi)
                        self.dphi = ndphi;
                    else
                        break
                    end
                end
                plot(t, s(self.phi));
                self.phi = self.phi + self.dphi;
            end
        end
    end
end