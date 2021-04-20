classdef(Abstract) Module < handle 
% Module is a TCP/IP module
    properties
        socket % tcpip object
    end
    properties (Constant)
        PORT = 30000
    end
    methods
        function self = Module(role) % contructor
            self.startSocket(role);
        end
        function startSocket(self, role)
            self.socket = tcpip('localhost', self.PORT, 'NetworkRole', role); % 'client' or 'server'
            fopen(self.socket);
        end
    end
end
