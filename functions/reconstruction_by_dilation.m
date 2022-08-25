function imC2=reconstruction_by_dilation(im,LEN,DEG_NUM)
%
% $$I_1=R_{I_o}\left (max\left\{\gamma_{B_i} (I_o)\right\}\right), & i=1,...,12$$ 
% INPUT: 
%     IM (complemented green channel of a color retina image)
%     LEN (defualt: 11)
%     DEG_NUM (defualt:12)
% OUTPUT: 
%     imC2 

if nargin<3 || isempty(LEN)
    LEN=11;
end
if nargin<3 || isempty(DEG_NUM)
    DEG_NUM=12;
end

imo=cell(DEG_NUM,1);
for i=1:DEG_NUM
    DEG=(i-1)*((360/DEG_NUM)/2);
    se=strel('line',LEN,DEG);
    imo{i}=imopen(im,se);
end
% imB=zeros([m,n]);
imC=imo{1};
for i=2:length(imo)
    imC=max(imC,imo{i});% eq. (3.1)
end
% imC2=imC;
imC2=imreconstruct(imC,im); % eq. (3.2)
imC2=mat2gray(imC2);
