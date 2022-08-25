function res=rem_noise(im,k,n)
im=abs(im-1);
 for(l=1:k)
    for(i=2:size(im,1)-1)
        for(j=2:size(im,2)-1)
            sum=im(i-1,j-1)+im(i-1,j)+im(i-1,j+1)+im(i,j-1)+im(i,j+1)+im(i+1,j-1)+im(i+1,j)+im(i+1,j+1);
            if(sum>=n)
                im2(i,j)=im(i,j);
            else
                im2(i,j)=0;
            end;
        end;
    end;
    im=im2;
 end;
 res=abs(im2-1);
return
