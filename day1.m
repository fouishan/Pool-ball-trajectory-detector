a=imread('nb9.jpg');
%a=imgaussfilt(a,2);
b=rgb2gray(a);
c=edge(b,'canny',[0.05 0.14],3);
figure,imshow(c),hold on;
[H,T,R]=hough(c);
figure,imshow(H, [], 'XData',T,'YData',R,'InitialMagnification','fit');
xlabel('\theta'),ylabel('\rho');
axis on,axis normal, hold on;
P=houghpeaks(H,20,'Threshold',150);
x=T(P(:,2));
y=R(P(:,1));
plot(x,y,'s','color','white');
lines=houghlines(c,T,R,P,'FillGap',700,'MinLength',500);
figure,imshow(a),hold on;
%{
for k= 1:length(lines)
xy=[lines(k).point1;lines(k).point2]; 
if((lines(k).theta)==-90||(lines(k).theta)==-91||(lines(k).theta)==-89)
plot(xy(:,1),xy(:,2),'LineWidth',1,'Color','green');
 %Plot beginnings and ends of lines
plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
elseif((lines(k).theta)==0||(lines(k).theta)==1||(lines(k).theta)==-1)
plot(xy(:,1),xy(:,2),'LineWidth',1,'Color','red'); 
else
plot(xy(:,1),xy(:,2),'LineWidth',1,'Color','blue');
end;
end;
%}
a=0;
b=1600;
c=-896;
d=0;
for k= 1:length(lines)
if((lines(k).rho)>-448 && ((lines(k).theta)==-90||(lines(k).theta)==-89||(lines(k).theta)==-91))
   %disp(1);
    if((lines(k).rho)<a)
        %disp(11);
        a=lines(k).rho;
        xy1=[lines(k).point1;lines(k).point2];
    end;
elseif((lines(k).rho)>800 && ((lines(k).theta)==0||(lines(k).theta)==1||(lines(k).theta)==-1))
    %disp(2);
    if((lines(k).rho)<b)
        %disp(22);
        b=lines(k).rho;
        xy2=[lines(k).point1;lines(k).point2];
    end;
elseif((lines(k).rho)<-448 && ((lines(k).theta)==-90||(lines(k).theta)==-91||(lines(k).theta)==-89))
    %disp(3);
    if((lines(k).rho)>c)
        %disp(33);
        c=lines(k).rho;
        xy3=[lines(k).point1;lines(k).point2];
    end;
elseif((lines(k).rho)<800 && ((lines(k).theta)==0||(lines(k).theta)==1||(lines(k).theta)==-1))
    %disp(4);
    if((lines(k).rho)>d)
        %disp(44);
        d=lines(k).rho;
        xy4=[lines(k).point1;lines(k).point2];
    end;
end;
end;
plot(xy1(:,1),xy1(:,2),'LineWidth',1,'Color','green');
plot(xy2(:,1),xy2(:,2),'LineWidth',1,'Color','green');
plot(xy3(:,1),xy3(:,2),'LineWidth',1,'Color','green');
plot(xy4(:,1),xy4(:,2),'LineWidth',1,'Color','green');

%------------------14 jan---------------------
%disp(xy1(1,1));disp(xy1(1,2));
%disp(xy1(2,1));disp(xy1(2,2));

%disp(xy2(1,1));disp(xy2(1,2));
%disp(xy2(2,1));disp(xy2(2,2));



l1=[xy2(1,1) xy2(1,2)  xy2(2,1) xy2(2,2)];l2=[xy1(1,1) xy1(1,2)  xy1(2,1) xy1(2,2)];
X1=[xy2(1,1) xy2(2,1)];
Y1=[xy2(1,2) xy2(2,2)];
X2=[xy1(1,1) xy1(2,1)];
Y2=[xy1(1,2) xy1(2,2)];
[x0,y0,iout,jout]=intersections(X1,Y1,X2,Y2,0);
X1=[xy3(1,1) xy3(2,1)];
Y1=[xy3(1,2) xy3(2,2)];
X2=[xy2(1,1) xy2(2,1)];
Y2=[xy2(1,2) xy2(2,2)];
[x0,y0,iout,jout]=intersections(X1,Y1,X2,Y2,0);
X1=[xy4(1,1) xy4(2,1)];
Y1=[xy4(1,2) xy4(2,2)];
X2=[xy3(1,1) xy3(2,1)];
Y2=[xy3(1,2) xy3(2,2)];
[x0,y0,iout,jout]=intersections(X1,Y1,X2,Y2,0);
X1=[xy1(1,1) xy1(2,1)];
Y1=[xy1(1,2) xy1(2,2)];
X2=[xy4(1,1) xy4(2,1)];
Y2=[xy4(1,2) xy4(2,2)];
[x0,y0,iout,jout]=intersections(X1,Y1,X2,Y2,0);