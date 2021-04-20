%% --- define the parameters (limit angle) specific for tilting

motor.home()
motor.setSoftLimits(-60, 60)
motor.degreePerStep = - 0.006;

% all the handles in one structure

proj.translate(0,-20)
handles.camera = camera;
handles.proj = proj;
handles.motor = motor;

%% launches the experiment

clc % clear command line

% chose the record path
% recordpath= 'D:\DataHugo\2018-06\28\f01_test_1\';
recordpath= 'D:\DataHippolyte\2020-01\24\f01_test_1\';

% creates the directory if possible
[s,mess,~] = mkdir(recordpath);
if strcmp(mess,'Directory already exists.')
    disp('please change the path or delete the existing folder')
    return
else    
    disp(['directory "' recordpath '" created'])
end

disp('      ___________________________________________________________')
disp('      |                                                         |')
disp('      |                                                         |')
disp('      |                  EXPERIMENT IN PROGRESS                 |')
disp('      |                                                         |')
disp('      |_________________________________________________________|')

% % % % % % % % % % % % protocol { type, duration (minutes), [options] }
repetitions = 1;        % number of times the protocol will be repeated
protocol = {
    
%     'changePattern', 0, {'WindmillWingNumber', 16, 'HorizonAngle', 0, 'Power', 1};
%     'static', 1, {};  
% %     'changePattern', 0, {'WindmillWingNumber', 12, 'HorizonAngle', 180, 'Power', 1};
% %     'retrOMR', 0.2, {};
%     'auto', 60, {'speed', -4, 'correctionAngle', 10};



% % THE protocol n°1 ~ (12 min) croissant
%     'changePattern', 0, {'WindmillWingNumber', 16, 'HorizonAngle', 220, 'Power', 1};
%     'static', 0.2, {};  
%     'retrOMR', 0.8, {};
%     'static', 0.1, {};  
%     'changePattern', 0, {'WindmillWingNumber', 16, 'HorizonAngle', 0, 'Power', 1};
%     'static', 0.2, {};  
%     'visual', 0.8, {'rspeed', -2, 'rangle', +10};
%     'static', 0.2, {};  
%     'visual', 0.8, {'rspeed', -4, 'rangle', +10};
%     'static', 0.2, {};  
%     'visual', 0.8, {'rspeed', -6, 'rangle', +10};
% %     'static', 0.1, {};  
% %     'changePattern', 0, {'WindmillWingNumber', 16, 'HorizonAngle', 0, 'Power', 1};
%     'static', 0.2, {};  
%     'vestibular', 0.8, {'speed', -2, 'correctionAngle', +10};
%     'static', 0.2, {};  
%     'vestibular', 0.8, {'speed', -4, 'correctionAngle', +10};
%     'static', 0.2, {};  
%     'vestibular', 0.8, {'speed', -6, 'correctionAngle', +10};
%     'static', 0.2, {};  
%     'changePattern', 0, {'WindmillWingNumber', 0, 'HorizonAngle', 0, 'Power', .5};
%     'static', 0.2, {};  
%     'vestibular', 0.8, {'speed', -2, 'correctionAngle', +10};
%     'static', 0.2, {};  
%     'vestibular', 0.8, {'speed', -4, 'correctionAngle', +10};
%     'static', 0.2, {};  
%     'vestibular', 0.8, {'speed', -6, 'correctionAngle', +10};
%     'static', 0.2, {};   
    
% protocol up and down
    'changePattern', 0, {'WindmillWingNumber', 16, 'HorizonAngle', 220, 'Power', 1};
    'static', 5, {};  
    'retrOMR', 1, {};
    'static', 0.1, {};  
    'changePattern', 0, {'WindmillWingNumber', 16, 'HorizonAngle', 0, 'Power', 1};
    'static', 0.2, {};  
    'visual', 0.8, {'rspeed', +2, 'rangle', -10};
    'static', 0.2, {};  
    'visual', 0.8, {'rspeed', +4, 'rangle', -10};
    'static', 0.2, {};  
    'visual', 0.8, {'rspeed', +6, 'rangle', -10};
    'static', 0.2, {};  
    'vestibular', 5, {'speed', +2, 'correctionAngle', -10};
    'static', 1, {};  
    'vestibular', 5, {'speed', +4, 'correctionAngle', -10};
    'static', 1, {};  
    'vestibular', 5, {'speed', +6, 'correctionAngle', -10};
    'static', 1, {};  
    'changePattern', 0, {'WindmillWingNumber', 0, 'HorizonAngle', 0, 'Power', .5};
    'static', 1, {};  
    'vestibular', 5, {'speed', +2, 'correctionAngle', -10};
    'static', 1, {};  
    'vestibular', 5, {'speed', +4, 'correctionAngle', -10};
    'static', 1, {};  
    'vestibular', 5, {'speed', +6, 'correctionAngle', -10};
    'static', 1, {};   
    
