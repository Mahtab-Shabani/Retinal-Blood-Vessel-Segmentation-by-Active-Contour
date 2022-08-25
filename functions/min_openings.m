function imB=min_openings(im,LEN,DEG_NUM)
% $$I_2=min\left\{\gamma_{B_i} (I_o) \right\}$$
% INPUT: 
%     IM (complemented green channel of a color retina image)
%     LEN (defualt: 11)
%     DEG_NUM (defualt:12)
% OUTPUT: 
%     imC2 % eq. (3.2),cv0
%

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
imB=imo{1};
for i=2:length(imo)
    imB=min(imB,imo{i});% eq. (3.1)
end
