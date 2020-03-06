function prerun(camera, varargin)
%prerun runs a loop to see the fish during 'duration' seconds
% !!! see segmentTracking function for inputs indication !!!


    %% Check inputs
    
    % Default values
    defaultDuration = 10;
    defaultNumSegs = 12;
    defaultTailLength = 80; % tail usually between 80 and 95 pixels
    defaultBodyLength = 35; % in pixels as well
    defaultInertia = 0;
    defaultNumPix1 = 100; % number of pixels for COM 1
    defaultNumPix2 = 500; % number of pixels for COM 2
    defaultInitialBox = 0.3;
    defaultBoxIncrement = 0.03;
    
    % Input parser
    p = inputParser;
    addRequired(p, 'camera');
    addOptional(p, 'duration', defaultDuration);
    addOptional(p, 'num_segments', defaultNumSegs);
    addOptional(p, 'tail_length', defaultTailLength);
    addOptional(p, 'body_length', defaultBodyLength);
    addOptional(p, 'inertia', defaultInertia);
    addOptional(p, 'num_pix1', defaultNumPix1);
    addOptional(p, 'num_pix2', defaultNumPix2);
    addOptional(p, 'initial_box', defaultInitialBox);
    addOptional(p, 'box_increment', defaultBoxIncrement);
    parse(p, camera, varargin{:});
    
    
    %% prerun actual function

    time = p.Results.duration; % time in seconds

    disp('make sure that the fish is well detected')
    figure;
    tail = NaN(1, 30*60);
    i = 1;

    stop(p.Results.camera.handle)
    start(p.Results.camera.handle)

    tic

    while toc < time  % time in seconds
        
        % Get parameters of image using getAngle
        [frame, ~, tail(i), segment_pts, coms, polygons] = getAngle(p.Results.camera, 'num_segments', p.Results.num_segments, 'inertia', ...
                                                                    p.Results.inertia, 'body_length', p.Results.body_length, ...
                                                                    'tail_length', p.Results.tail_length, 'initial_box', ...
                                                                    p.Results.initial_box, 'box_increment', p.Results.box_increment, ...
                                                                    'num_pix1', p.Results.num_pix1, 'num_pix2', p.Results.num_pix2);

        % Nice plot to check parameters
        if ~mod(i, 30) || abs(tail(end-1) - tail(end)) > 0.04
            subplot(3, 1, 1)
                plot(tail)
                title('Tail angle')
            subplot(3, 1, 2)
                plot(diff(tail))
                title('diff of tail angle')
            subplot(3, 1, 3)
                hold on
                image(frame, 'CDataMapping', 'scaled')
                plot(coms(:, 2), coms(:, 1), 'o')
                plot(segment_pts(:, 2), segment_pts(:, 1), 'r')
                for j = 1:length(polygons)
                    plot(polygons{j}(:, 2), polygons{j}(:, 1), 'g')
                end
                axis equal
                hold off
                title(i)
        end
        
        % Update i
        i = i+1;
    end

    stop(p.Results.camera.handle)

    disp('framerate')
    disp(i/time)
    disp('if the framerate is too low, check if your camera framerate does not limit it')
end