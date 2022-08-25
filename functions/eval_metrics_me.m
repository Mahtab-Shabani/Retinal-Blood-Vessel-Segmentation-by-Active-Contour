function r=eval_metrics_me(bw,ref_bw,bw_mask)
% INPUTS
%     bw: segmented image-(logical)
%     ref_bw: ground-truth-(logical)
%     bw_mask: FOV mask-(logical)
% OUTPUTS
%     r=[TPR;FPR;accuracy;precision];
%
TP_image=ref_bw&bw;
TP=sum(TP_image(:));% # of hits (True Positive)
FN_image=ref_bw&~bw;
FN=sum(FN_image(:));% # of misses (False Negative\Type 2 Error)

FP_image=~ref_bw&bw;
FP=sum(FP_image(:));% # of false alarms (False Positive/Type 1 Error)
TN_image=~ref_bw&~bw;
TN=sum(TN_image(:));% # of correct rejections (True Negative)

accuracy=(TP+TN)/(TP+FN+FP+TN);
TPR=TP/(TP+FN);% True Positive Rate (sensitivity/recall/hit rate)
FPR=FP/(FP+TN);% False Positive Rate (specificity=1-FPR)
PPV=TP/(TP+FP);%positive predictive value (precision)
SN =TP/(TP+FN);
SP =TN/(TN+FP);
AUC=(SN+SP)/2;

r=[TPR;FPR;accuracy;PPV;SN;SP;AUC];