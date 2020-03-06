function [frame, timestamp, theta, segment_pts, coms, polygons] = getAngle(camera, varargin)


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
    
    
    %% Get outputs
    
    % Get frame from camera
    [frame, timestamp] = p.Results.camera.getFrame();
    frame = mean(frame, 3);

    % Tail track with segmentTracking
    [segment_pts, coms, polygons] = segmentTracking(frame, 'num_segments', p.Results.num_segments, 'inertia', p.Results.inertia, ...
                                                    'body_length', p.Results.body_length, 'tail_length', p.Results.tail_length, ...
                                                    'initial_box', p.Results.initial_box, 'box_increment', p.Results.box_increment, ...
                                                    'num_pix1', p.Results.num_pix1, 'num_pix2', p.Results.num_pix2);

    % Get total angle
    [angles, angle0] = getTrackingAngles(segment_pts);
    theta = sum([angle0; angles]);
    
    
end