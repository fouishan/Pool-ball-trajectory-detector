a=imread('h1.jpg');
%a=imgaussfilt(a,2);
figure,imshow(a),hold on;
e=imread('hb.jpg');
%e=imgaussfilt(e,2);
%a=rgb2gray(a);
%e=rgb2gray(e);
r = abs(a(:, :, 1)-e(:, :, 1));
g = abs(a(:, :, 2)-e(:, :, 2));
b = abs(a(:, :, 3)-e(:, :, 3));
i=rgb2gray(a);
disp(a(199,205, 2));
disp(e(199,205, 2));
disp(g(199,205));
for R=1:360
    for C=1:640
        if((r(R,C)<=20)&&(g(R,C)<=20)&&(b(R,C)<=20))
            i(R,C)=0;
        else
            i(R,C)=255;
        end
    end
end
figure,imtool(a);
figure,imtool(e);
figure,imtool(i);