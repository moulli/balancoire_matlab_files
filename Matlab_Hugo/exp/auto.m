function [output] = auto(param, handle)
%auto does a vestibular and visual feedback for each tail bout and calls
% this program only binds to the vestibularVisual and retrOMR functions

handles = handle;   % copy of handle in order to add video writer
params = param;     % copy for vestibularVisual
OMRparams = param;  % copy param to replace OMR params
h = tic;
n=0;

while toc(h) < params.duration * 60
    % vestibularVisual
    path = [params.path '--' sprintf('%.2d', n) '-1-vestibularVisual']; % new path for each repetition
    vw = VideoWriter([path '.avi'], 'Grayscale AVI');   %#ok<TNMLP> % video writer for each repetition
    open(vw);
    handles.vwriter = vw;
    start = toc(h);
        obj = vestibularVisual(params, handles);               % calls vestibularVisual
    close(vw);
    obj.StartTime = handle.StartTime + start;             
    obj.params = params;
    save(path, 'obj');

    % once it is finished (interrupted) retrOMR
    OMRparams.rspeed = param.OMRrspeed;
    OMRparams.rcorrect = param.OMRrcorrect;
    OMRparams.correctionTime = param.OMRcorrectionTime;
    OMRparams.duration = param.retrOMRduration;
    path = [OMRparams.path '--' sprintf('%.2d', n) '-2-retrOMR'];  % new path for each repetition
    vw = VideoWriter([path '.avi'], 'Grayscale AVI');   %#ok<TNMLP> % video writer for each repetition
    open(vw);
    handles.vwriter = vw;
    start = toc(h);
        obj = retrOMR(OMRparams, handles);                        % calls retrOMR
    close(vw);
    obj.StartTime = handle.StartTime + start;             
    obj.params = OMRparams;
    save(path, 'obj');

    n = n+1;
end

output = n-1;
end
