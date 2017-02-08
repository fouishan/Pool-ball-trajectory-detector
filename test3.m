vid=videoinput('winvideo',2,'RGB24_1600x896');
% Set video input object properties for this application.
vid.TriggerRepeat = 100;
vid.FrameGrabInterval = 5;

% Set value of a video source object property.
vid_src = getselectedsource(vid);
vid_src.Tag = 'motion detection setup';

% Create a figure window.
figure; 
start(vid);
while(vid.FramesAvailable >= 2)
    data = getdata(vid,2); 
    diff_im = imabsdiff(data(:,:,:,1),data(:,:,:,2));
    imshow(diff_im);
    drawnow     % update figure window
end

stop(vid)