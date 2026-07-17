 function [w,q,E]=Hicksian(a0,ai,b0,bi,c0,ci,d,y,IC,IP,IY,p1,p2,r)

    rp=p1-p2;

    Y=zeros(length(y),r);
    dY=zeros(length(y),r);
    for f=1:r
       Y(:,f)=y.^f;   
       dY(:,f)=f.*(Y(:,f)./y).^(f-1);
    end   
     
    w=a0+IC*ai+(b0+IP*bi).*rp+Y*c0+IY*ci.*Y(:,1)+d*rp.*y;
    
    E=y+p2+rp.*(a0+IC*ai+Y*c0+IY*ci.*Y(:,1))+0.5*(b0+IP*bi).*rp.^2+...
        0.5*d*rp.^2.*y;

    q=w.*exp(E)./exp(p1);
 end
