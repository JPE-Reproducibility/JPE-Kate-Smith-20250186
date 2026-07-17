function Counterfactualpolicy(DataFileName,OutFileName,InDir,OutDir,r,nZC,nRC,nZY,nRY,nZP,s,...
    maxs,sensitivity,adjust)

Mat=fullfile(OutDir,'GMMcoefficients.mat');
load(Mat,'thetahat');

cf=1;
[id,t,xS,p,Z,R,IP,ZY,RY,pNS,weight,T,F,Fcf,v]=dataprepare(InDir,DataFileName,...
    nZC,nRC,nZY,nRY,nZP,cf);

[A0,Ai,B0,Bi,C0,Ci,D]=parammap(thetahat,r,nZC,nRC,nZY,nRY,nZP);
 
T=mean(weight.*T);

ICB=[Z R];                 %Constant shifters (rebate included)
ICE=[Z zeros(size(R))];    %Constant shifters (rebate excluded)
IYB=[ZY RY];               %Y shifters (rebate included)
IYE=[ZY zeros(size(RY))];  %Y shifters (rebate excluded)

xLF=log(exp(xS)-T);         %Expenditure (rebate excluded)
xNS=log(exp(xLF)+Fcf-F);    %Expenditure (no shock)

pS=p(:,1);                  %Shocked price (obs policy)
pLF=log(exp(p(:,1))/(1-s)); %Shocked price (no subsidy)

pn=p(:,2);                  %Non-durable price

N=size(xS,1);

ext=0.059*1.24*mean(exp(pS));     %Externality per pound

[ICB,IYB]=rebatesort(A0,Ai,B0,Bi,C0,Ci,D,xS,ICE,ICB,IP,IYE,IYB,pS,pn,r,[],[]);

if sensitivity==1
    [B0,Bi,ICB,ICE]=sensitivityanalysis(A0,Ai,B0,Bi,C0,Ci,D,xNS,ICB,ICE,...
        IP,IYE,pS,pNS,pn,r,weight,adjust);

    pe=pNS;
    x=xNS;
    IC=ICE;
    IY=IYE;
    [w0,~]=Marshallian(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,pe,pn,r);
    q0=w0.*exp(x)./exp(pe);  

    FOSR=q0.*(exp(pS)-exp(pNS))+(F-Fcf)-T;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Subsidy and rebate 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pe=pS;
x=xS;
IC=ICB;
IY=IYB;

[w,~]=Marshallian(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,pe,pn,r);
q=w.*exp(xS)./exp(pS);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%No policy intervention
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pe=pLF;
x=xLF;
IC=ICE;
IY=IYE;

[qLF,~]=Classical(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,xNS,pNS,pe,pn,r);

%Resources used under observed policy
%(used as resource constraint)
R_bar=(s/(1-s))*mean(w.*exp(xS).*weight)+T+ext*mean((q-qLF).*weight);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Transfers ("first best")
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pe=pLF;
x=xLF;
IC=ICE;
IY=IYE;

[tFB,EVFB,Rev]=firstbest(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,pNS,xNS,pe,pn,...
    R_bar,r,weight,v(:,2));   
if abs((Rev-R_bar)/R_bar)>1e-3
    keyboard
end   

%Vary subsidy from 0 to maximimum amount
maxss=maxs+0.005;
range=[(0:0.01:maxs) maxss];

