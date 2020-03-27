%% --- define the parameters (limit angle) specific for tilting

motor.home()
motor.setSoftLimits(-75, 75)
motor.degreePerStep = - 0.006;

% all the handles in one structure

handles.camera = camera;
handles.motor = motor;


%% launches the experiment

clc % clear command line


%% Number of fish for the day

FISH_NUMBER = 1;
FISH_AGE = 6;


%% Create adequate folder

% Automatically select a date
t = date;
month = t(4:6);
months = {'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'};
find_months = {'01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'};
for m = 1:length(months)
    if month == months{m}
        month = find_months{m};
        break
    end
end
yearmonth = strcat(t(8:11), '-', month);
day = t(1:2);
recordpath = fullfile('D:\DataHippolyte', yearmonth);
if numel(dir(recordpath)) == 0
    mkdir(recordpath);
end
recordpath = fullfile(recordpath, day);
if numel(dir(recordpath)) == 0
    mkdir(recordpath);
end

% Automatically chose the run based on the fish number
recordpath= fullfile(recordpath, strcat('fish', num2str(FISH_NUMBER), '_', num2str(FISH_AGE), 'dpf'));
if numel(dir(recordpath)) == 0
    mkdir(recordpath);
    run = 1;
else
    run = numel(dir(recordpath)) - 1;
end
recordpath = fullfile(recordpath, strcat('run', num2str(run)));
mkdir(recordpath)
fprintf('Directory created at %s \n', recordpath);


%% Show experiment is running on screen

disp('      ___________________________________________________________')
disp('      |                                                         |')
disp('      |                                                         |')
disp('      |                  EXPERIMENT IN PROGRESS                 |')
disp('      |                                                         |')
disp('      |_________________________________________________________|')


%% Define tracking parameters

track_params = struct;
track_params.num_segments = 10;
track_params.inertia = 0.6;
track_params.body_length = 0;
track_params.tail_length = 115;
track_params.initial_box = 0.3; % same as default value
track_params.box_increment = 0.03; % same as default value
track_params.num_pix1 = 100; % same as default value
track_params.num_pix2 = 500; % same as default value


%% Define protocol for experiment

% % % % % % % % % % % % protocol { type, duration (minutes), [options] }
repetitions = 1;        % number of times the protocol will be repeated

speedin = 4;
lengthin = 0.5;

switch run
    case 1
        % Case first run:
        protocol = {
                    'baseline', lengthin, 'speed', 0, 'gain', 0, 'initial_angle', 0;
                    'vestibular', lengthin, 'speed', -speedin, 'gain', +1, 'initial_angle', 0;
                    'vestibular', lengthin, 'speed', -speedin, 'gain', +1.25, 'initial_angle', 0;
                    'vestibular', lengthin, 'speed', -speedin, 'gain', +0.75, 'initial_angle', 0;
                    'vestibular', lengthin, 'speed', speedin, 'gain', -1, 'initial_angle', 0;
                    'vestibular', lengthin, 'speed', speedin, 'gain', -1.25, 'initial_angle', 0;
                    'vestibular', lengthin, 'speed', speedin, 'gain', -0.75, 'initial_angle', 0;
                    };
    otherwise
        % Case not first run:    
        protocol = {
                    'vestibular', lengthin, 'speed', -speedin, 'gain', +1, 'initial_angle', 0;
                    'vestibular', lengthin, 'speed', -speedin, 'gain', +1.25, 'initial_angle', 0;
                    'vestibular', lengthin, 'speed', -speedin, 'gain', +0.75, 'initial_angle', 0;
                    'vestibular', lengthin, 'speed', speedin, 'gain', -1, 'initial_angle', 0;
                    'vestibular', lengthin, 'speed', speedin, 'gain', -1.25, 'initial_angle', 0;
                    'vestibular', lengthin, 'speed', speedin, 'gain', -0.75, 'initial_angle', 0;
                    };
end
           
        
%% Launch actual experiment

% save the protocol
save(fullfile(recordpath, 'protocol'), 'protocol', 'repetitions');


% main loop
h=tic;
for i = 1:repetitions
    for j = 1:size(protocol, 1)
        % Basic parameters
        proto_name = protocol{j, 1};
        duration = protocol{j, 2}; % duration of experiment
        path = fullfile(recordpath, [int2str(i), '-', int2str(j), '-', protocol{j, 1}]); % full path of file plus name. ex : D:\Hugo\2017-xx\1-3-static
        handles.StartTime = toc(h); % start time of experiment
        % Get parameters from protocol
        speed = protocol{j, 4}; % speed for motor rotation
        gain = protocol{j, 6}; % gain after fish movement
        initial_angle = protocol{j, 8};
        % Launch function vestibularLaunch
        vestibularLaunch(duration, path, handles, speed, gain, proto_name, initial_angle, track_params);
    end
end

% creates a figure to view the detail of the experiment and saves it
view_experiment;

savefig(fullfile(recordpath, 'trace'));
saveas(gcf, fullfile(recordpath, 'trace.png'));


%% Show experiment is over on screen

% clc % clear command line

disp('      ___________________________________________________________')
disp('      |                                                         |')
disp('      |                  *                    *                 |')
disp('      |                    EXPERIMENT FINISHED                  |')
disp('      |                  *                    *                 |')
disp('      |_________________________________________________________|')