    'changePattern', 0, {'WindmillWingNumber', 16, 'HorizonAngle', 220, 'Power', 1};
    'static', 1, {};  
    'retrOMR', 1, {};
    'static', 0.1, {};  
    'changePattern', 0, {'WindmillWingNumber', 16, 'HorizonAngle', 0, 'Power', 1};
    'static', 0.2, {};  
    'visual', 0.8, {'rspeed', -2, 'rangle', +10};
    'static', 0.2, {};  
    'visual', 0.8, {'rspeed', -4, 'rangle', +10};
    'static', 0.2, {};  
    'visual', 0.8, {'rspeed', -6, 'rangle', +10};
    'static', 0.2, {};  
    'vestibular', 5, {'speed', -2, 'correctionAngle', +10};
    'static', 1, {};  
    'vestibular', 5, {'speed', -4, 'correctionAngle', +10};
    'static', 1, {};  
    'vestibular', 5, {'speed', -6, 'correctionAngle', +10};
    'static', 1, {};  
    'changePattern', 0, {'WindmillWingNumber', 0, 'HorizonAngle', 0, 'Power', .5};
    'static', 1, {};  
    'vestibular', 5, {'speed', -2, 'correctionAngle', +10};
    'static', 1, {};  
    'vestibular', 5, {'speed', -4, 'correctionAngle', +10};
    'static', 1, {};  
    'vestibular', 5, {'speed', -6, 'correctionAngle', +10};
    'static', 1, {};  
    
    
% % THE protocol n°1 bis ~ (12 min) décroissant
%     'changePattern', 0, {'WindmillWingNumber', 12, 'HorizonAngle', 180, 'Power', 1};
%     'static', 0.5, {};  
%     'retrOMR', 0.8, {};
%     'static', 0.1, {}; 
%     'changePattern', 0, {'WindmillWingNumber', 12, 'HorizonAngle', 0, 'Power', 1}; 
%     'static', 0.2, {}; 
%     'visual', 0.8, {'rspeed', -6, 'rangle', 10};
%     'static', 0.2, {};  
%     'visual', 0.8, {'rspeed', -4, 'rangle', 10};
%     'static', 0.2, {};  
%     'visual', 0.8, {'rspeed', -2, 'rangle', 10};
%     'static', 0.2, {};  
%     'vestibular', 0.8, {'speed', -6, 'correctionAngle', 10};
%     'static', 0.2, {};  
%     'vestibular', 0.8, {'speed', -4, 'correctionAngle', 10};
%     'static', 0.2, {};  
%     'vestibular', 0.8, {'speed', -2, 'correctionAngle', 10};
%     'static', 0.2, {};  
%     'changePattern', 0, {'WindmillWingNumber', 0, 'HorizonAngle', 0, 'Power', .5};
%     'static', 0.2, {};  
%     'vestibular', 0.8, {'speed', -6, 'correctionAngle', 10};
%     'static', 0.2, {};  
%     'vestibular', 0.8, {'speed', -4, 'correctionAngle', 10};
%     'static', 0.2, {};  
%     'vestibular', 0.8, {'speed', -2, 'correctionAngle', 10};
%     'static', 0.2, {};   
%     
%     
%     'static', 2, {};  
    
    
% % THE protocol n°2 ~ (12 min) angle décroissant
%     'changePattern', 0, {'WindmillWingNumber', 12, 'HorizonAngle', 180, 'Power', 1};
%     'static', 0.2, {};  
%     'retrOMR', 0.9, {};
%     'static', 0.1, {}; 
%     'changePattern', 0, {'WindmillWingNumber', 12, 'HorizonAngle', 0, 'Power', 1};
%     'static', 0.2, {};  
%     'visual', 1.1, {'rspeed', -4, 'rangle', 10};
%     'static', 0.2, {};  
%     'visual', 1.1, {'rspeed', -4, 'rangle', 8};
%     'static', 0.2, {};  
%     'visual', 1.1, {'rspeed', -4, 'rangle', 6};
%     'static', 0.2, {};  
%     'vestibular', 1.1, {'speed', -4, 'correctionAngle', 10};
%     'static', 0.2, {};  
%     'vestibular', 1.1, {'speed', -4, 'correctionAngle', 8};
%     'static', 0.2, {};  
%     'vestibular', 1.1, {'speed', -4, 'correctionAngle', 6};
%     'static', 0.2, {};  
%     'changePattern', 0, {'WindmillWingNumber', 0, 'HorizonAngle', 0, 'Power', .5};
%     'static', 0.2, {};  
%     'vestibular', 1.1, {'speed', -4, 'correctionAngle', 10};
%     'static', 0.2, {};  
%     'vestibular', 1.1, {'speed', -4, 'correctionAngle', 8};
%     'static', 0.2, {};  
%     'vestibular', 1.1, {'speed', -4, 'correctionAngle', 6};
%     'static', 0.2, {};  

% % VESTIBULAR
%     'changePattern', 0, {'WindmillWingNumber', 16, 'HorizonAngle', 220, 'Power', 1};
%     'static', 0.4, {};  
%     'retrOMR', 0.8, {};
%     'static', 0.1, {};  
%     'changePattern', 0, {'WindmillWingNumber', 0, 'HorizonAngle', 0, 'Power', 0.5};
%     'static', 0.2, {};  
%     'vestibular', 0.8, {'speed', -2, 'correctionAngle', 10};
%     'static', 0.2, {};  
%     'vestibular', 0.8, {'speed', -3, 'correctionAngle', 10};
%     'static', 0.2, {};  
%     'vestibular', 0.8, {'speed', -4, 'correctionAngle', 10};
%     'static', 0.2, {};   
%     'vestibular', 0.8, {'speed', -5, 'correctionAngle', 10};
%     'static', 0.2, {};  
%     'vestibular', 0.8, {'speed', -6, 'correctionAngle', 10};
%     'static', 0.2, {};  
%     'vestibular', 0.8, {'speed', -7, 'correctionAngle', 10};
%     'static', 0.2, {};   
%     'vestibular', 0.8, {'speed', -8, 'correctionAngle', 10};
%     'static', 0.2, {};   

% % % % % % % % % % % % % % % % % % % % % % % % % % % %  end of protocol
    };

