function rt = mim(I,sa)

% NF=24;
% 
% I=im2double(I);
% S=size(I);
% s1=S(1);
% s2=S(2);
% 
% count=0;
% M=0;
% Sigma=1.1;  %% NOTE: changed from 2 to 1.1
% Length=7;   %% NOTE: changed from 9 to 7
% Size=25;    %% NOTE: changed from 17 to 25
% 
% Bound=3*Sigma;     %% Default: 3*Sigma
% middle=round(Size/2);
% 
% F=zeros(1:Size,1:Size,NF);
% 
% for A=1:NF
%     Ang=(A)*(pi/NF);
% 
%     for x=-fix(Size/2):fix(Size/2)
%                for y=-fix(Size/2):fix(Size/2)
%                    %computing new rows
%                    u=((x)*cos(Ang)+(y)*sin(Ang));
%                    v=((y)*cos(Ang)-(x)*sin(Ang));
%                    F(x+middle,y+middle,A)=0;
%                    if (u>=-Bound && u<=Bound)&&(v>-Length/2 && v<Length/2)
%                       count=count+1;
%                       F(x+middle,y+middle,A)=exp(-(u^2)/(2*Sigma^2));% -100*tpdf(u,free);%-((u^((free-2)/2)*exp(-u/2))/(2^(free/2)*gamma(free/2)));% -exp(-(u^2)/(2*Sigma^2));%-cauchypdf(u,0,Sigma); % And its derivation is (-2*Sigma*u/((u^2+Sigma^2)^2));
%                       M=M+F(x+middle,y+middle,A);
%                    end
%                end
%     end
% 
%     m=M/count;
% 
%     for x=-fix(Size/2):fix(Size/2)
%         for y=-fix(Size/2):fix(Size/2)
%             %computing new rows
%             u=((x)*cos(Ang)+(y)*sin(Ang));
%             v=((y)*cos(Ang)-(x)*sin(Ang));
%             if (u>=-Bound && u<=Bound)&&(v>-Length/2 && v<Length/2)
%                 F(x+middle,y+middle,A)=(10*(F(x+middle,y+middle,A)-m));
%             end
%         end
%     end
% end
% %_____________________________________________________
% % Convoloution Original Retina image with Filter_Bank elements-
% % to detection Blood Vessele in 48 Different Direction.
%  for i=1:NF
%      Filtered_image(:,:,i)=(conv2(I,F(:,:,i),'same'));
%      %figure;imshow(Filtered_image(:,:,i),[]);
%      %title('Blood Vessels at one Direction (HighLight)');
%  end
% %_____________________________________________________
% % Computing the Maximum local Response bettween Responses to Filters.
% Filtered_image_Reshaped=zeros(NF,s1*s2);
% A1=zeros(1,s1*s2);
%  for i=1:NF
%      Filtered_image_Reshaped(i,:)=reshape( Filtered_image(:,:,i),1,s1*s2);
%  end
% 
% A1=max(Filtered_image_Reshaped);
% rt=reshape(A1,s1,s2);

% imtool(rt,[]);
% 
% rmin = abs(min(min(rt)));
% for m = 1:s1
%     for n = 1:s2
%         rt(m,n) = rt(m,n) + rmin;
%     end
% end
% rmax = max(max(rt));
% for m = 1:s1
%     for n = 1:s2
%         rt(m,n) = round(rt(m,n)*255/rmax);
%     end
% end

% 
% [M,N] = size(I);
% x = [-6: 6];% [-6: 6];
% tmp1 = -exp(-(x.*x)/(2*sa*sa)); %  cauchypdf(x,0,sa);
% tmp1 = max(tmp1)-tmp1; 
% ht1 = repmat(tmp1,[9 1]); 
% sht1 = sum(ht1(:));
% mean = sht1/(13*9);
% ht1 = ht1 - mean;
% ht1 = ht1/sht1;
% 
% h{1} = zeros(15,16);
% for i = 1:9
%     for j = 1:13
%         h{1}(i+3,j+1) = ht1(i,j);
%     end
% end
% 
% for k=1:11
%     ag = 15*k;
%     h{k+1} = imrotate(h{1},ag,'bicubic','crop');
% %    h{k+1} = wkeep(h{k+1},size(h{1}));
% end
% 
% for k=1:12
%     R{k} = conv2(I, h{k}, 'same');
% end
% 
% rt = zeros(M,N);
% for i=1:M
%     for j=1:N
%         ER = [R{1}(i,j), R{2}(i,j), R{3}(i,j), R{4}(i,j), R{5}(i,j), R{6}(i,j),... 
%                 R{7}(i,j), R{8}(i,j), R{9}(i,j), R{10}(i,j), R{11}(i,j), R{12}(i,j)];
%         rt(i,j) = max(ER);
%     end
% end

%%%%%%
S=size(I);
s1=S(1);
M=s1;
s2=S(2);
N=s2;
NF=24*2; 
F=zeros(25,24,NF);
f2 = -1*[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;     %1
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;       %5
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;       %10
     0 0 0 0 0 0 4 3 2 1 0 -10 -10 0 1 2 3 4 0 0 0 0 0 0;   %added
     0 0 0 0 0 0 4 3 2 1 0 -10 -10 0 1 2 3 4 0 0 0 0 0 0;   %added
     0 0 0 0 0 0 4 3 2 1 0 -10 -10 0 1 2 3 4 0 0 0 0 0 0; 
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;       %15
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;       %20
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ]; 
 
F(:,:,1)=f2;
% _______________________________________________________________
% Generating Different Filter From above Filter by Rotating
 for i=1:NF-1
     F(:,:,i+1)=imrotate(F(:,:,1),(180/NF)*i,'bilinear','crop');
 end
%_____________________________________________________
% Convoloution Original Retina image with Filter_Bank elements-
% to detection Blood Vessele in 48 Different Direction.
 for i=1:NF
     Filtered_image(:,:,i)=(conv2(I,F(:,:,i),'same'));
     %figure;imshow(Filtered_image(:,:,i),[]);
     %title('Blood Vessels at one Direction (HighLight)');
 end
%_____________________________________________________
% Computing the Maximum local Response bettween Responses to Filters.
Filtered_image_Reshaped=zeros(NF,s1*s2);
A1=zeros(1,s1*s2);
 for i=1:NF
     Filtered_image_Reshaped(i,:)=reshape(Filtered_image(:,:,i),1,s1*s2);
 end

  A1=max(Filtered_image_Reshaped);
  Response_image=reshape(A1,s1,s2);
  rt=Response_image;
  
% % imtool(rt,[]);

rmin = abs(min(min(rt(:))));
for m = 1:M
    for n = 1:N
        rt(m,n) = rt(m,n) + rmin;
    end
end
rmax = max(max(rt));
for m = 1:M
    for n = 1:N
        rt(m,n) = round(rt(m,n)*255/rmax);
    end
end
