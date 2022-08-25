function u = acwe_dwt(u0, Img,  timestep,...
                    mu, v, lambda1, lambda2, pc, ...
                    epsilon, numIter, lambda3, lambda4, lambda5, Iv, mf_bw, row, col)
 
%paper by Mahtab Shabani: "An active contour model using matched filter and
%                          Hessian matrix for retinal vessels segmentation".

% link: https://journals.tubitak.gov.tr/elektrik/vol30/iss1/20/

%note: it is a enhanced method to improve the CV model described in ref [1]
%Inputs:
%u0: the initial function.
%Img: the input image.
%timestep: the descenting step each time(positive real number)
%mu: the length term of minimizing energy functional
%v: the area term of minimizing energy functional
%lambda1, lambda2: the data fitting term
%lambda3, lambda4, %lambda5: thee constants of wavelet terms
%alpha1 , alpha2 , and alpha3 are related to the optimization process in equation(5)
%pc: the penalty coefficient(used to avoid reinitialization according to [2])
%epsilon: the parameter to avoid 0 denominator
%numIter: the number of iterations
%reference:
%[1]. Active contour without edge. chan etc
%[2]. Minimizaion of region-scalable fitting energy for image segmentation.
%     by Li chunming etc.


%% Wavelet terms in eq(3)
[cA4,cH4,cV4,cD4] = dwt2(u0,'db15');
UU      = idwt2(cA4,[],[],[],'db15',[row col]);
[cA3,cH3,cV3,cD3] = dwt2(UU,'db10');
cA     = idwt2(cA3,[],[],[],'db10',[row col]);
[cA,cH,cV,cD] = dwt2(cA,'db9');
cod_X = wcodemat(u0);
cod_cA = wcodemat(cA); cod_cH = wcodemat(cH); 
cod_cV = wcodemat(cV); cod_cD = wcodemat(cD); 
cod_cH = imresize(cod_cH,[row col]);
cod_cV = imresize(cod_cV,[row col]);
cod_cD = imresize(cod_cD,[row col]);
Dch = cod_cH;
Dcv = cod_cV;
Dcd = cod_cD;

mm=mean(u0(:));
sigmas = std(u0(:));

%%
u = u0;
for k1=1:numIter
    u = NeumannBoundCond(u);
    K = curvature_central(u);
%     DrcU=(epsilon/pi)./(epsilon^2+u.^2); %eq.(9), ref[2] the delta function
%     Hu=0.5*(1+(2/pi)*atan(u./epsilon));  %eq.(8)[2] the character
    e    = exp(1);
%     Hu   = .75*(.5*(1 + (u./(sqrt(1+(u.^2)))) + .5*(1./(1+e.^(-u)))));
    Hu   = .75*(.5*(1 + (u./(sqrt(1+(u.^2)))) + .5*(1./(1+exp(-u)))));
    DrcU = .2.* (1./sqrt(u.^2+1)-u.^2./((u.^2+1).^(3/2)) + (e.^(-u))./((1+(e.^(-u))).^2));

    th = mean(Hu(:));
    inside_idx = find(Hu(:) < th);
    outside_idx = find(Hu(:) >= th);

    c1 = mean(Img(inside_idx));
    c2 = mean(Img(outside_idx));

    data_force = -DrcU.*(mu*K - v - lambda1*(Img-c1).^2 + lambda2*(Img-c2).^2 + lambda3*real(sqrt(Dch.*Img)) + lambda4*real(sqrt(Dcv.*Img)) + lambda5*real(sqrt(Dcd.*Img)));

    u = u + timestep*(data_force);
%     U = Iv.*u;

%%%%%%%%%%%%% Optimization process %%%%%%%%%%%%%%%
    alpha1 = 0.8;
    alpha2 = 0.07;
    alpha3 = 0.08;
    u = alpha1*u + alpha2*Iv.*u + alpha3*mf_bw.*u;

end                 %

function g = NeumannBoundCond(f)
%Neumann boundary condition
%originally written by Li chunming
%http://www.mathworks.com/matlabcentral/fileexchange/12711-level-set-for-image-segmentation
[nrow, ncol] = size(f);
g = f;
g([1 nrow],[1 ncol]) = g([3 nrow-2],[3 ncol-2]);
g([1 nrow],2:end-1) = g([3 nrow-2],2:end-1);
g(2:end-1,[1 ncol]) = g(2:end-1,[3 ncol-2]);

function k = curvature_central(u)
%compute curvature:
%originally written by Li chunming
%http://www.mathworks.com/matlabcentral/fileexchange/12711-level-set-for-im
%age-segmentation
[ux, uy] = gradient(u);
normDu = sqrt(ux.^2+uy.^2+1e-10);
Nx = ux./normDu; Ny = uy./normDu;
[nxx, junk] = gradient(Nx); [junk, nyy] = gradient(Ny);
k = nxx+nyy;
% k = double(MatchFilter(u));

function k = curvature(P,h)
% computes curvature by central differences
Pxx = diff(P([1 1:end end],:),2)/h^2;
Pyy = diff(P(:,[1 1:end end])',2)'/h^2;
Px = (P(3:end,:)-P(1:end-2,:))/(2*h); Px = Px([1 1:end end],:);
Py = (P(:,3:end)-P(:,1:end-2))/(2*h); Py = Py(:,[1 1:end end]);
Pxy = (Px(:,3:end)-Px(:,1:end-2))/(2*h); Pxy = Pxy(:,[1 1:end end]);
F = (Pxx.*Py.^2-2*Px.*Py.*Pxy+Pyy.*Px.^2)./(Px.^2+Py.^2).^1.5;
F = min(max(F,-1/h),1/h);