%%
protocol = {
    'changePattern', 0, {'WindmillWingNumber', 16, 'HorizonAngle', 220, 'Power', 1};
    'static', 0.1, {};  
    'retrOMR', 0.2, {};
    'static', 0.1, {};  
    'changePattern', 0, {'WindmillWingNumber', 16, 'HorizonAngle', 0, 'Power', 1};
    'static', 0.1, {};  
    'visual', 0.2, {'rspeed', +2, 'rangle', -10};
    'static', 0.1, {};  
    'visual', 0.2, {'rspeed', +4, 'rangle', -10};
    'static', 0.1, {};  
    'visual', 0.2, {'rspeed', +6, 'rangle', -10};
    'static', 0.1, {};  
    'vestibular', 0.2, {'speed', +2, 'correctionAngle', -10};
    'static', 0.1, {};  
    'vestibular', 0.2, {'speed', +4, 'correctionAngle', -10};
    'static', 0.1, {};  
    'vestibular', 0.2, {'speed', +6, 'correctionAngle', -10};
    'static', 0.1, {};  
    'changePattern', 0, {'WindmillWingNumber', 0, 'HorizonAngle', 0, 'Power', .5};
    'static', 0.1, {};  
    'vestibular', 0.2, {'speed', +2, 'correctionAngle', -10};
    'static', 0.1, {};  
    'vestibular', 0.2, {'speed', +4, 'correctionAngle', -10};
    'static', 0.1, {};  
    'vestibular', 0.2, {'speed', +6, 'correctionAngle', -10};
    'static', 0.1, {};   
    };

