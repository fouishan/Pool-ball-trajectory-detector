cam=webcam(2);
cam.Resolution='1600x896';
cam.Timeout=10;
%preview(cam);
   rgbImage = snapshot(cam);
    imtool(rgbImage);
    %clear('cam');