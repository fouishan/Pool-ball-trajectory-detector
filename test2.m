vid=videoinput('winvideo',2,'RGB24_1600x1200');
vid.FrameGrabInterval = 5;
start(vid); 
im1=getsnapshot(vid);
im2=getsnapshot(vid);
stop(vid);
a=im1;
a=imgaussfilt(a,2);
b=im2;
b=imgaussfilt(b,2);
y=b-a;
y=rgb2gray(y);
y(y>25)=255;
y(y<26)=0;
%disp(y);
numPixelsLessThan26 = sum(sum(y==255));
disp(numPixelsLessThan26);
total=size(y,1)*size(y,2);
result=numPixelsLessThan26*100/total;
disp(result);
figure,imshow(y);
figure,imshow(a);
figure,imshow(b);
if(result<0.003)
h = msgbox('No motion');
else
h = msgbox('Motion detected');
end;