protocol = {
    'vestibular', 0.02, {'speed', +15, 'correctionAngle', -10};
    'vestibular', 0.01, {'speed', -13, 'correctionAngle', +10};
    'vestibular', 0.02, {'speed', +11, 'correctionAngle', -10};
    'vestibular', 0.01, {'speed', -14, 'correctionAngle', +10};
    'vestibular', 0.05, {'speed', +15, 'correctionAngle', -10};
    'changePattern', 0, {'WindmillWingNumber', 0, 'HorizonAngle', 0, 'Power', .5};
    'vestibular', 5, {'speed', -4, 'correctionAngle', +10};
    }
    
%%

% save the protocol
save([recordpath 'protocol'], 'protocol', 'repetitions');


% main loop
h=tic;
for i=1:repetitions
    for j = 1:size(protocol, 1)
        disp(protocol{j, 1}), disp(protocol{j, 2})
        exp = protocol{j,1};                            % type of experiment (static, retro, omr...)
        duration = protocol{j,2};                       % duration of experiment
        path = [recordpath int2str(i) '-' int2str(j) '-' exp];     % full path of file plus name. ex : D:\Hugo\2017-xx\1-3-static
        handles.StartTime = toc(h);                     % start time of experiment
        kwargs = protocol{j,3};                         % keyword arguments (speed, correct)
        % expCaller( exp, duration, path, handles, varargin )
        expCaller( exp, duration, path, handles, kwargs{:});
    end
end

% creates a figure to view the detail of the experiment and saves it
view_experiment;

savefig([recordpath 'trace']);
saveas(gcf,[recordpath 'trace.png']);

clc % clear command line

disp('      ___________________________________________________________')
disp('      |                                                         |')
disp('      |                  *                    *                 |')
disp('      |                    EXPERIMENT FINISHED                  |')
disp('      |                  *                    *                 |')
disp('      |_________________________________________________________|')


%% sample protocols

    
% %samples
%     'static', 0.4, {};
%     'visual', 2, {'rspeed', -5, 'rcorrect', 12};
%     'vestiVis', 2, {'speed', -2, 'correctionAngle', 20};
%     'changePattern', 0, {'WindmillWingNumber', 12, 'HorizonAngle', 200, 'Power', 0.9};
%     'auto', 3, {};

% %change pattern
%     'static', 0.02, {};    
%     'changePattern', 0, {'WindmillWingNumber', 0, 'HorizonAngle', 0, 'Power', 0.4};
%     'static', 0.02, {};    
%     'changePattern', 0, {'WindmillWingNumber', 12, 'HorizonAngle', 200, 'Power', 0.9};

% %test fish
%     'static', 0.3, {};
%     'visual', 0.3, {'rspeed', -2, 'rcorrect', 8};
%     'static', 0.3, {};
%     'vestibular', 2, {'speed', -2, 'correctionAngle', 8};
    
% %test fish ++
%     'static', 0.5, {};
%     'visual', 2.5, {'rspeed', -2, 'rcorrect', 8};
%     'static', 0.5, {};
%   

% % test fish +++
%     'changePattern', 0, {'WindmillWingNumber', 12, 'HorizonAngle', 180, 'Power', 1};
%     'static', 0.5, {};    
%     'visual', 0.5, {'rspeed', -2, 'rcorrect', 22, 'correctionTime', 0.4};  %slow
%     'visual', 0.5, {'rspeed', -15, 'rcorrect', 60, 'correctionTime', 0.2};  %fast
%     'vestibular', 1.5, {'speed', -2, 'correctionAngle', 8}; % sans feedback
%     'vestiVis', 1.5, {'speed', -2, 'correctionAngle', 8, 'rcorrect', 20, 'correctionTime', 0.2}; % avec feedback
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
    
