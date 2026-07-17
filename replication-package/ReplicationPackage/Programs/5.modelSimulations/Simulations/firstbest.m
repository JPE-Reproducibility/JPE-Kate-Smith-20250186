function [T,EV,R]=firstbest(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,p0,x0,p1,p2,...
    R_bar,r,weight,v)
 
   %x=xLF
   %p0=pNS
   %x0=xNS
   %p1=pLF

   inc=(1./v)*1000;  %Income
  
   %Initialize proportional loss based on constant flat transfer
   xC=log(exp(x)+R_bar);
    
   [~,EV]=Classical(A0,Ai,B0,Bi,C0,Ci,D,xC,IC,IP,IY,x0,p0,p1,p2,r);
   %EV=exp(xNS)-exp(e(pNS,v(pLF,xC))

   l=mean(weight.*EV)./mean(weight.*inc);
   
   %Find individual-specific transfers that clear budget constraint and
   %ensure equal proportional losses
   eps=1e-7;   
   g=1;
   while abs(g)>eps
     
      xC=log(exp(x0)-l*inc);
      [~,y]=Marshallian(A0,Ai,B0,Bi,C0,Ci,D,xC,IC,IP,IY,p0,p2,r);
       
      %T0=exp(e(pLF,v(pNS,xNS-loss))-exp(xLF)
      T0=CompVar(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,p1,p2,r,y);
      
      %T=T0-(T0_bar-R_bar)
      T=T0-(mean(weight.*T0)-R_bar);
      
      xC=log(exp(x)+T);
      [~,EV]=Classical(A0,Ai,B0,Bi,C0,Ci,D,xC,IC,IP,IY,x0,p0,p1,p2,r);
      l=mean(weight.*EV)./mean(weight.*inc);
      
      g=T-T0;
   end
   
   xC=log(exp(x)+T0);  
   [~,EV]=Classical(A0,Ai,B0,Bi,C0,Ci,D,xC,IC,IP,IY,x0,p0,p1,p2,r);  
   
   if max(EV./inc)-min(EV./inc)>1e-4
       keyboard
   end
   R=mean(weight.*T);
%       l=(x0-X0(V1(x+T)))/Y
%       l*Y=(x0-X0(V1(x+T)))
%       X0(V1(x+T))=x0-l*Y
%       V1(x+T)=V0(x0-Y*l)
%       x+T=X1(V0(x0-Y*l))  
%       T=X1-x
%       EV=x0-X0(V1(x+T))
