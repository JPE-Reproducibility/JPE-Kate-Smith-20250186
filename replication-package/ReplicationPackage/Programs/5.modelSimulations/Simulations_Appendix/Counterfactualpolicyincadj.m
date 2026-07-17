function Counterfactualpolicyincadj(DataFileName,OutFileName,InDir,OutDir,r,nZC,nRC,nZY,nRY,nZP,s)

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
range=[(0:0.01:0.52) 0.525];

Data=zeros(size(range,2),N,13);
i=1;
for sop=range
disp(sop);
    %Price at current subsidy level
    pC=log(exp(pLF)*(1-sop));  
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Subsidy and transfer (budg bal)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    pe=pC;
    x=xLF;
    IC=ICE;
    IY=IYE;
    vr=v(:,1);

    [Te,incT,Rv]=equivpubliccostincadj(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,pe,pn,...
        T,sop,R_bar,r,weight,ext,qLF,vr,pNS,xNS,v(:,2),v(:,5));
    if max(abs((Rv-R_bar)/Rv))>1e-3
        keyboard
    end  

    x=log(exp(x)+Te+incT);

    [qSTe,EVSTe]=Classical(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,xNS,pNS,pe,pn,r);
  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Subsidy and pre spending specific transfers
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    pe=pC;
    x=xLF;
    IC=ICE;
    IY=IYE;
    vr=v(:,3);    

    [Ts,incT,Rv]=equivpubliccostincadj(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,pe,pn,...
        Te,sop,R_bar,r,weight,ext,qLF,vr,pNS,xNS,v(:,2),v(:,5));
    if max(abs((Rv-R_bar)/Rv))>1e-3
        keyboard
    end      
    
    x=log(exp(x)+vr.*Ts+incT);
    [qSTs,EVSTs]=Classical(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,xNS,pNS,pe,pn,r);     
    
   
    Data(i,:,1)=sop;
    Data(i,:,2)=Te;
    Data(i,:,3)=Ts.*v(:,3);  
    Data(i,:,4)=qSTe;
    Data(i,:,5)=qSTs;
    Data(i,:,6)=EVSTe;
    Data(i,:,7)=EVSTs;
    
    i=i+1;      
end

[ns,N,nv]=size(Data);
HHData=kron([id t pLF tFB EVFB],ones(ns,1));
Data=reshape(Data,[N*ns nv]);

OutData=[HHData Data];

OutFile=fullfile(OutDir,OutFileName);

save(OutFile,'OutData','-ascii','-double','-tabs');