classdef Camera < handle
    %Camera is a class for communicating with _one_ camera
    %   camera still has to be manually started and stopped
    
    properties
        handle      % videoinput
    end
    
    methods
        function obj = Camera()
            %Camera constructor : inits the communications with the camera 1
            %   Detailed explanation goes here
            obj.handle = videoinput('pointgrey', 1);
            obj.defaultSettings();
        end
        
        function defaultSettings(obj)
            %defaultSettings resets the camera settings to default values
            obj.handle.FramesPerTrigger = 1;
            obj.handle.TriggerRepeat = Inf;
            triggerconfig(obj.handle, 'manual');
            
            src = getselectedsource(obj.handle);
            src.GainMode = 'manual';
%             src.Gain = 0;
            src.ShutterMode = 'manual';
%             src.Shutter = 0.2;
            src.ExposureMode = 'manual';
%             src.Exposure = 0;
            src.FrameRateMode = 'manual';
%             src.FrameRate = 150;
        end
            
        function setROI(obj)
            disp('set the ROI by drawing a rectangle')
            resolution = obj.handle.VideoResolution;                       % get resolution
            obj.handle.ROIPosition = [0 0 resolution(1) resolution(2)];    % reset resolution
            frame = getsnapshot(obj.handle);
            figure; imshow(frame);
            disp('select fish ROI');
            h = imrect;                                                    % get the new ROI
            ROIfish = round(getPosition(h));
            obj.handle.ROIPosition = ROIfish;                              % update ROI 
            frame = getsnapshot(obj.handle);
            imshow(frame);
            disp(size(frame));           
        end
        
        function preview(obj)
            preview(obj.handle)
        end
        
        function [frame, timestamp] = getFrame(obj)
            %getFrame triggers the vid and returns the frame and the timestamp
            %handle must be started before
            trigger(obj.handle)
            [frame, timestamp]=getdata(obj.handle);
        end
    end
end
