%% exp viewer

clear ax

f = figure('units','normalized','outerposition',[0 0 1 1]);
ax(1) = subplot(411); hold on; title('ellipse moment'); xlabel('time(s)'); ylabel('ellipse moment');
ax(2) = subplot(412); hold on; title('tail speed'); xlabel('time(s)'); ylabel('tail speed');
ax(3) = subplot(413); hold on; title('vestibular stimulus'); xlabel('time(s)'); ylabel('motor angle');
ax(4) = subplot(414); hold on; title('bout or not'); xlabel('time(s)'); ylabel('bout (0 or 1)');


load(fullfile(recordpath, 'protocol'));

for i=1:repetitions
    for j=1:size(protocol, 1)
        exp = protocol{j,1};                                        % type of experiment (static, retrOMR ...)
        path = fullfile(recordpath, [int2str(i), '-', int2str(j), '-', protocol{j, 1}]);      % full path of file plus name. ex : D:\Hugo\2017-xx\1-3-static
%         expViewer(exp, path, f);                                    % expViewer( exp, path, f )
        load(path)  % LOAD
        figure(f)
        subplot(411); plot(obj.TimeStamp + obj.StartTime, obj.TailAngle, 'b');
        subplot(412); plot(obj.TimeStamp(1:end-1) + obj.StartTime, diff(obj.TailAngle), 'b');
        subplot(413); plot(obj.TimeStamp + obj.StartTime, obj.MotorAngle, 'b');
        subplot(414); plot(obj.TimeStamp + obj.StartTime, obj.TailBout, 'b');
        subplot(412); ylim([-15 15])
    end
end

linkaxes(ax, 'x');

