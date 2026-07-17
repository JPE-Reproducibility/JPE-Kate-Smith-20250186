function [as,b0s,bis]=sensitivityadjustment(a0,ai,b0,bi,c0,ci,d,x,IC,IP,IY,p1,p2,r,adjust,w)

    rp=p1-p2;

    b0s=adjust*b0;
    bis=adjust*bi;
    As=(((b0+IP*bi)-(b0s+IP*bis)).*rp)/ai(1);
    ICc=IC;
    ICc(:,1)=IC(:,1)+As;

    e=1;
    eps=1e-8;
    iter=0;
    while max(e)>eps && iter<26
        [wc,~]=Marshallian(a0,ai,b0s,bis,c0,ci,d,x,ICc,IP,IY,p1,p2,r);

        ICc(:,1)=ICc(:,1)+(w-wc)/ai(1);
       
        e=abs(w-wc);
        iter=iter+1;
    end
    as=ICc(:,1);
    if iter==25
        keyboard
    end
    if max(abs(w-wc))>eps
        keyboard
    end
end