function mk = msk(IG,ms)


[M,N] = size(IG);
mk = zeros(M,N);
for l=1:M
    for k=1:N
        if IG(l,k)>ms
            mk(l,k)=255;
        end
    end
end

for i=1:N
    for j=1:M
        if mk(j,i)==255
            for k=1:10    % changed from 10 to 25
                mk(j+k-1,i)=0;
            end
            break;
        end
    end
end
for i=1:N
    for j=M:-1:1
        if mk(j,i)==255
            for k=1:10
                mk(j-k+1,i)=0;
            end
            break;
        end
    end
end