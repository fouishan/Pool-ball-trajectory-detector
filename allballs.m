xmin=70.13;
xmax=1527;
ymin=72;
ymax=817;
f=imread('i1.jpg');
f=imgaussfilt(f,2);
f=imsharpen(f,'Radius',20,'Amount',5);
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
[centers,radii]=imfindcircles(f,[29 34],'Sensitivity',0.965);
disp(centers);
disp(radii);
figure,imshow(f),hold on;
h=viscircles(centers,radii);
xr=612;
yr=571;
radius=32.5;
p=[xr yr];
p1=[647 606];
p2=[591 517];
L=createLine(p1,p2);
refline=orthogonalLine(L,p);
c=[p radius];
ptstan=intersectLineCircle(refline,c);
pl1=parallelLine(L,ptstan(1,:));
pl2=parallelLine(L,ptstan(2,:));
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
for j=1:size(centers)
    if(j==cue)
    else
        ctemp=[[centers(j,1) centers(j,2)] radius];
        pt1=intersectLineCircle(pl1,ctemp);
        pt2=intersectLineCircle(pl2,ctemp);
        if(~isnan(pt1(1)))
            pts1(a,:)=pt1(1,:);
            circles1(a)=j;
            a=a+1;
            pts1(a,:)=pt1(2,:);
            circles1(a)=j;
            a=a+1;
        end
        if(~isnan(pt2(1)))
            pts2(b,:)=pt2(1,:);
            circles2(b)=j;
            b=b+1;
            pts2(b,:)=pt2(2,:);
            circles2(b)=j;
            b=b+1;
        end
    end
end
if(pts1)
    [d1,ind1]=minDistance(ptstan(1,:),pts1);
    ind=ind1;
    array=1;
elseif(pts2)
    [d2,ind2]=minDistance(ptstan(2,:),pts2);
    ind=ind2;
    array=2;
else
[d1,ind1]=minDistance(ptstan(1,:),pts1);
[d2,ind2]=minDistance(ptstan(2,:),pts2);
if(d1<d2)
    ind=ind1;
    array=1;
else
    ind=ind2;
    array=2;
end
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
xp=[xr 584];
yp=[yr 604];
plot(xp,yp,'LineWidth',2,'Color','red');
%drawLine(dir);
%disp(tanpts);
%disp(ind);
%disp(array);
%disp(circles2(ind));
%disp(ptstan(array,:));