function [T]=incomeadjustment(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,p0,x0,p1,p2,...
    r,weight,inc,igrp)

   
   %EV under current (s,T)
   [~,EV]=Classical(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,x0,p0,p1,p2,r);
   
   l=mean(weight.*EV)./mean(weight.*inc);
   
   [g]=unique(igrp,'stable');
   
   NG=length(g);
   x0inc=zeros(NG,1);
   for i=1:NG
       gc=g(i);

       wc=weight(igrp==gc);
       tw=sum(weight(igrp==gc));
 
       xc=x0(igrp==gc);  
       x0inc(i)=sum(wc.*exp(xc)/tw);
   end

   eps=1e-7;   
   diff=1;
   while abs(diff)>eps
   
      linc=zeros(NG,1);
      for i=1:NG
         gc=g(i);

         wc=weight(igrp==gc);
         tw=sum(weight(igrp==gc));
 
         incc=inc(igrp==gc);  
         linc(i)=l*sum(wc.*incc/tw);
      end
      
      T0=zeros(size(x));
      for i=1:NG
         gc=g(i);          

         wc=weight(igrp==gc);
         tw=sum(weight(igrp==gc)); 
         
         target=x0inc(i)-linc(i);
          
         ewrap=@(dx) expinc(A0,Ai,B0,Bi,C0,Ci,D,log(exp(x(igrp==gc))+dx),IC(igrp==gc,:)...
             ,IP(igrp==gc,:),IY(igrp==gc,:),p0(igrp==gc),p1(igrp==gc),p2(igrp==gc),r,wc/tw);
         
         M=@(dx) sum(ewrap(dx).*wc/tw);
         
         F=@(dx) M(dx)-target;
          
         dx=fzero(F,0); 
         
         T0(igrp==gc)=dx;          
      end
     diff=(mean(weight.*T0)); 

     T=T0-diff;      
      
     xC=log(exp(x)+T);
     [~,EV]=Classical(A0,Ai,B0,Bi,C0,Ci,D,xC,IC,IP,IY,x0,p0,p1,p2,r);
     l=mean(weight.*EV)./mean(weight.*inc);
    
   end
   
   xC=log(exp(x)+T0);
   [~,EV]=Classical(A0,Ai,B0,Bi,C0,Ci,D,xC,IC,IP,IY,x0,p0,p1,p2,r);  
   
   NG=length(g);
   l=zeros(NG,1);
   for i=1:NG
       gc=g(i);

       wc=weight(igrp==gc);
       tw=sum(weight(igrp==gc));
 
       EVc=EV(igrp==gc);  
       incc=inc(igrp==gc);
       l(i)=sum(EVc.*wc/tw)/sum(incc.*wc/tw);
   end   
   
   if max(l)-min(l)>1e-4 || abs(mean(weight.*T))>1e-4
       keyboard
   end
end   
function [Einc]=expinc(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,p0,p1,p2,r,weight)

    [~,y]=Marshallian(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,p1,p2,r);
       
    [~,~,E]=Hicksian(A0,Ai,B0,Bi,C0,Ci,D,y,IC,IP,IY,p0,p2,r); 
    E=exp(E);

    Einc=sum(weight.*E);
end
      
   