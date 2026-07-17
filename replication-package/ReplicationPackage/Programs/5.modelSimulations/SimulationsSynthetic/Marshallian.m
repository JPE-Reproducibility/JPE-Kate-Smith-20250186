function [w,y]=Marshallian(a0,ai,b0,bi,c0,ci,d,x,IC,IP,IY,p1,p2,r)

    rp=p1-p2;    

    w=0.1*ones(length(x),1);
    y=x-w.*p1-(1-w).*p2;

    e=1;
    eps=5e-3; %loose tolerance FOR SYNTHETIC DATA ONLY
    %eps=1e-8; %tolerance for actual data run
    iter=0;
    while max(e)>eps && iter<25
        y0=y;
        w0=w;
        Y=zeros(length(x),r);
        for f=1:r
            Y(:,f)=y.^f;       
        end        

        w=a0+IC*ai+(b0+IP*bi).*rp+Y*c0+IY*ci.*Y(:,1)+d*rp.*y;

        y=(x-w.*p1-(1-w).*p2+0.5*(b0+IP*bi).*rp.^2)./(1-0.5*d*rp.^2);
  
        ew=abs(w-w0);
        ey=abs(y-y0);
        e=max(ew,ey);
        iter=iter+1;
    end
    if iter==25
        keyboard
    end
end