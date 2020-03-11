%%
path = 'D:\DataHippolyte\2020-02\05\fish1_5dpf\run1\1-6-vestibular.avi';
param.erode = 300; % Removes from the binary image all connected components that have fewer than "param.erode" pixels.

% Get number of frames
mov = VideoReader(path);
try 
    nframes = mov.NumFrames;
catch
    nframes = mov.NumberOfFrames;
end

figure;
% Create videoreader
mov = VideoReader(path);
% Create mesh tail image
frame = readFrame(mov);
imshow(frame);
h = impoint;
position = wait(h);  x = position(1); y = position(2); position
[mesh_tail] = meshgrid(1:size(frame,2),1:size(frame,1));% create matrix distance to axis
mesh_tail = mesh_tail-position(1);

% Create taillength
imshow(frame);
h = imline;
position = wait(h);
taillength = abs(position(3)-position(4)); position

% Create tail_pix (The number of pixel in the tail)
frame = frame(:,:,1);
frame = imbinarize(frame, 'adaptive','ForegroundPolarity','dark','Sensitivity',1);
frame = bwareaopen(frame,param.erode);
imshow(frame);
tail_pix = sum(frame(:) == 1);

% Compute moment, angle and curvature
mov = VideoReader(path);
frames = zeros(mov.Height, mov.Width, nframes);
angle = zeros(nframes);
count = 1; i_count = 1;
while hasFrame(mov)
    % Moment
    frame = readFrame(mov);
    frame = frame(:,:,1);
    frame = imbinarize(frame, 'adaptive','ForegroundPolarity','dark','Sensitivity',1);
    frame = bwareaopen(frame,300);
    seqmom = double(mesh_tail).*double(frame)/tail_pix/taillength; %grid on binarized image of tail
    moment(count) = squeeze(sum(sum(seqmom,1),2));
    frames(:,:,count) = frame; 

%     % Angle
%     Out{count} = get_ellipse(frame);
%     angle(count) = Out{count}.theta; 
%     
%     % Curvature
%     Out2{count} = get_ellipses_RLS(frame, x, y);
%     curv(count) = Out2{count}.curv;

%     count = count + 1;
%     if i >= i_count
%         clc; disp(['Frame number ', num2str(count), '/', num2str(nframes)]);
%         i_count = i_count +100;
%     end
    
end

% Plot moment, angle and curvature
for i = size(moment, 2)
    % Moment
    subplot(4,2,1); title('Moment');
    imshow(frames(:,:,i)); drawnow limitrate;
    li = line([x+(taillength*(sin(1000*moment(i)*pi/180))), x], [-(y+(taillength*(cos(1000*moment(i)*pi/180)))), y]);
    li.Color = 'red'; li.LineWidth = 2; drawnow limitrate;
    subplot(4,2,3:4);
    plot(moment(1:i)); drawnow limitrate; ylabel('Moment norm');
    
%     % Angle
%     subplot(4,2,2); title('Angle');
%     imshow(frames(:,:,i)); drawnow limitrate; hold on; draw_ellipse(Out{i},[1 0 0]);
%     subplot(4,2,5:6);
%     plot(angle(1:i)-angle(1)); drawnow limitrate; ylabel('Angle [°]');
%     
%     % Curvature
%     subplot(4,2,2);
%     draw_ellipse(Out2{i}.E1,[0 1 0]); drawnow limitrate; draw_ellipse(Out2{i}.E2,[0 1 0]); drawnow limitrate;
%     subplot(4,2,7:8);
%     plot(curv(1:i)-curv(1)); drawnow limitrate; ylabel('Curvature');
end




