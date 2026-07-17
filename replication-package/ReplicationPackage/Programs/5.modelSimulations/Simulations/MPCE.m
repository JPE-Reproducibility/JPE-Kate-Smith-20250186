function MPCE(DataFileName,InDir,OutDir,thetahat,r,nZC,nRC,nZY,nRY,nZP,s,ci)

cf=0;
[id,t,xS,p,Z,R,IP,ZY,RY,pNS,weight,T,F,Fcf,Inc]=dataprepare(InDir,DataFileName,...
    nZC,nRC,nZY,nRY,nZP,cf);

[A0,Ai,B0,Bi,C0,Ci,D]=parammap(thetahat,r,nZC,nRC,nZY,nRY,nZP);
    
T=mean(weight.*T);

ICB=[Z R];                  %Constant shifters (rebate included)
ICE=[Z zeros(size(R))];     %Constant shifters (rebate excluded)
IYB=[ZY RY];                %Y shifters (rebate included)
IYE=[ZY zeros(size(RY))];   %Y shifters (rebate excluded)

xLF=log(exp(xS)-T);         %Expenditure (rebate excluded)
xNS=log(exp(xLF)+Fcf-F);    %Expenditure (no shock)

pS=p(:,1);                  %Shocked price (obs policy)
pLF=log(exp(p(:,1))/(1-s)); %Shocked price (no subsidy)

pn=p(:,2);                  %Non-durable price

ext=0.059*1.24*mean(exp(pS));     %Externality per pound

N=length(id);

[ICB,IYB]=rebatesort(A0,Ai,B0,Bi,C0,Ci,D,xS,ICE,ICB,IP,IYE,IYB,pS,pn,r,[],[]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Subsidy and rebate 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pe=pS;
x=xS;
IC=ICB;
IY=IYB;
[w,y]=Marshallian(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,pe,pn,r);

[belas]=budgetelas(w,y,r,p,IY,C0,Ci,D);

[telas]=transferelas(w,y,r,p,IY,C0,Ci,D);
end

function [belas]=budgetelas(w,y,r,p,IY,c0,ci,d)
    Y=zeros(length(y),r);
    for f=1:r
         Y(:,f)=f*y.^(f-1);     
    end    
    
    rp=p(:,1)-p(:,2);
    
    belas=(Y*c0+IY*ci.*Y(:,1))+d*rp;
    belas=(1./w).*belas.*(1./(1-0.5*d*rp.^2+rp.*belas))+1;
end

function [telas]=transferelas(w,y,r,p,IY,c0,ci,d)
    Y=zeros(length(y),r);
    for f=1:r
         Y(:,f)=f*y.^(f-1);     
    end    
    
    rp=p(:,1)-p(:,2);
    
    belas=(Y*c0+IY*ci.*Y(:,1))+d*rp;
    belas=(1./w).*belas.*(1./(1-0.5*d*rp.^2+rp.*belas))+1;
end