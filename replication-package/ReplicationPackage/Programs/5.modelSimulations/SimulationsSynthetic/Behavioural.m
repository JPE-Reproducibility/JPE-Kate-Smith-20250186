function [qb,EV,gt,Tag]=Behavioural(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,x0,ICE,IYE,...
    p0,p1,p2,r)

%q_b(p,x)
[wb,~]=Marshallian(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,p1,p2,r);
qb=wb.*exp(x)./exp(p1);
%q2_b=(1-w_b).*exp(x)./exp(p2);


 [wA,yA]=Marshallian(A0,Ai,B0,Bi,C0,Ci,D,x,ICE,IP,IYE,p1,p2,r);
 Nodis=wA==wb;
 qA=wA.*exp(x)./exp(p1);
    
 %Find g such that q_b(p,x)=q(p-g,x-gq_b)
 %Evaluate v(p-w,x-w1)
 gap=1;
 eps=1e-9;
 g=-2*ones(length(x),1);
 iter=0;
 while gap>eps && iter<101

     g0=g;
     g0t=1./(1+exp(-g0));

     p1a=log(exp(p1).*(1-g0t));
     p1a(Nodis==1)=p1(Nodis==1);
     xa=log(exp(x)-g0t.*exp(p1).*qb);
     xa(Nodis==1)=x(Nodis==1);

     [w,~]=Marshbehave(A0,Ai,B0,Bi,C0,Ci,D,xa,ICE,IP,IYE,p1a,p2,r);

     q=w.*exp(xa)./exp(p1a);

     g=g0+log(max(qb,eps))-log(max(q,eps));

     if sum(isnan(g))>0
        keyboard
     end
    gt=1./(1+exp(-g));

    gap=max(abs(g-g0));
    iter=iter+1;
 end

 p1a=log(exp(p1).*(1-gt));
 xa=log(exp(x)-gt.*exp(p1).*qb);
 [w,y]=Marshbehave(A0,Ai,B0,Bi,C0,Ci,D,xa,ICE,IP,IYE,p1a,p2,r);
 q=w.*exp(xa)./exp(p1a);
    
 y(Nodis==1)=yA(Nodis==1);
 q(Nodis==1)=qA(Nodis==1);
    
 %Track any problematic observations
 Tag=zeros(size(x0));
 Tag(abs(q-qb)>0.01*qb)=1;
 Tag(isnan(gt))=1;
 Tag(isnan(q))=1;
 Tag(isnan(qb))=1;
 Tag(find(imag(gt)~=0))=1;

 %v(p0,x-EV)=v(p(1-s),x+R)
 %EV=x-e(p0,v(p(1-s),x+R))
 [~,~,EV]=Hicksian(A0,Ai,B0,Bi,C0,Ci,D,y,ICE,IP,IYE,p0,p2,r);
 EV=exp(x0)-exp(EV);
 
 gt(Nodis==1)=0;
 gt(Tag==1)=0;
 qb(Tag==1)=0;
 EV(Tag==1)=0;
