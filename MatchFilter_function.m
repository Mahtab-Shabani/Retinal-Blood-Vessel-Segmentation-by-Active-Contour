function [u bw] = MatchFilter_function(Img,mask)
cnt=uint(0);
%%% Image Acquisition
% [filename , pathname] = uigetfile({('*.jpg;*.png;*.gif;*.tif;*.bmp')},'Select a pic');
% I=imread([pathname filename]);

[s1 s2 s3]=size(Img);
% Degree of freedom if needed
free=2;
% Internal MAtched filter temps
M=0;
count=0;
% Parameters for BETA matched filter
alpha = 1;
BETHA = 1;
% Parameters for Gumbel matched filter
mu = 1;
Beta = 0.5;
% Parameters for matched filter (coushy)
Sigma=1;  %% NOTE: changed from 2 to 1.1
Length=8;   %% NOTE: changed from 9 to 7
Size=25;    %% NOTE: changed from 17 to 25
Bound=9;     %% Default: 3*Sigma
% Angle resolution for 2D matched filters
% NF=12;
NF=36;
middle=round(Size/2);
% Creating
F=zeros(Size,Size,NF);
% GaussKernel = [7 11 20];
% GaussFilter = fspecial('Gaussian', GaussKernel(k), 12);
GaussFilter = fspecial('Gaussian', 13, 1);

%% Matched filter computing
for A=1:NF
    Ang=(A)*(pi/NF);   
    for x=-fix(Size/2):fix(Size/2)
        for y=-fix(Size/2):fix(Size/2)
            %computing new rows
            u=((x)*cos(Ang)+(y)*sin(Ang));
            v=((y)*cos(Ang)-(x)*sin(Ang));
            F(x+middle,y+middle,A)=0;
            if (u>=-Bound && u<=Bound)&&(v>-Length/2 && v<Length/2)
                count=count+1;
                % Kernel of Matched filter
% %                 F(x+middle,y+middle,A)= -cauchypdf(u,0,Sigma);% -exp(-(u^2)/(2*Sigma^2));
% %                 F(x+middle,y+middle,A)= -wblpdf(u,1,5);% (k/landa)((x/landa).^k-1)exp(-(x/landa).^k);
% %                 F(x+middle,y+middle,A)= -raylpdf(u,0.8);% Rayleigh 0.9056 (k/landa)((x/landa).^k-1)exp(-(x/landa).^k);
% %                 F(x+middle,y+middle,A)= -GaussFilter(u,1,Sigma); % Gamma
                F(x+middle,y+middle,A)= -evpdf(u,mu,Beta); %Gumbel
% %                 F(x+middle,y+middle,A)= -gampdf(u,1,Sigma); % Gamma
% %                 F(x+middle,y+middle,A)= -normal_gaussian_pdf(u,1,Sigma); % Gamma
%                 F(x+middle,y+middle,A)= -normpdf(u,1,Sigma); % NORMAL
% %                 F(x+middle,y+middle,A)= -sech(u);
% %                 F(x+middle,y+middle,A)= -gampdf(u,1,Sigma); % Gamma
% %                 0.9250
% %                 F(x+middle,y+middle,A)= -betapdf(u,1,1); % Beta
% %                 F(x+middle,y+middle,A)= -poisspdf(u,Sigma); % Poisson 
                M=M+F(x+middle,y+middle,A);
            end
        end
    end
    m=M/count;
    
    for x=-fix(Size/2):fix(Size/2)
        for y=-fix(Size/2):fix(Size/2)
            %computing new rows
            u=((x)*cos(Ang)+(y)*sin(Ang));
            v=((y)*cos(Ang)-(x)*sin(Ang));
            if (u>=-Bound && u<=Bound)&&(v>-Length/2 && v<Length/2)
                F(x+middle,y+middle,A)=(10*(F(x+middle,y+middle,A)-m));
            end
        end
    end
end

I = Img;
%% convolotion Match filtering and Image
for i=1:NF
    Filtered_image(:,:,i)=(conv2(I,F(:,:,i),'same'));
end
Filtered_image_Reshaped=zeros(NF,s1*s2);
A1=zeros(1,s1*s2);

for i=1:NF
    Filtered_image_Reshaped(i,:)=reshape(Filtered_image(:,:,i),1,s1*s2);
end
A1=max(Filtered_image_Reshaped);
Max=max(A1);
Min=min(A1);
IG=reshape(A1,s1,s2);

IG(:,:)=((IG(:,:)-Min)/(Max-Min))* 255;
for i=1:s1
    for j=1:s2
        IG(i,j)=(IG(i,j)+2*IG(i,j)*log(IG(i,j)));
    end
end
% imshow(IG,[]);

%%
sa = 1.1;%2.0;
rt = mim(IG,sa);

Max=max(max(rt));
Min=min(min(rt));
rt(:,:)=round(((rt(:,:)-Min)/(Max-Min))* 255);
% imtool(rt,[]);
rt=otsu(rt,255);

[tt1,e1,cmtx] = myThreshold(rt);

ms = 27;    % changed from 950 to 27
mk = msk(rt,ms);    % chaneg from IG to rt

rt2 = 255*ones(s1,s2);
for i=1:s1
    for j=1:s2
        if rt(i,j)>=tt1 && mk(i,j)==255
            rt2(i,j)=0;
        end
    end
end
J = im2bw(rt2);

J= ~J;
[Label,Num] = bwlabel(J);
Lmtx = zeros(Num+1,1);
for i=1:s1
    for j=1:s2
        Lmtx(double(Label(i,j))+1) = Lmtx(double(Label(i,j))+1) + 1;
    end
end
sLmtx = sort(Lmtx);
cp = 0;   % 0 has good answer
for i=1:s1
    for j=1:s2
        if (Lmtx(double(Label(i,j)+1)) > cp) && (Lmtx(double(Label(i,j)+1)) ~= sLmtx(Num+1,1))
            J(i,j) = 0;
        else
            J(i,j) = 1;
        end
    end
end
for i=1:s1
    for j=1:s2
        if mk(i,j)==0
            J(i,j)=1;
        end
    end
end

im3=rem_noise(J,30,1);
im3=rem_noise(im3,10,2);
% im3=rem_noise(im3,20,3);
% im3=rem_noise(im3,10,4);
% im3=rem_noise(im3,1,5);

Mres=imresize(mask,.995);
dim1=round((size(mask,1)-size(Mres,1))/2);
dim2=round((size(mask,2)-size(Mres,2))/2);


for i=1:size(Mres,1)
    for j=1:size(Mres,2)
        mask(i+dim1,j+dim2)=Mres(i,j);
    end
end

for i=1:s1
    for j=1:s2
        if mask(i,j)==0
            im3(i,j)=1;
        end
    end
end

u    = im2uint8(mat2gray(IG));
% imshow(u,[]);
bw   = im3;

end