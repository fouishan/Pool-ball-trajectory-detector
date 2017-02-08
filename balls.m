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
   pr_gccc = find(roimaskcc);
   roimean_cc= mean(i(pr_gccc));
  figure, imshow(roimaskcc);
  vesseltry=i;
  vesseltry(~roimaskcc)=0;
  figure,imshow(vesseltry);
%--- end of new code
%Tell user the results.
message = sprintf('Major axis length = %.1f\n',measurements(biggestBlobIndex).MajorAxisLength);
message = sprintf('%sMinor axis length = %.1f\n', ...
    message, measurements(biggestBlobIndex).MinorAxisLength);
message = sprintf('%sArea = %.1f\n', ...
message, measurements(biggestBlobIndex).Area);
uiwait(msgbox(message));
%{
[B,L,N,A] = bwboundaries(f);
for k=1:length(B),
if(~sum(A(k,:)))
boundary = B{k};
plot(boundary(:,2), boundary(:,1), 'r','LineWidth',2);
display(boundary(:,2));
for l=find(A(:,k))'
boundary = B{l};
plot(boundary(:,2), boundary(:,1), 'g','LineWidth',2);
end
end
end
%}
%i=imcontour(f,3);
%figure,imshow(i);