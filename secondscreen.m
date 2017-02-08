pos = get(0,'MonitorPositions');
sz = size(pos);
if (sz(1) > 1)
hfig = figure('Position',pos(2,:));
else
hfig = figure('Position',pos);
end

