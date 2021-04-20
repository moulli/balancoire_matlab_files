classdef Server < Module
    properties
    end
    methods
        function self = Server() % contructor
            self = self@Module('server');
            self.socket.BytesAvailableFcnMode = 'terminator'; % for each newline character detected
            self.socket.BytesAvailableFcn = @(src, evnt) self.commandParser; % call the parser
        end        
        function command = commandParser(self)
            command = fgetl(self.socket);
            fprintf('%s\n', command);
        end
        function do(self, str)
            self.commandParser(str);
        end
    end
end