Data=zeros(size(range,2),N,19);
i=1;
for sop=range

    %Price at current subsidy level
    pC=log(exp(pLF)*(1-sop));  
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Subsidy and rebate 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
     
    pe=pC;
    [tSR,Rev,ICBc,IYBc]=equivrebate(A0,Ai,B0,Bi,C0,Ci,D,xLF,ICB,IP,IYB,ICE,IYE,...
        pe,pn,T,sop,R_bar,r,weight,ext,qLF);    
    
    if abs((Rev-R_bar)/R_bar)>1e-3&&top>=0
        keyboard
    end    
    
    pe=pC;
    x=log(exp(xLF)+tSR);
    IC=ICBc;
    IY=IYBc;   
    
    [qSR,EVSR,~,Tag]=Behavioural(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,xNS,ICE,IYE,...
        pNS,pe,pn,r);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Subsidy and transfer (fixed)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    pe=pC;
    x=log(exp(xLF)+tSR);
    IC=ICE;
    IY=IYE;

    [qST,EVST]=Classical(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,xNS,pNS,pe,pn,r);
    EVSR(Tag==1)=EVST(Tag==1);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Subsidy and transfer (budg bal)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    pe=pC;
    x=xLF;
    IC=ICE;
    IY=IYE;
    vr=v(:,1);

    [Te,~,~,~,Rv]=equivpubliccost(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,pe,pn,...
        tSR,sop,R_bar,r,weight,ext,qLF,vr);
    if max(abs((Rv-R_bar)/Rv))>1e-3
        keyboard
    end  

    x=log(exp(x)+Te);

    [qSTe,EVSTe]=Classical(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,xNS,pNS,pe,pn,r);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Subsidy and income specific transfers
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
    pe=pC;
    x=xLF;
    IC=ICE;
    IY=IYE;
    vr=v(:,2);

    [Ty,~,~,~,Rv]=equivpubliccost(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,pe,pn,...
        Te,sop,R_bar,r,weight,ext,qLF,vr);
    if max(abs((Rv-R_bar)/Rv))>1e-3
        keyboard
    end      
    
    x=log(exp(x)+vr.*Ty);
    [qSTy,EVSTy]=Classical(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,xNS,pNS,pe,pn,r);   
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Subsidy and pre spending specific transfers
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    pe=pC;
    x=xLF;
    IC=ICE;
    IY=IYE;
    vr=v(:,3);    

    [Ts,~,~,~,Rv]=equivpubliccost(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,pe,pn,...
        Te,sop,R_bar,r,weight,ext,qLF,vr);
    if max(abs((Rv-R_bar)/Rv))>1e-3
        keyboard
    end      
    
    x=log(exp(x)+vr.*Ts);
    [qSTs,EVSTs]=Classical(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,xNS,pNS,pe,pn,r);     
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Subsidy and pre spending/income specific transfers
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    pe=pC;
    x=xLF;
    IC=ICE;
    IY=IYE;
    vr=v(:,4);    

    [Tys,~,~,~,Rv]=equivpubliccost(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,pe,pn,...
        Te,sop,R_bar,r,weight,ext,qLF,vr);
    if max(abs((Rv-R_bar)/Rv))>1e-3
        keyboard
    end      
    
    x=log(exp(x)+vr.*Tys);
    [qSTys,EVSTys]=Classical(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,xNS,pNS,pe,pn,r); 

    Data(i,:,1)=sop;
    Data(i,:,2)=tSR;
    Data(i,:,3)=Te;
    Data(i,:,4)=Ty.*v(:,2);  
    Data(i,:,5)=Ts.*v(:,3);  
    Data(i,:,6)=Tys.*v(:,4); 
    Data(i,:,7)=qSR;
    Data(i,:,8)=qST;
    Data(i,:,9)=qSTe;
    Data(i,:,10)=qSTy;
    Data(i,:,11)=qSTs;
    Data(i,:,12)=qSTys;    
    Data(i,:,13)=EVSR;
    Data(i,:,14)=EVST;
    Data(i,:,15)=EVSTe;
    Data(i,:,16)=EVSTy;
    Data(i,:,17)=EVSTs;
    Data(i,:,18)=EVSTys;
    Data(i,:,19)=Tag;    
    
    i=i+1;      
end

[ns,N,nv]=size(Data);

if sensitivity==0
    HHData=kron([id t pLF tFB EVFB],ones(ns,1));
elseif sensitivity==1
    HHData=kron([id t pLF tFB EVFB FOSR],ones(ns,1));
end
Data=reshape(Data,[N*ns nv]);
OutData=[HHData Data];

OutFile=fullfile(OutDir,OutFileName);

save(OutFile,'OutData','-ascii','-double','-tabs');