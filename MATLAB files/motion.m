cam=webcam(2);

for idx = 1:2
   % Acquire a single image.
   rgbImage = snapshot(cam);
    fname=['motion' num2str(idx)];
    imwrite(rgbImage,fname,'jpg');
    pause(5);
   % Convert RGB to grayscale.
 %  grayImage = rgb2gray(rgbImage);

   % Find circles.
  % [centers, radii] = imfindcircles(grayImage, [60 80]);

   % Display the image.
 %  imshow(rgbImage);
 %  hold on;
 %  viscircles(centers, radii);
 %  drawnow
end
a=imread('motion1');
a=imgaussfilt(a,2);
b=imread('motion2');
b=imgaussfilt(b,2);
y=b-a;
y=rgb2gray(y);
y(y>25)=255;
y(y<26)=0;
%disp(y);
numPixelsLessThan26 = sum(sum(y==255));
disp(numPixelsLessThan26);
disp(307200);
result=numPixelsLessThan26*100/307200;
disp(result);
figure,imshow(y);
figure,imshow(a);
figure,imshow(b);
if(result<0.003)
h = msgbox('No motion');
else
h = msgbox('Motion detected');
end;
clear('cam');