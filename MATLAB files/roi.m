
  pos = get(0,'MonitorPositions');
  sz = size(pos);
vessel=imread('i1.jpg');
  t = 0:pi/20:2*pi;
  xc=230; % point around which I want to extract/crop image
  yc=79;
  r=220;   %Radium of circular region of interest
  xcc = r*cos(t)+xc;
   ycc =  r*sin(t)+yc;
   roimaskcc = poly2mask(double(xcc),double(ycc), size(vessel,1),size(vessel,2));
   pr_gccc = find(roimaskcc);
   roimean_cc= mean(vessel(pr_gccc));
% get the figure and axes handles
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
 %{ 
if (sz(1) > 1)
hfig = figure('Position',pos(2,:));
else
hfig = figure('Position',pos);
end
%}
  % figure('Position',pos(2,:));
  imshow(roimaskcc);
  vesseltry=vessel;
  vesseltry(~roimaskcc)=0;
  
