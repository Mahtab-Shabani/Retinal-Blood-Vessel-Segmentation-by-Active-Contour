function se=makeLineKernel(len,theta_d,coeffs)
%
%%% L1=length(coeffs) must be odd.
if (len >= 1)
    theta = theta_d * pi / 180;
    x = round((len-1)/2 * cos(theta));
    y = -round((len-1)/2 * sin(theta));
    [c,r] = iptui.intline(-x,x,-y,y);
    M = 2*max(abs(r)) + 1;
    N = 2*max(abs(c)) + 1;
    idx = sub2ind([M N], r + max(abs(r)) + 1, c + max(abs(c)) + 1);
    se=zeros(M,N);
    L1=length(coeffs);
    L2=length(idx);
    if L2<L1
        coeffs2=zeros(length(idx));
        coeffs2=coeffs((1+ceil((L1-L2)/2)):(L1-floor((L1-L2)/2)));
        se(idx)=coeffs2;
    else
        se(idx)=coeffs;
    end
end