% % vesti vis only
%     'static', 2, {};
%     'vestiVis', 10, {'speed', -0.5, 'correctionAngle', 12};
%     'vestiVis', 2.5, {'speed', -2, 'correctionAngle', 8};
    
% % vary vestibular
%     'changePattern', 0, {'WindmillWingNumber', 12, 'HorizonAngle', 200, 'Power', 1};
%     'static', .1, {};
%     'vestibular', 2, {'speed', -2, 'correctionAngle', 8};
%     'static', .1, {};
%     'vestibular', 2, {'speed', -2, 'correctionAngle', 9};
%     'static', .1, {};
%     'vestibular', 2, {'speed', -2, 'correctionAngle', 10};
%     'static', .1, {};
%     'vestibular', 2, {'speed', -2, 'correctionAngle', 11};

% % vary visual
%     'changePattern', 0, {'WindmillWingNumber', 12, 'HorizonAngle', 200, 'Power', 1};
%     'static', .1, {};
%     'visual', 2, {'rspeed', -10, 'rcorrect', 80, 'correctionTime', 0.2};



% % % % % % % % % % % % % % % % % % % % % 



% % with and without stripes
%     'static', 0.3, {};
%     'visual', 2, {'rspeed', -5, 'rcorrect', 12};
%     'static', 0.3, {};
%     'vestiVis', 2, {'speed', -2, 'correctionAngle', 8};
%     'static', 0.3, {};
%     'changePattern', 0, {'WindmillWingNumber', 0, 'HorizonAngle', 0, 'Power', 0.4};
%     'static', 0.3, {};
%     'vestiVis', 2, {'speed', -2, 'correctionAngle', 8};
%     'static', 0.3, {};
%     'changePattern', 0, {'WindmillWingNumber', 12, 'HorizonAngle', 200, 'Power', 0.9};
%     'static', 0.3, {};
%     'vestiVis', 2, {'speed', -2, 'correctionAngle', 8};
%     'static', 0.3, {};
%     'visual', 2, {'rspeed', -5, 'rcorrect', 12};
%     'static', 0.3, {};

% % vary contrast
%     'changePattern', 0, {'WindmillWingNumber', 12, 'HorizonAngle', 200, 'Power', 0.0};
%     'static', 0.1, {};
%     'vestibular', 1, {'speed', -3, 'correctionAngle', 10};
%     'static', 0.1, {};
%     'changePattern', 0, {'WindmillWingNumber', 12, 'HorizonAngle', 200, 'Power', 0.1};
%     'static', 0.1, {};
%     'vestibular', 1, {'speed', -3, 'correctionAngle', 10};
%     'static', 0.1, {};
%     'changePattern', 0, {'WindmillWingNumber', 12, 'HorizonAngle', 200, 'Power', 0.2};
%     'static', 0.1, {};
%     'vestibular', 1, {'speed', -3, 'correctionAngle', 10};
%     'static', 0.1, {};
%     'changePattern', 0, {'WindmillWingNumber', 12, 'HorizonAngle', 200, 'Power', 0.3};
%     'static', 0.1, {};
%     'vestibular', 1, {'speed', -3, 'correctionAngle', 10};   
%     'static', 0.1, {};
%     'changePattern', 0, {'WindmillWingNumber', 12, 'HorizonAngle', 200, 'Power', 0.4};
%     'static', 0.1, {};
%     'vestibular', 1, {'speed', -3, 'correctionAngle', 10};
%     'static', 0.1, {};
%     'changePattern', 0, {'WindmillWingNumber', 12, 'HorizonAngle', 200, 'Power', 0.5};
%     'static', 0.1, {};
%     'vestibular', 1, {'speed', -3, 'correctionAngle', 10};  
%     'static', 0.1, {};
    
