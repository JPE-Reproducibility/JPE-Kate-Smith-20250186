function [q,EV]=Classical(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,x0,...
     p0,p1,p2,r)

%q_b(p,x)
[w,y]=Marshallian(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,p1,p2,r);
q=w.*exp(x)./exp(p1);

%v(p0,x-EV)=v(p(1-s),x+R)
%EV=x-e(p0,v(p(1-s),x+R))
[~,~,EV]=Hicksian(A0,Ai,B0,Bi,C0,Ci,D,y,IC,IP,IY,p0,p2,r);
EV=exp(x0)-exp(EV);
