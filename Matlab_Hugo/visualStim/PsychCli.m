classdef PsychCli < Client
% client class for PsychLoop tcpip communication
    properties
    end
    methods
        function initProj(self)
            self.send('proj');
        end
        function changePattern(self, windmillWingNumber, horizonAngle, power)
            command = join([...
                "changePattern",...
                num2str(windmillWingNumber),...
                num2str(horizonAngle),...
                num2str(power)...
                ]);
           self.send(command); 
        end
        function translate(self, x,y)
            command = join([...
                "translate",...
                num2str(x),...
                num2str(y),...
                ]);
           self.send(command); 
        end         
        
        function speedLoop(self) % start speed loop
            self.send('speedLoop');
        end
        function setSpeed(self, speed) % should be in speedLoop mode
            self.write(speed)
        end
        function stopLoop(self) % stop speed loop
            self.write(NaN)
        end
    end
end
