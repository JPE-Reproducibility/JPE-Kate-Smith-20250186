function [T,R,ICc,IYc]=equivrebate(A0,Ai,B0,Bi,C0,Ci,D,x,ICB,IP,IYB,ICE,IYE,...
    p1,p2,Top,sop,R_bar,r,weight,ext,qLF)

   %Current subsidy level
   xop=log(exp(x)+Top); 
   [w,~]=Marshallian(A0,Ai,B0,Bi,C0,Ci,D,xop,ICB,IP,IYB,p1,p2,r);
   q=w.*exp(xop)./exp(p1);     
   g=1;
   eps=1e-7;   
   %Adjust transfer until government budget constraint holds
   %(s/(1-s))*w*(x+T)+TN=R_bar
   while abs(g)>eps
      T0=(1/(1+(sop/(1-sop))*mean(w.*weight)))*(R_bar-(sop/(1-sop))*mean(w.*exp(x).*weight)...
          -ext*mean((q-qLF).*weight));   
      xop=log(exp(x)+T0);
 
      [ICc,IYc]=rebatesort(A0,Ai,B0,Bi,C0,Ci,D,x,ICE,ICB,IP,IYE,IYB,...
            p1,p2,r,T0,Top);
        
      [w,~]=Marshallian(A0,Ai,B0,Bi,C0,Ci,D,xop,ICc,IP,IYc,p1,p2,r);
      q=w.*exp(xop)./exp(p1);        
      
      T=(1/(1+(sop/(1-sop))*mean(w.*weight)))*(R_bar-(sop/(1-sop))*mean(w.*exp(x).*weight)...
          -ext*mean((q-qLF).*weight));   
      g=(T-T0);
   end
   xop=log(exp(x)+T);
   
   [ICc,IYc]=rebatesort(A0,Ai,B0,Bi,C0,Ci,D,x,ICE,ICB,IP,IYE,IYB,...
       p1,p2,r,T,Top);
        
   [w,~]=Marshallian(A0,Ai,B0,Bi,C0,Ci,D,xop,ICc,IP,IYc,p1,p2,r);
   q=w.*exp(xop)./exp(p1);
   
   R=(sop/(1-sop))*mean(w.*exp(xop).*weight)+T+ext*mean((q-qLF).*weight);
end


