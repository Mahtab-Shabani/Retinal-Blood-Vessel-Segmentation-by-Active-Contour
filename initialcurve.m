function u = initialcurve(Img,type)
% setting the initial level set function 'u':
temp = Img;

h = [0  1 0;
     1 -4 1;
     0  1 0];
T = conv2(temp,h);
T(1,:) = 0;
T(end,:) = 0;
T(:,1) = 0;
T(:,end) = 0;

thre = max(max(abs(T)))*.5;
idx = find(abs(T) > thre);
[cx,cy] = ind2sub(size(T),idx);
 cx = round(mean(cx));
cy = round(mean(cy));
[x,y] = meshgrid(1:min(size(temp,1),size(temp,2)));
m = zeros(size(temp));
[p,q] = size(temp);

switch lower (type)
    case 'rectangle'
        truncated_len = 50;
        c0=2;
        m = ones(size(Img, 1), size(Img, 2))*c0;
        m([truncated_len:end-truncated_len], [truncated_len:end-truncated_len])=-c0;
    case 'gradient'
%         [ux, uy] = gradient(Img);
%         normDu = sqrt(ux.^2+uy.^2+1e-10);
        % canny = edge(normDu,'canny',0.3);
%         canny = edge(Img,'canny',0.3);
        u = edge(Img,'canny',0.3);
%         u = edge(Img,'canny',0.017.*mean(Img(:)));
%         B=[0 1 0;
%            1 1 1;
%            0 1 0];
        se = strel('disk',3);
%         u = imdilate(u,se);
        u = imclose(u,se);
        m = im2double(u);
    case 'small'
        r = 10;
        n = zeros(size(x));
        n((x-cx).^2+(y-cy).^2<r.^2) = 1;
        m(1:size(n,1),1:size(n,2)) = n;
        %m((x-cx).^2+(y-cy).^2<r.^2) = 1;
    case 'medium'
        r = min(min(cx,p-cx),min(cy,q-cy));
        r = max(2/3*r,25);
        n = zeros(size(x));
        n((x-cx).^2+(y-cy).^2<r.^2) = 1;
        m(1:size(n,1),1:size(n,2)) = n;
    case 'large'
        imageSizeX = size(Img, 1);
        imageSizeY = size(Img, 2);
        [columnsInImage rowsInImage] = meshgrid(1:imageSizeX, 1:imageSizeY);
        % Next create the circle in the image.
        centerX = round(imageSizeX/2);
        centerY = round(imageSizeY/2);
        radius = 50;
        m = (rowsInImage - centerY).^2 ...
            + (columnsInImage - centerX).^2 <= radius.^2;
        m = double(m);
%         r = 100;
%         r = min(min(cx,p-cx),min(cy,q-cy));
%         r = max(2/3*r,60);
%         n = zeros(size(x));
%         n((x-cx).^2+(y-cy).^2<r.^2) = 1;
%         m(1:size(n,1),1:size(n,2)) = n;
    case 'whole'
        r = 30;
        m = zeros(round(ceil(max(p,q)/2/(r+1))*3*(r+1)));
        siz = size(m,1);
        sx = round(siz/2);       
        i = 1:round(siz/2/(r+1));
        j = 1:round(0.9*siz/2/(r+1));
        j = j-round(median(j)); 
        m(sx+2*j*(r+1),(2*i-1)*(r+1)) = 1;
        se = strel('disk',r);
        m = imdilate(m,se);
        m = m(round(siz/2-p/2-6):round(siz/2-p/2-6)+p-1,round(siz/2-q/2-6):round(siz/2-q/2-6)+q-1); 
end
    u = m;
end