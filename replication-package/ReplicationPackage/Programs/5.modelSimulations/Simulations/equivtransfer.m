function [T,q,R]=equivtransfer(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,p1,p2,...
    Top,sop,R_bar,r,weight)

   %Current subsidy level
   xop=log(exp(x)+Top); 
   [w,~]=Marshallian(A0,Ai,B0,Bi,C0,Ci,D,xop,IC,IP,IY,p1,p2,r);
      
   g=1;
   eps=1e-7;   
   %Adjust transfer until government budget constraint holds
   %(s/(1-s))*w*(x+T)+TN=R_bar
   while abs(g)>eps
      T0=(1/(1+(sop/(1-sop))*mean(w.*weight)))*(R_bar-(sop/(1-sop))*mean(w.*exp(x).*weight));   
      xop=log(exp(x)+T0);
        
      [w,~]=Marshallian(A0,Ai,B0,Bi,C0,Ci,D,xop,IC,IP,IY,p1,p2,r);
      
      T=(1/(1+(sop/(1-sop))*mean(w.*weight)))*(R_bar-(sop/(1-sop))*mean(w.*exp(x).*weight));   
      g=(T-T0);
   end
   xop=log(exp(x)+T);
   [w,~]=Marshallian(A0,Ai,B0,Bi,C0,Ci,D,xop,IC,IP,IY,p1,p2,r);
   q=w.*exp(xop)./exp(p1);
   R=(sop/(1-sop))*mean(w.*exp(xop).*weight)+T;
end


