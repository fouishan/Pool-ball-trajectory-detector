i=imread('k1.jpg');
e=imread('kb.jpg');
f=i-e;
%figure,imshow(f),hold on;
f=rgb2gray(f);
f=im2bw(f,37/255);%Tweak according to light conditions
%figure,imshow(f),hold on;

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
%plot(blobBoundary(:,2), blobBoundary(:,1), 'r', 'LineWidth', 2);
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
  %figure, imshow(roimaskcc);
  vesseltry=i;
  vesseltry(~roimaskcc)=0;
  %figure,imshow(vesseltry);
i=imread('k1_3.jpg');
i=rgb2gray(i);
e=imread('k1.jpg');

e=rgb2gray(e);
f=roimaskcc;
f=im2bw(f,0.2);
mask=f;
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
r=im2bw(r,0.1);
%figure,imshow(r),hold on;
[H,T,R] = hough(r);
P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
lines = houghlines(r,T,R,P,'FillGap',5,'MinLength',7);
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   %plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   %plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   %plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end
xr=xc;
yr=yc;
radius=32.5;
xb=[1519 1519 86 86];
yb=[82 794 768 82];
xc1=xy_long(1,1);
xc2=xy_long(2,1);
yc1=xy_long(1,2);
yc2=xy_long(2,2);
xmin=70.13;
xmax=1527;
ymin=72;
ymax=817;
f=imread('k1.jpg');
f=imgaussfilt(f,2);
f=imsharpen(f,'Radius',20,'Amount',5);
d1=sqrt((xr-xc1)^2+(yr-yc1)^2);
d2=sqrt((xr-xc2)^2+(yr-yc2)^2);
if(d1>d2)
    xf=xc2;
    yf=yc2;
else
    xf=xc1;
    yf=yc1;
end
%{
f=imgaussfilt(f,2);
f=rgb2gray(f);
f=edge(f,'canny',[0.1 0.2],2);
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
%}
[centers,radii]=imfindcircles(f,[29 34],'Sensitivity',0.96);
disp(centers);
disp(radii);
hFig = gcf;
 hAx  = gca;
 % set the figure to full screen
 set(hFig,'units','normalized','outerposition',[0 0 1 1]);
 % set the axes to full screen
 set(hAx,'Unit','normalized','Position',[0 0 1 1]);
 % hide the toolbar
 set(hFig,'menubar','none')
 % to hide the title
 set(hFig,'NumberTitle','off');
imshow(mask),hold on;
%h=viscircles(centers,radii);
p=[xr yr];
p1=[xf yf];
p2=[xr yr];
L=createLine(p1,p2);
refline=orthogonalLine(L,p);
c=[p radius];
ptstan=intersectLineCircle(refline,c);
pl1=parallelLine(L,ptstan(1,:));
pl2=parallelLine(L,ptstan(2,:));
beta=angle2Points(p1,p2);
tanray1=createRay(ptstan(1,:),beta);
tanray2=createRay(ptstan(2,:),beta);
%c1=[[709 476] 32.5];
%pts1=intersectLineCircle(pl1,c1);
%pts2=intersectLineCircle(pl2,c1);
d=1600;
for j=1:size(centers)
    d1=sqrt((xr-centers(j,1))^2+(yr-centers(j,2))^2);
    if(d1<d)
        d=d1;
        cue=j;
    end
end
%disp(cue);
a=1;
b=1;
clear pts1;
clear pts2;
for j=1:size(centers)
    if(j==cue)
    else
        ctemp=[[centers(j,1) centers(j,2)] radius];
        pt1=intersectLineCircle(pl1,ctemp);
        pt2=intersectLineCircle(pl2,ctemp);
        if(~isnan(pt1(1)))
            dref1=distancePoints(centers(j),p1);
            dref2=distancePoints(centers(j),p2);
            if(dref1>dref2)
            pts1(a,:)=pt1(1,:);
            circles1(a)=j;
            a=a+1;
            pts1(a,:)=pt1(2,:);
            circles1(a)=j;
            a=a+1;
            end
        end
        if(~isnan(pt2(1)))
            dref1=distancePoints(centers(j),p1);
            dref2=distancePoints(centers(j),p2);
            if(dref1>dref2)
            pts2(b,:)=pt2(1,:);
            circles2(b)=j;
            b=b+1;
            pts2(b,:)=pt2(2,:);
            circles2(b)=j;
            b=b+1;
            end
        end
    end
end
if(exist('pts1')||exist('pts2'))
if(exist('pts1')&&exist('pts2'))
[d1,ind1]=minDistance(ptstan(1,:),pts1);
[d2,ind2]=minDistance(ptstan(2,:),pts2);
if(d1<d2)
    ind=ind1;
    array=1;
else
    ind=ind2;
    array=2;
end
elseif(exist('pts1'))
    disp(1);
    [d1,ind1]=minDistance(ptstan(1,:),pts1);
    ind=ind1;
    array=1;
else
    disp(2);
    [d2,ind2]=minDistance(ptstan(2,:),pts2);
    ind=ind2;
    array=2;
end
if(array==1)
    tanp1=ptstan(array,:);
    tanp2=pts1(ind,:);
    tanline=createLine(tanp1,tanp2);
    tanc=[[centers(circles1(ind),1) centers(circles1(ind),2)] radius];
    tanpts=intersectLineCircle(tanline,tanc);
    mid=midPoint(tanpts(1,:),tanpts(2,:));
    cline=createLine([centers(circles1(ind),1) centers(circles1(ind),2)],mid);
    cpts=intersectLineCircle(cline,tanc);
    centercircle=[centers(circles1(ind),1) centers(circles1(ind),2)];
