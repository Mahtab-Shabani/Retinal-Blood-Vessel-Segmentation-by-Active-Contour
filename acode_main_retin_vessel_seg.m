% This code is implemented a vessel segmentation algorithm for retinal
% images that was introduced in the following paper:
%     Heneghan, C., Flynn, J., O’Keefe, M., & Cahill, M. (2002). 
%     Characterization of changes in blood vessel width and tortuosity 
%     in retinopathy of prematurity using image analysis. 
%     Medical Image Analysis, 6(4), 407–429.
% 
% This code was written by Ashkan Abbasi, Isfahan University, Iran. 
% 2012
function Img = acode_main_retin_vessel_seg(im, bw_mask, ref_im)
addpath(genpath('./functions'));
% im=Img;
% bw_mask=imgmsk;
bw_mask=logical(bw_mask);
% ref_im=imgman;
%
im=mat2gray(im).*mat2gray(bw_mask);
im=imcomplement(im);% Assume vessels are lighter than background
im=im2double(im);
ref_bw=im2bw(ref_im,0.5);
%%
DEG_NUM=12;
LEN_c=11;
LEN_o=11;
LEN_diff=7;
%
ic1=reconstruction_by_dilation(im,LEN_c,DEG_NUM); %dilation
io1=min_openings(im,LEN_o,DEG_NUM);
iv=mat2gray(ic1-io1);
imDiff=smooth_cross_section(iv,LEN_diff,LEN_c);
imL=reconstruction_by_dilation(imDiff,LEN_c,DEG_NUM);
imF=reconstruction_by_erosion(imL,LEN_c,DEG_NUM);
% 
% figure,imshow(iv);title('iv');
% figure,imshow(imDiff);title('imDiff');
% figure,imshow(imL);title('imL');
% figure,imshow(imF);title('imF');
%% Hysteresis thresholding
% TH_LOW=30;
% TH_HIGH=40;
% min_obj=180;
% min_hole=10;
% %
% mask=im2bw(imF,TH_LOW/255);
% marker=im2bw(imF,TH_HIGH/255);
% bw_result=imreconstruct(marker,mask);
% %
% % some extra cleaning on the result.
% bw_result=bw_result& bw_mask;
% bw_result = clear_bw(bw_result, min_obj, min_hole);
% %
% figure,imshow(bw_result);title('result');
% r=eval_metrics(bw_result,ref_bw,bw_mask);
% fprintf('TPR=%g\n FPR=%g\n accuracy=%g\n precision=%g\n',...
%     r(1),r(2),r(3),r(4));
%%
Img = imF;
% Img = normalize01(Img);
% Img = im2uint8(mat2gray(Img));
end