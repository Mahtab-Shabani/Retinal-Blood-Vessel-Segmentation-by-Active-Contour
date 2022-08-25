ginv = imcomplement (I);            % Complement the Green Channel
adahist = adapthisteq(ginv);        % Adaptive Histogram Equalization
se = strel('disk',3);
imbot = imbothat(adahist,se);
imtop = imtophat(adahist,se);
imad  = imadd(adahist,imtop);
imsub = imsubtract(imad , imbot);

se = strel('ball',10,10);             % Structuring Element
gopen = imopen(adahist,se);         % Morphological Open
godisk = adahist - gopen;           % Remove Optic Disk

medfilt = medfilt2(godisk);                 %2D Median Filter
background = imopen(medfilt,strel('disk',15));% imopen function
I2 = medfilt - background;                  % Remove Background
I3 = imadjust(I2);                          % Image Adjustment

level = graythresh(I3);                     % Gray Threshold
bw = im2bw(I3,level);                       % Binarization
bw = bwareaopen(bw, 30);                    % Morphological Open
% figure,imshow(bw);

wname = 'sym4';
[CA,CH,CV,CD] = dwt2(bw,wname,'mode','per');
% figure,imshow(CA),title('Approximate');


b = bwboundaries(bw);
% % axes(handles.axes5);
% % I = imresize(I,[500 752]);
% figure,imshow(I)
% hold on
% 
% for k = 1:numel(b)
%     plot(b{k}(:,2), b{k}(:,1), 'b', 'Linewidth', 1)
% end
 
% ims=I2-imbot;
% medfilt = medfilt2(ims);                 %2D Median Filter
% background = imopen(medfilt,strel('disk',15));% imopen function
% I2 = medfilt - background;                  % Remove Background
