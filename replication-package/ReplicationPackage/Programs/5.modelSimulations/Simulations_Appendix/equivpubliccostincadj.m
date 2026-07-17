function [T,incT,R]=equivpubliccostincadj(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,p1,p2,...
    Top,sop,R_bar,r,weight,ext,qLF,v,p0,x0,inc,igrp)

   inc=(1./inc)*1000;  %Income
   
   %Current subsidy level
   xop=log(exp(x)+Top); 
   [w,~]=Marshallian(A0,Ai,B0,Bi,C0,Ci,D,xop,IC,IP,IY,p1,p2,r);
   q=w.*exp(xop)./exp(p1);        
   g=1;
   eps=1e-7;   
   %Adjust transfer until government budget constraint holds
   %(s/(1-s))*w*(x+T)+TN=R_bar
   while abs(g)>eps
    T0=(1/((mean(v.*weight)+(sop/(1-sop))*mean(w.*v.*weight))))*...
        (R_bar-(sop/(1-sop))*mean(w.*exp(x).*weight)...
          -ext*mean((q-qLF).*weight));   
      xop=log(exp(x)+v.*T0);
   
      [incT]=incomeadjustment(A0,Ai,B0,Bi,C0,Ci,D,xop,IC,IP,IY,p0,x0,p1,p2,...
        r,weight,inc,igrp);
        
      xop=log(exp(x)+v.*T0+incT);     
      [w,~]=Marshallian(A0,Ai,B0,Bi,C0,Ci,D,xop,IC,IP,IY,p1,p2,r);
      q=w.*exp(xop)./exp(p1);
      
      T=(1/((mean(v.*weight)+(sop/(1-sop))*mean(w.*v.*weight))))*...
          (R_bar-(sop/(1-sop))*mean(w.*exp(x).*weight)...
          -ext*mean((q-qLF).*weight));   
      g=(T-T0);
   end
   xop=log(exp(x)+v.*T+incT);
  
   [w,~]=Marshallian(A0,Ai,B0,Bi,C0,Ci,D,xop,IC,IP,IY,p1,p2,r);
   q=w.*exp(xop)./exp(p1);
   R=(sop/(1-sop))*mean(w.*exp(xop).*weight)+T*mean(v.*weight)...
       +ext*mean((q-qLF).*weight);
   
end