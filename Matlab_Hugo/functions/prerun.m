function prerun(camera, duration)
%prerun runs a loop to see the fish during 'duration' seconds

time = duration; % time in seconds

disp('make sure that the fish is well detected')
figure;
frame = getsnapshot(camera.handle);
tail = NaN(1,30*60);
ex = NaN([size(frame) 30*60]);
i = 1;

stop(camera.handle)
start(camera.handle)

tic

while toc < time  % time in seconds
    [~, ~, ex(:,:,i), tail(i)] = Fish(camera);
    
    if ~mod(i,30) || abs(tail(end-1)-tail(end)) > 0.04
        subplot(3,1,1)
            plot(tail)
            title('Tail angle')
        subplot(3,1,2)
            plot(diff(tail))
            title('diff of tail angle')
        subplot(3,1,3)
            imshow(ex(:,:,i));
    end
    i = i+1;
end

stop(camera.handle)

disp('framerate')
disp(i/time)
disp('if the framerate is too low, check if your camera framerate does not limit it')
end