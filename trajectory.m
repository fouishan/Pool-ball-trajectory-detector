f=imread('cue2.jpg');
f=im2bw(f,0.2);
xb=[70.13 1527 1514 82.9];
yb=[72 72 817 817];
xmin=70.13;
xmax=1527;
ymin=72;
ymax=817;
xr=612.1406;
yr=570.7795;
xc1=630;
xc2=616;
yc1=469;
yc2=529;
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
d1=sqrt((xr-xc1)^2+(yr-yc1)^2);
d2=sqrt((xr-xc2)^2+(yr-yc2)^2);
if(d1>d2)
    xf=xc2;
    yf=yc2;
else
    xf=xc1;
    yf=yc1;
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
figure,imshow(f),hold on;
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
plot(xp,yp,'LineWidth',2,'Color','white');
%disp(xi);
%disp(yi);