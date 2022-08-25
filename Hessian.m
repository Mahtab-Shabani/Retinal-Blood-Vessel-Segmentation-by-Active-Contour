function [Lambda2,Lambda1,Ix,Iy,Rb,S]=Hessian(I,sigmas)
    [Dxx,Dxy,Dyy] = Hessian2D(I,sigmas);
    
    % Correct for scale
    Dxx = (sigmas^2)*Dxx;
    Dxy = (sigmas^2)*Dxy;
    Dyy = (sigmas^2)*Dyy;

%    | Dxx  Dxy |
%    |          |
%    | Dxy  Dyy |
%     hess = [Dxx Dxy;
%             Dxy Dyy];
%     ab = Dxx .* Dyy;
%     cd = Dxy .* Dxy;
%     Det=det(hess);
    % Calculate (abs sorted) eigenvalues and vectors
    [Lambda2,Lambda1,Ix,Iy]=eig2image(Dxx,Dxy,Dyy);

    % Compute the direction of the minor eigenvector
    angles = atan2(Ix,Iy);
     % Compute some similarity measures
%     Lambda1(Lambda1==0) = eps;
    Rb = (Lambda2./Lambda1).^2;
    S = Lambda1.^2 + Lambda2.^2;
%     S = sqrt(Lambda1.^2 + Lambda2.^2);
   
end

% EDGE  = Lambda1<Lambda2;
% BackG = Lambda1>Lambda2;
