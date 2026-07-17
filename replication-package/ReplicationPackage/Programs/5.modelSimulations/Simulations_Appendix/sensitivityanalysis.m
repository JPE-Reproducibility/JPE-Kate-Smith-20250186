function [B0S,BiS,ICB,ICE]=sensitivityanalysis(A0,Ai,B0,Bi,C0,Ci,D,xNS,ICB,ICE,...
    IP,IYE,pS,pNS,pn,r,weight,adjust)

%Demand at crisis price and true parameters
pe=pS;
x=xNS;
IC=ICE;
IY=IYE;
[w,~]=Marshallian(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,pe,pn,r);
q=w.*exp(xNS)./exp(pS);

%No shock predictions 
pe=pNS;
x=xNS;
IC=ICE;
IY=IYE;
[w0,~]=Marshallian(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,pe,pn,r);
q0=w0.*exp(xNS)./exp(pNS);

%Mean response elasticity at true parameters
e=((mean(weight.*q)-mean(weight.*q0))/mean(weight.*q0))./...
    ((mean(weight.*exp(pS))-mean(weight.*exp(pNS)))/mean(weight.*exp(pNS)));

%Adjust baseline Hicksian price parameter
%Also adjust constant to keep predicted in shares in observed environment
%unchanged
%(for convenience, do this through adjusting first interaction variable in constant)

[AS,B0S,BiS]=sensitivityadjustment(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,pe,pn,r,adjust,w0);

ICB(:,1)=AS;
ICE(:,1)=AS;

%Verying adjusted elasticity is approximate half or double original one 

pe=pS;
x=xNS;
IC=ICE;
IY=IYE;
[w,~]=Marshallian(A0,Ai,B0S,BiS,C0,Ci,D,x,IC,IP,IY,pe,pn,r);

q=w.*exp(xNS)./exp(pS);

ea=((mean(weight.*q)-mean(weight.*q0))/mean(weight.*q0))./...
    ((mean(weight.*exp(pS))-mean(weight.*exp(pNS)))/mean(weight.*exp(pNS)));

ok1 = adjust<1 && abs(ea/e-1.5)<0.05;
ok2 = adjust>1 && abs(ea/e-0.5)<0.05;

if ok1+ok2~=1
    keyboard
end