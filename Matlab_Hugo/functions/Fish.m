function [ frame, timestamp, binfish, theta ] = Fish( camera )
%Fish [ frame, timestamp, binfish, theta ] = Fish( camera )
% INPUTS
%   camera :      handle on the camera
% OUTPUTS
%   frame :       camera frame
%   timestamp :   camera timestamp
%   binfish :     binary image of the fish
%   theta :       angle of the binarized fish

    [frame, timestamp]=camera.getFrame();
    binfish = morphomaths(frame);
    try
        t = regionprops(uint8(binfish),'Orientation');
        theta = t.Orientation;
    catch
        theta = NaN;
    end

end