% %around / under
%     %under
%     'changePattern', 0, {'WindmillWingNumber', 12, 'HorizonAngle', 200, 'Power', 1};
%     'static', 0.1, {};
%     'visual', 2, {'rspeed', -8, 'rcorrect', 22, 'correctionTime', 0.4};
%     'static', 0.1, {};
%     'vestibular', 2, {'speed', -3, 'correctionAngle', 10};    
%     'static', 0.1, {};
%     'changePattern', 0, {'WindmillWingNumber', 12, 'HorizonAngle', 0, 'Power', 1};
%     'static', 0.1, {};
%     'visual', 2, {'rspeed', -8, 'rcorrect', 22, 'correctionTime', 0.4};
%     'static', 0.1, {};
%     'vestibular', 2, {'speed', -3, 'correctionAngle', 10};    
%     'static', 0.1, {};

% %change pattern
%     'changePattern', 0, {'WindmillWingNumber', 12, 'HorizonAngle', 200, 'Power', 0.9};

% %de plus en plus d'information
% % darkness
% 'changePattern', 0, {'WindmillWingNumber', 0, 'HorizonAngle', 0, 'Power', 0};
% 'static', 0.1, {};
% 'vestibular', 2, {'speed', -2, 'correctionAngle', 8};    
% 'static', 0.1, {};
% % light
% 'changePattern', 0, {'WindmillWingNumber', 0, 'HorizonAngle', 0, 'Power', 1};
% 'static', 0.1, {};
% 'vestibular', 2, {'speed', -2, 'correctionAngle', 8};    
% 'static', 0.1, {};
% % horizon
% 'changePattern', 0, {'WindmillWingNumber', 0, 'HorizonAngle', 180, 'Power', 1};
% 'static', 0.1, {};
% 'vestibular', 2, {'speed', -2, 'correctionAngle', 8};    
% 'static', 0.1, {};
% % stripes under
% 'changePattern', 0, {'WindmillWingNumber', 14, 'HorizonAngle', 180, 'Power', 1};
% 'static', 0.1, {};
% 'visual', 2, {'rspeed', -2, 'rcorrect', 8};
% 'static', 0.1, {};
% 'vestibular', 2, {'speed', -2, 'correctionAngle', 8};    
% 'static', 0.1, {};
% % stripes around
% 'changePattern', 0, {'WindmillWingNumber', 14, 'HorizonAngle', 0, 'Power', 1};
% 'static', 0.1, {};
% 'visual', 2, {'rspeed', -2, 'rcorrect', 8};
% 'static', 0.1, {};
% 'vestibular', 2, {'speed', -2, 'correctionAngle', 8};    
% 'static', 0.1, {};

% %de moins en moins d'information
% % stripes around
% 'changePattern', 0, {'WindmillWingNumber', 14, 'HorizonAngle', 0, 'Power', 1};
% 'static', 0.1, {};
% 'visual', 2, {'rspeed', -2, 'rcorrect', 8};
% 'static', 0.1, {};
% 'vestibular', 2, {'speed', -2, 'correctionAngle', 8};    
% 'static', 0.1, {};
% % stripes under
% 'changePattern', 0, {'WindmillWingNumber', 14, 'HorizonAngle', 180, 'Power', 1};
% 'static', 0.1, {};
% 'visual', 2, {'rspeed', -2, 'rcorrect', 8};
% 'static', 0.1, {};
% 'vestibular', 2, {'speed', -2, 'correctionAngle', 8};    
% 'static', 0.1, {};
% % horizon
% 'changePattern', 0, {'WindmillWingNumber', 0, 'HorizonAngle', 180, 'Power', 1};
% 'static', 0.1, {};
% 'vestibular', 2, {'speed', -2, 'correctionAngle', 8};    
% 'static', 0.1, {};
% % light
% 'changePattern', 0, {'WindmillWingNumber', 0, 'HorizonAngle', 0, 'Power', 1};
% 'static', 0.1, {};
% 'vestibular', 2, {'speed', -2, 'correctionAngle', 8};    
% 'static', 0.1, {};
% % dark
% 'changePattern', 0, {'WindmillWingNumber', 0, 'HorizonAngle', 0, 'Power', 0};
% 'static', 0.1, {};
% 'vestibular', 2, {'speed', -2, 'correctionAngle', 8};    
% 'static', 0.1, {};

