acc = 0; fpr = 0; tpr = 0; sn=0; sp=0;  pr=0;   npv=0;    auc=0;  f1=0;
close all;
%% 
[filename , pathname] = uigetfile({('*.jpg;*.png;*.gif;*.tif;*.bmp')},'Select a pic');
I=imread([pathname filename]);
tic
I = I(:,:,2);
% imsize = 0.5;
imsize = 1;
I = imresize(I,imsize);
[row col]= size(I);
vesse
I = adapthisteq(I); % CLHAE
I = double(I);
I = medfilt2(I, [3, 3]);
% I = medfilt2(I, [5, 5]); % JUST for CHASEDB Dataset
Img=I;

%% DRIVE
name = filename(1:3);
fnd = findstr(pathname,'test');
if isempty(fnd)
    imgman=imread(strcat('DRIVE\trn\1st_manual\',name,'manual1.gif'));
    imgmsk=imread(strcat('DRIVE\trn\mask\',name,'training_mask.gif'));
else
%     imgman=imread(strcat('DRIVE\test\manual\',name,'manual1.gif'));
    imgman=imread(strcat('DRIVE\test\1st_manual\',name,'manual1.gif'));
    imgmsk=imread(strcat('DRIVE\test\mask\',name,'test_mask.gif'));
end
manu=imgman;    mask=imgmsk;    Omask=mask;
maskbw=im2bw(imgmsk);

%% HRI DataBase
% name = filename(1:3);
% imgman=imread(strcat('HRI\manual\diabet\',name,'dr.tif'));
% imgmsk=imread(strcat('HRI\mask\diabet\',name,'dr_mask.tif'));

%% CHASEDB1
% name = filename(1:8);
% fnd = findstr(pathname,'images');
% % if isempty(fnd)
%     imgman=imread(strcat('chasedb\2_manual\',name,'.png'));
%     imgmsk=imread(strcat('chasedb\mask\',name,'.jpg'));
% % end
% imgman = imresize(imgman,imsize);
% imgmsk = imresize(imgmsk(:,:,2),imsize);
% manu=imgman;    mask=imgmsk;    Omask=mask;
% maskbw=im2bw(imgmsk);
% 
%% HRI
% name = filename(1:3);
% imgman=imread(strcat('HRI\manual\diabet\',name,'dr.tif'));
% imgmsk=imread(strcat('HRI\mask\diabet\',name,'dr_mask.tif'));
% 
% imgman = imresize(imgman,imsize);
% imgmsk = imresize(imgmsk(:,:,2),imsize);
% manu=imgman;    mask=imgmsk;    Omask=mask;
% maskbw=im2bw(imgmsk);

%% Matched Filtering
[imgMF mfbw] = MatchFilter_function(I,mask);
imgMF        = normalize01(imgMF);
% imgmf        = otsu(imgMF,7);
% mf_bw        = normalize01(imgmf);
% mf_bw        = imgmf;
mf_bw        = ~mfbw;
% mf_bw = mf_bw.*double(imgmsk);
ot = im2uint8(mat2gray(mf_bw));
mf_bw = bwareaopen(ot,20);

%% Hessian Frangi
Ivessel=FrangiFilter2D(double(I));
Ivessel=Ivessel.*double(imgmsk);
Ivessel=normalize01(Ivessel);
Iv=otsu(Ivessel,2);
for i=1:size(Img,1)
    for j=1:size(Img,2)
        if (Iv(i,j) == 1)
            Iv(i,j)= 0;
        end
    end
end
for i=1:size(Img,1)
    for j=1:size(Img,2)
        if (Iv(i,j) == 2)
            Iv(i,j)= 1;
        end
    end
end

%% Vessel Enhancement
Img = acode_main_retin_vessel_seg(Img, imgmsk, imgman);
Img = im2uint8(mat2gray(Img));
Img = double(Img(:, :, 1));
Img = medfilt2(Img, [3, 3]); % apply median filter to denoise

%% setting the initial function 'u':
Img=Img+double(I2);
Img = im2uint8(mat2gray(Img));
Img = double(Img(:, :, 1));
u = initialcurve(Img,'gradient');
ui= u;

%% setting the parameters in ACWE algorithm:
mu=1;
lambda1=.7; lambda2=.6; lambda3=5; lambda4=lambda3; lambda5=4;
timestep = .001; v=1; epsilon=.6;
iterNum=60;
% start evolution
for n=1:iterNum
    u=acwe_dwt(u, Img,  timestep,...
        mu, v, lambda1, lambda2, 1, epsilon, 1, lambda3, lambda4, lambda5, Iv, mf_bw, row, col);
        if mod(n,10)==0
            pause(0.1);
            imshow(Img, []);hold on;axis off,axis equal
            [c,h] = contour(u,[0 0],'r');
            iterNum=[num2str(n), ' iterations'];
            title(iterNum);
            hold off;
        end
end
imshow(Img, []);hold on;axis off,axis equal
[c,h] = contour(u,[0 0],'r');
totalIterNum=[num2str(n), ' iterations'];
title(['Final contour, ', totalIterNum]);

%%
u=real(u);
edit = u;
figure; imshow(edit,[]),title('Final Active Contour function')
figure;

mesh(u);
title('Final Active Contour function');

%% Threshold
edit=im2bw(edit);

%% Post-Proccessing
ot = im2uint8(mat2gray(edit));
ot = bwareaopen(ot,20);
edit=ot;
edit = bwmorph(edit,'bridge');

figure; imshow(uint8(edit),[]),title('final')
subplot(1,2,1), imshow(edit,[]);title('Final Active Contour function');
subplot(1,2,2), imshow(manu);title('Manual extraction');

%% Performance evalution

[acc,tpr,fpr,sn,sp,pr,npv,auc,f1] = computAUCAll(edit, manu,  mask, Omask,acc,tpr,fpr,sn,sp,pr,npv,auc,f1);


toc