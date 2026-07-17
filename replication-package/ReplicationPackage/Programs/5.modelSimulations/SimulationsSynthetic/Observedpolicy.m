function Observedpolicy(DataFileName,InDir,OutDir,thetahat,r,nZC,nRC,nZY,nRY,nZP,s,ci)

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
%No shock
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pe=pNS;
x=xNS;
IC=ICE;
IY=IYE;
[w0,y0]=Marshallian(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,pe,pn,r);
q0=w0.*exp(x)./exp(pe);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Subsidy and rebate: no behavioural response
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pe=pS;

FOSR=q0.*(exp(pe)-exp(pNS))+(F-Fcf)-T;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%No policy intervention: no behavioural response
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pe=pLF;

FOLF=q0.*(exp(pe)-exp(pNS))+(F-Fcf);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Subsidy and rebate 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pe=pS;
x=xS;
IC=ICB;
IY=IYB;

[qSR,EVSR,gt,Tag]=Behavioural(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,xNS,ICE,IYE,...
    pNS,pe,pn,r);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%No policy intervention
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pe=pLF;
x=xLF;
IC=ICE;
IY=IYE;

[qLF,EVLF]=Classical(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,xNS,pNS,pe,pn,r);
[CVLF]=CompVar(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,pe,pn,r,y0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Targeting cost only
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Tt=(s/(1-s))*qSR.*exp(pS)+T+ext*mean((qSR-qLF).*weight);

pe=pLF;
x=log(exp(xLF)+Tt);
IC=ICE;
IY=IYE;

[~,EVTt]=Classical(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,xNS,pNS,pe,pn,r);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Lump-sum tax 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Tl=(s/(1-s))*qSR.*exp(pS)+T;

pe=pLF;
x=log(exp(xLF)+Tl);
IC=ICE;
IY=IYE;

[~,EVTl]=Classical(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,xNS,pNS,pe,pn,r);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Subsidy and transfer (fixed)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pe=pS;
x=xS;
IC=ICE;
IY=IYE;

[qST,EVST]=Classical(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,xNS,pNS,pe,pn,r);
qSR(Tag==1)=qST(Tag==1);
EVSR(Tag==1)=EVST(Tag==1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Subsidy and transfer (budg bal)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
R_bar=(s/(1-s))*mean(qSR.*exp(pS).*weight)+T;

pe=pS;
x=xLF;
IC=ICE;
IY=IYE;

[Te,~,Rv]=equivtransfer(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,pe,pn,...
   T,s,R_bar,r,weight);
if max(abs((Rv-R_bar)/Rv))>1e-3
    keyboard
end  

x=log(exp(x)+Te);
[~,EVSTe]=Classical(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,xNS,pNS,pe,pn,r);

HHData=[FOSR FOLF EVSR EVLF CVLF EVTt EVTl EVST EVSTe];

if ci==0
    PP=repmat([s T],[N 1]);
       
    HHData=[id t weight PP q0 qLF qSR qST pS gt HHData Tag];

    OutFile=fullfile(OutDir,'observedpolicy.raw');    
elseif ci>0
    HHData=[mean(Inc.*weight) mean(HHData.*repmat(weight,[1 9])) ...
        mean(HHData.*repmat((weight./Inc),[1 9]))];
      
    filename =[ 'confidenceinterval', int2str(ci), '.raw'];
    
    OutFile=fullfile(OutDir,filename);
end
save(OutFile,'HHData','-ascii','-double','-tabs');    
    
    


