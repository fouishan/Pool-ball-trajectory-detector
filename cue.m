i=imread('k1.jpg');
e=imread('kb.jpg');
f=i-e;
figure,imshow(f),hold on;
f=rgb2gray(f);
f=im2bw(f,37/255);%Tweak according to light conditions
figure,imshow(f),hold on;

labeledImage = bwlabel(f);
measurements = regionprops(labeledImage,'Centroid','Area','MajorAxisLength','MinorAxisLength','PixelIdxList');
% Find the largest blob.
allAreas = [measurements.Area];
a=0;
for k=1:length(allAreas)
    x=measurements(k).MajorAxisLength;
    y=measurements(k).MinorAxisLength;
    centers = measurements(k).Centroid;
diameters = mean([measurements(k).MajorAxisLength measurements(k).MinorAxisLength],2);
radii = diameters/2;
%display(radii);
%Adjust the radii with trial and errors
if(radii>12)
    if ((x/y)<1.2)
        if(measurements(k).Area>a)
            maxball=measurements(k);
            a=measurements(k).Area;
            display(a);
        end
        display(measurements(k).Area);
        %{
        BlobIndex = find(allAreas == measurements(k).Area);
        keeperBlobsImage = ismember(labeledImage,  BlobIndex);
        % Get its boundary and overlay it over the original image.
        boundaries = bwboundaries(keeperBlobsImage);
        blobBoundary = boundaries{1};
        plot(blobBoundary(:,2), blobBoundary(:,1), 'r', 'LineWidth', 5);
        %}
    end
end
end
%-----------------------------------white ball-----------------------------
%{
max_value= zeros(numel(measurements),1);
% Loop over each labeled object, grabbing the gray scale pixel values using
% PixelIdxList and computing their maximum.
for k = 1:numel(measurements)
    max_value(k) = max(a(measurements(k).PixelIdxList));
end

% Show all the maximum values as a bar chart.
figure,bar(max_value), hold on;
bright_objects = find(max_value > 254);
figure,imshow(ismember(labeledImage, bright_objects)),hold on;
%--------------------------------------------------------------------------
%display(allAreas);
%}
biggestBlobIndex = find(allAreas == maxball.Area);

% Extract only the largest blob.
% Note how we use ismember() to do this.
keeperBlobsImage = ismember(labeledImage, biggestBlobIndex);

% Get its boundary and overlay it over the original image.
boundaries = bwboundaries(keeperBlobsImage);
blobBoundary = boundaries{1};
plot(blobBoundary(:,2), blobBoundary(:,1), 'r', 'LineWidth', 2);
hold off;
  t = 0:pi/20:2*pi;
  xc=measurements(biggestBlobIndex).Centroid(1); % point around which I want to extract/crop image
  yc=measurements(biggestBlobIndex).Centroid(2);
  diameters = mean([measurements(biggestBlobIndex).MajorAxisLength measurements(biggestBlobIndex).MinorAxisLength],2);
  radius=diameters/2;
  r=3*radius;   %Radium of circular region of interest
  disp(xc);
  disp(yc);
  disp(radius);
  xcc = r*cos(t)+xc;
   ycc =  r*sin(t)+yc;
   roimaskcc = poly2mask(double(xcc),double(ycc), size(i,1),size(i,2));
i=imread('k1_2.jpg');
i=rgb2gray(i);
e=imread('k1.jpg');
e=rgb2gray(e);
f=roimaskcc;
f=im2bw(f,0.2);
f=imcomplement(f);
%{
for ii=1:size(f,1)
    for jj=1:size(f,2)
          if f(ii,jj)==0
              i(ii,jj,1)=0;
              e(ii,jj,1)=0;
              i(ii,jj,2)=0;
              e(ii,jj,2)=0;
              i(ii,jj,3)=0;
              e(ii,jj,3)=0;
          end
    end
end;
figure,imshow(i),hold on;
figure,imshow(e),hold on;
%}
r1=regionfill(i,f);
r2=regionfill(e,f);
%r=roipoly(i,[563 661 661 563],[522 522 620 620]);
r=r1-r2;
r=im2bw(r,35/255);
num= sum(sum(r==1));
disp(num);
figure,imshow(r),hold on;
[H,T,R] = hough(r);
P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
lines = houghlines(r,T,R,P,'FillGap',5,'MinLength',7);
max_len = 0;
xy1=[0,0];
xy2=[0,0];
for k = 1:length(lines)
    xy1=[lines(k).point1(1)+xy1(1),lines(k).point1(2)+xy1(2)];
    xy2=[lines(k).point2(1)+xy2(1),lines(k).point2(2)+xy2(2)];
   %xy = [lines(k).point1; lines(k).point2];
   %plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   %plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   %plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   
   len = norm(lines(k).point1 - lines(k).point2);
   disp(len);
   %{
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
   %}
end
disp(xy1(1));
disp(xy1(2));
disp(xy2(1));
disp(xy2(2));
xy1=[xy1(1)/length(lines),xy1(2)/length(lines)];
xy2=[xy2(1)/length(lines),xy2(2)/length(lines)];
xy_long = [xy1; xy2];
plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','green');
disp(xy_long(:,1));
disp(xy_long(:,2));