else
    tanp1=ptstan(array,:);
    tanp2=pts2(ind,:);
    tanline=createLine(tanp1,tanp2);
    tanc=[[centers(circles2(ind),1) centers(circles2(ind),2)] radius];
    tanpts=intersectLineCircle(tanline,tanc);
    mid=midPoint(tanpts(1,:),tanpts(2,:));
    cline=createLine([centers(circles2(ind),1) centers(circles2(ind),2)],mid);
    cpts=intersectLineCircle(cline,tanc);
    centercircle=[centers(circles2(ind),1) centers(circles2(ind),2)];
end
[dist1,pos1]=distancePointLine(cpts(1,:),L);
[dist2,pos2]=distancePointLine(cpts(2,:),L);
if(dist1<dist2)
    mid1=midPoint(cpts(1,:),tanp2);
else
    mid1=midPoint(cpts(2,:),tanp2);
end
dir=createLine(mid1,centercircle);
ray = createRay(mid1, centercircle);
box=[xmin xmax ymin ymax];
edge=clipRay(ray,box);
%disp(edge);
xp=[edge(1) edge(3)];
yp=[edge(2) edge(4)];
plot(xp,yp,'LineWidth',2,'Color','white');
circleref=[centercircle (2*radius)];
refs=intersectLineCircle(dir,circleref);
dref1=distancePoints(refs(1,:),p);
dref2=distancePoints(refs(2,:),p);
if(dref1<dref2)
    refp=refs(1,:);
else
    refp=refs(2,:);
end
alpha1=angle2Points(mid1,centercircle);
alpha1=rad2deg(alpha1);
alpha2=angle2Points(p1,p2);
alpha2=rad2deg(alpha2);
alpha=alpha2-alpha1;
if(alpha>90)
    alpha=alpha-360;
elseif(alpha<-90)
    alpha=alpha+360;
end
disp(alpha1);
disp(alpha2);
disp(alpha);
if(alpha==0)
elseif(alpha>0)
    raycue=createRay(refp,deg2rad(alpha1+90));
    edge=clipRay(raycue,box);
    xp=[edge(1) edge(3)];
    yp=[edge(2) edge(4)];
    plot(xp,yp,'LineWidth',2,'Color','white');
elseif(alpha<0)
    raycue=createRay(refp,deg2rad(alpha1-90));
    edge=clipRay(raycue,box);
    xp=[edge(1) edge(3)];
    yp=[edge(2) edge(4)];
    plot(xp,yp,'LineWidth',2,'Color','white');
end
xp=[xr refp(1)];
yp=[yr refp(2)];
plot(xp,yp,'LineWidth',2,'Color','red');
xp=[xr xf];
yp=[yr yf];
plot(xp,yp,'LineWidth',2,'Color','red');
else
    X1=[xc1 xc2];
Y1=[yc1 yc2];
xi = zeros(1, 4);
yi = zeros(1, 4);
for j=1:4
    if(j==4)
        X2=[xb(4) xb(1)];
        Y2=[yb(4) yb(1)];
    else
    X2=[xb(j) xb(j+1)];
    Y2=[yb(j) yb(j+1)];
    end
    %fit linear polynomial
    p1 = polyfit(X1,Y1,1);
    p2 = polyfit(X2,Y2,1);

    %calculate intersection
    x_intersect = fzero(@(x) polyval(p1-p2,x),3);
    y_intersect = polyval(p1,x_intersect);
    %disp(x_intersect);
    %disp(y_intersect);
    xi(j)=x_intersect;
    yi(j)=y_intersect;
end
for j=1:4
    if(xi(j)>0&&xi(j)<1601&&yi(j)>0&&yi(j)<897)
        d1=sqrt((xr-xi(j))^2+(yr-yi(j))^2);
        d2=sqrt((xf-xi(j))^2+(yf-yi(j))^2);
        if(d2>d1)
            x=xi(j);
            y=yi(j);
            l=j;
        end
    end
end
%figure,imshow(f),hold on;
xp=[xr x];
yp=[yr y];
plot(xp,yp,'LineWidth',2,'Color','white');
if(l==1||l==3)
    %if(xr<x)
        xref=x+(x-xr);
        yref=yr;
    %else
        %xref=x-(xr-x);
        %yref=yr;
    %end
else
    %if(yr<y)
        xref=xr;
        yref=y+(y-yr);
    %else
    %end
end
X1=[x xref];
Y1=[y yref];
for j=1:4
    if(j==l)
    else
    if(j==4)
        X2=[xb(4) xb(1)];
        Y2=[yb(4) yb(1)];
    else
    X2=[xb(j) xb(j+1)];
    Y2=[yb(j) yb(j+1)];
    end
    %fit linear polynomial
    p1 = polyfit(X1,Y1,1);
    p2 = polyfit(X2,Y2,1);

    %calculate intersection
    x_intersect = fzero(@(x) polyval(p1-p2,x),3);
    y_intersect = polyval(p1,x_intersect);
    %disp(x_intersect);
    %disp(y_intersect);
    xi(j)=x_intersect;
    yi(j)=y_intersect;
    end
end
for j=1:4
    disp(1);
    if(j==l)
    else
    if(xi(j)>=xmin&&xi(j)<=xmax&&yi(j)>=ymin&&yi(j)<=ymax)
        xint=xi(j);
        yint=yi(j);
    end
    end
end
xp=[x xint];
yp=[y yint];
plot(xp,yp,'LineWidth',2,'Color','red');
xp=[xr xf];
yp=[yr yf];
plot(xp,yp,'LineWidth',2,'Color','red');
end
%drawLine(dir);
%disp(tanpts);
%disp(ind);
%disp(array);
%disp(circles2(ind));
%disp(ptstan(array,:));