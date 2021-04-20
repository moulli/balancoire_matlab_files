function expViewer( exptype, path, f )
% expViewer( exp, path, f )

    load(path)  % LOAD
    figure(f)
           
    if strcmp(exptype, 'static')
        subplot(411); plot(obj.TimeStamp + obj.StartTime, obj.TailAngle, 'g');
        subplot(412); plot(obj.TimeStamp(1:end-1) + obj.StartTime, diff(obj.TailAngle), 'g');
        
    elseif strcmp(exptype, 'retrOMR') || strcmp(exptype, 'visual')
        subplot(411); plot(obj.TimeStamp + obj.StartTime, obj.TailAngle, 'r');
        subplot(412); plot(obj.TimeStamp(1:end-1) + obj.StartTime, diff(obj.TailAngle), 'r');
%         subplot(414); plot(obj.TimeStamp + obj.StartTime, obj.PatternAngle, 'r');
        subplot(414); plot(obj.TimeStamp + obj.StartTime, cumsum(obj.PatternSpeed), 'r');
        
    elseif strcmp(exptype, 'vestibular') || strcmp(exptype, 'vestiVis')
        subplot(411); plot(obj.TimeStamp + obj.StartTime, obj.TailAngle, 'b');
        subplot(412); plot(obj.TimeStamp(1:end-1) + obj.StartTime, diff(obj.TailAngle), 'b');
        subplot(413); plot(obj.TimeStamp + obj.StartTime, obj.MotorAngle, 'b');
%         subplot(414); plot(obj.TimeStamp + obj.StartTime, obj.PatternAngle, 'b',...
%             obj.TimeStamp + obj.StartTime, obj.PatternAngle - obj.MotorAngle, 'c');
        subplot(414); plot(obj.TimeStamp + obj.StartTime, cumsum(obj.PatternSpeed), 'b',...
            obj.TimeStamp + obj.StartTime, cumsum(obj.PatternSpeed) - obj.MotorAngle, 'c');
            
    elseif strcmp(exptype, 'auto')
        for i=0:obj.autoNumber
            autopath = [obj.params.path '--' sprintf('%.2d', i)];
            
            l = load([autopath  '-1-vestibularVisual']);
            autobj = l.obj;
            subplot(411); plot(autobj.TimeStamp + autobj.StartTime, autobj.TailAngle, 'b');
            subplot(412); plot(autobj.TimeStamp(1:end-1) + autobj.StartTime, diff(autobj.TailAngle), 'b');
            subplot(413); plot(autobj.TimeStamp + autobj.StartTime, autobj.MotorAngle, 'b');
%             subplot(414); plot(autobj.TimeStamp + autobj.StartTime, autobj.PatternAngle, 'b');
            subplot(414); plot(autobj.TimeStamp + autobj.StartTime, cumsum(autobj.PatternSpeed), 'b');
            
            l = load([autopath  '-2-retrOMR']);
            autobj = l.obj;
            subplot(411); plot(autobj.TimeStamp + autobj.StartTime, autobj.TailAngle, 'r');
            subplot(412); plot(autobj.TimeStamp(1:end-1) + autobj.StartTime, diff(autobj.TailAngle), 'r');
%             subplot(414); plot(autobj.TimeStamp + autobj.StartTime, autobj.PatternAngle, 'r');
            subplot(414); plot(autobj.TimeStamp + autobj.StartTime, cumsum(autobj.PatternSpeed), 'r');
        end
    end
    subplot(412); ylim([-15 15])
    
end


