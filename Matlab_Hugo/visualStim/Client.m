classdef Client < Module
    properties
    end
    methods
        function self = Client() % contructor
            self = self@Module('client');
        end
        
        function restart(self) % restart communication with server
            fclose(self.socket); fopen(self.socket);
        end
    end
    
    methods (Hidden)
        function send(self, str) % print caracter array and newline character
            fprintf(self.socket, str);
        end
        function write(self, num) % write 64bits floating point number
            fwrite(self.socket, num, 'double');
        end
    end
end
