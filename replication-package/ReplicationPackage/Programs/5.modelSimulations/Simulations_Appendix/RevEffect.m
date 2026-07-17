function RevEffect(DataFileName,SPFile,OSFile,InDir,OutDir,r,nZC,nRC,nZY,nRY,nZP,s)

p=append(SPFile,'.raw');
DataFile=fullfile(InDir,p);
D=load(DataFile);
psi=D(1);
cap=D(2);

p=append(OSFile,'.raw');
DataFile=fullfile(InDir,p);
D=load(DataFile); 
osSTe=D(1);
osSTy=D(2);
osSTs=D(3);
osSTys=D(4);

% cap=7.74536;
% psi=0.8395;

Mat=fullfile(OutDir,'GMMcoefficients.mat');
load(Mat,'thetahat');

cf=1;
[id,~,xS,p,Z,R,IP,ZY,RY,pNS,weight,T,F,Fcf,v]=dataprepare(InDir,DataFileName,...
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
%Construct weights and incomee
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

unique_ids = unique(id); % Get unique IDs
hhw = zeros(size(unique_ids)); % For household weights
ww = zeros(size(id)); % For within-household weights
inc = zeros(size(unique_ids)); % Preallocate for inc

for i = 1:length(unique_ids)
    individual_id = unique_ids(i);
    hhw(i) = sum(weight(id == individual_id)); % Sum weight for each household
end

for i = 1:length(unique_ids)
    individual_id = unique_ids(i);
    ww(id == individual_id) = weight(id == individual_id) / hhw(i); 
end

hhw=hhw./sum(hhw);  %Normalize household weights (sum to 1)

for i = 1:length(unique_ids)
    individual_id = unique_ids(i);
    ww_individual = ww(id == individual_id); % Extract weights for the individual
    inc(i) = sum(10 * (1 ./ v(id == individual_id,2) .* ww_individual)); % Compute inc for each individual
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%No policy intervention
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pe=pLF;
x=xLF;
IC=ICE;
IY=IYE;

[qLF,~]=Classical(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,xNS,pNS,pe,pn,r);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Subsidy and rebate 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pe=pS;
x=xS;
IC=ICB;
IY=IYB;

[qSR,EVSR,~,~]=Behavioural(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,xNS,ICE,IYE,...
    pNS,pe,pn,r);

%Cost
R_bar=s*mean(qSR.*exp(pLF).*weight)+T+ext*mean((qSR-qLF).*weight);

%Welfare
LSR = zeros(size(unique_ids)); 

% Calculate L and inc for each individual
for i = 1:length(unique_ids)
    individual_id = unique_ids(i);
    ww_individual = ww(id == individual_id); % Extract weights for the individual
    LSR(i) = sum(EVSR(id == individual_id) .* ww_individual); % Compute L for each individual
end

lossSR=(LSR./inc);
lossSR(lossSR>cap)=cap;

%Welfare
WSR=(1/psi).*(exp(psi*lossSR)-1);
WSR=(1/psi).*log(psi*sum(hhw.*WSR)+1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Revenue-equivalent pure transfer schemes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pe=pLF;
x=xLF;
IC=ICE;
IY=IYE;
sop=0;

[tSR,Rev,~,~]=equivrebate(A0,Ai,B0,Bi,C0,Ci,D,xLF,ICB,IP,IYB,ICE,IYE,...
   pe,pn,T,sop,R_bar,r,weight,ext,qLF);    
if abs((Rev-R_bar)/R_bar)>1e-3
    keyboard
end 

%Transfer
vr=v(:,1);
[Te,~,~,~,Rv]=equivpubliccost(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,pe,pn,...
     tSR,sop,R_bar,r,weight,ext,qLF,vr);
if max(abs((Rv-R_bar)/Rv))>1e-3
    keyboard
end  

T0=Te;
F=@(T0)Wdiff(T0,A0,Ai,B0,Bi,C0,Ci,D,xLF,IC,IP,IY,xNS,pNS,pe,pn,r,vr,...
        id,unique_ids,ww,hhw,inc,cap,psi,WSR);

options = optimoptions('fsolve', 'Display', 'iter'); 
Trv = fsolve(F, T0, options);

xc=log(exp(xLF)+Trv);
[w,~]=Marshallian(A0,Ai,B0,Bi,C0,Ci,D,xc,IC,IP,IY,pe,pn,r);

q=w.*exp(xc)./exp(pe);
RT=sop*mean(exp(pLF).*q.*weight)+Trv*mean(vr.*weight)...
    +ext*mean((q-qLF).*weight);
    

%Income based transfer
vr=v(:,2);
[Ty,~,~,~,Rv]=equivpubliccost(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,pe,pn,...
     Te,sop,R_bar,r,weight,ext,qLF,vr);
if max(abs((Rv-R_bar)/Rv))>1e-3
   keyboard
end    
    
T0=Ty;
F=@(T0)Wdiff(T0,A0,Ai,B0,Bi,C0,Ci,D,xLF,IC,IP,IY,xNS,pNS,pe,pn,r,vr,...
        id,unique_ids,ww,hhw,inc,cap,psi,WSR);

options = optimoptions('fsolve', 'Display', 'iter'); 
Tyrev = fsolve(F, T0, options);

xc=log(exp(xLF)+vr.*Tyrev);
[w,~]=Marshallian(A0,Ai,B0,Bi,C0,Ci,D,xc,IC,IP,IY,pe,pn,r);

q=w.*exp(xc)./exp(pe);
RTy=sop*mean(exp(pLF).*q.*weight)+Tyrev*mean(vr.*weight)...
    +ext*mean((q-qLF).*weight);

%Past spending based transfer
vr=v(:,3);    
[Ts,~,~,~,Rv]=equivpubliccost(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,pe,pn,...
   Te,sop,R_bar,r,weight,ext,qLF,vr);
if max(abs((Rv-R_bar)/Rv))>1e-3
    keyboard
end 

T0=Ts;
F=@(T0)Wdiff(T0,A0,Ai,B0,Bi,C0,Ci,D,xLF,IC,IP,IY,xNS,pNS,pe,pn,r,vr,...
        id,unique_ids,ww,hhw,inc,cap,psi,WSR);

options = optimoptions('fsolve', 'Display', 'iter');
Tsrev = fsolve(F, T0, options);

xc=log(exp(xLF)+vr.*Tsrev);
[w,~]=Marshallian(A0,Ai,B0,Bi,C0,Ci,D,xc,IC,IP,IY,pe,pn,r);

q=w.*exp(xc)./exp(pe);
RTs=sop*mean(exp(pLF).*q.*weight)+Tsrev*mean(vr.*weight)...
    +ext*mean((q-qLF).*weight);

%Past spending based transfer over income
vr=v(:,4);
[Tys,~,~,~,Rv]=equivpubliccost(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,pe,pn,...
    Te,sop,R_bar,r,weight,ext,qLF,vr);
if max(abs((Rv-R_bar)/Rv))>1e-3
    keyboard
end  

T0=Tys;
F=@(T0)Wdiff(T0,A0,Ai,B0,Bi,C0,Ci,D,xLF,IC,IP,IY,xNS,pNS,pe,pn,r,vr,...
        id,unique_ids,ww,hhw,inc,cap,psi,WSR);

options = optimoptions('fsolve', 'Display', 'iter');
Tysrev = fsolve(F, T0, options);

xc=log(exp(xLF)+vr.*Tysrev);
[w,~]=Marshallian(A0,Ai,B0,Bi,C0,Ci,D,xc,IC,IP,IY,pe,pn,r);

q=w.*exp(xc)./exp(pe);
RTys=sop*mean(exp(pLF).*q.*weight)+Tysrev*mean(vr.*weight)...
    +ext*mean((q-qLF).*weight);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Revenue-equivalent transfer and subsidy schemes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sop=osSTe;
pe=log(exp(pLF)*(1-sop));
x=xLF;
IC=ICE;
IY=IYE;

[tSR,Rev,~,~]=equivrebate(A0,Ai,B0,Bi,C0,Ci,D,xLF,ICB,IP,IYB,ICE,IYE,...
   pe,pn,T,sop,R_bar,r,weight,ext,qLF);    
if abs((Rev-R_bar)/R_bar)>1e-3
    keyboard
end 

%Transfer
vr=v(:,1);
[Te,~,~,~,Rv]=equivpubliccost(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,pe,pn,...
     tSR,sop,R_bar,r,weight,ext,qLF,vr);
if max(abs((Rv-R_bar)/Rv))>1e-3
    keyboard
end  

T0=Te;
F=@(T0)Wdiff(T0,A0,Ai,B0,Bi,C0,Ci,D,xLF,IC,IP,IY,xNS,pNS,pe,pn,r,vr,...
        id,unique_ids,ww,hhw,inc,cap,psi,WSR);

options = optimoptions('fsolve', 'Display', 'iter'); 
STrv = fsolve(F, T0, options);

xc=log(exp(xLF)+STrv);
[w,~]=Marshallian(A0,Ai,B0,Bi,C0,Ci,D,xc,IC,IP,IY,pe,pn,r);

q=w.*exp(xc)./exp(pe);
RST=sop*mean(exp(pLF).*q.*weight)+STrv*mean(vr.*weight)...
    +ext*mean((q-qLF).*weight);
    

%Income based transfer
sop=osSTy;
pe=log(exp(pLF)*(1-sop));

vr=v(:,2);
[Ty,~,~,~,Rv]=equivpubliccost(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,pe,pn,...
     Te,sop,R_bar,r,weight,ext,qLF,vr);
if max(abs((Rv-R_bar)/Rv))>1e-3
   keyboard
end    
    
T0=Ty;
F= @(T0) Wdiff(T0,A0,Ai,B0,Bi,C0,Ci,D,xLF,IC,IP,IY,xNS,pNS,pe,pn,r,vr,...
        id,unique_ids,ww,hhw,inc,cap,psi,WSR);

options = optimoptions('fsolve', 'Display', 'iter'); 
STyrev = fsolve(F, T0, options);

xc=log(exp(xLF)+vr.*STyrev);
[w,~]=Marshallian(A0,Ai,B0,Bi,C0,Ci,D,xc,IC,IP,IY,pe,pn,r);

q=w.*exp(xc)./exp(pe);
RSTy=sop*mean(exp(pLF).*q.*weight)+STyrev*mean(vr.*weight)...
    +ext*mean((q-qLF).*weight);

%Past spending based transfer
sop=osSTs;
pe=log(exp(pLF)*(1-sop));

vr=v(:,3);    
[Ts,~,~,~,Rv]=equivpubliccost(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,pe,pn,...
   Te,sop,R_bar,r,weight,ext,qLF,vr);
if max(abs((Rv-R_bar)/Rv))>1e-3
    keyboard
end 

T0=Ts;
F= @(T0)Wdiff(T0,A0,Ai,B0,Bi,C0,Ci,D,xLF,IC,IP,IY,xNS,pNS,pe,pn,r,vr,...
        id,unique_ids,ww,hhw,inc,cap,psi,WSR);

options = optimoptions('fsolve', 'Display', 'iter');
STsrev = fsolve(F, T0, options);

xc=log(exp(xLF)+vr.*STsrev);
[w,~]=Marshallian(A0,Ai,B0,Bi,C0,Ci,D,xc,IC,IP,IY,pe,pn,r);

q=w.*exp(xc)./exp(pe);
RSTs=sop*mean(exp(pLF).*q.*weight)+STsrev*mean(vr.*weight)...
    +ext*mean((q-qLF).*weight);

%Past spending based transfer over income
sop=osSTys;
pe=log(exp(pLF)*(1-sop));

vr=v(:,4);
[Tys,~,~,~,Rv]=equivpubliccost(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,pe,pn,...
    Te,sop,R_bar,r,weight,ext,qLF,vr);
if max(abs((Rv-R_bar)/Rv))>1e-3
    keyboard
end  

T0=Tys;
F= @(T0) Wdiff(T0,A0,Ai,B0,Bi,C0,Ci,D,xLF,IC,IP,IY,xNS,pNS,pe,pn,r,vr,...
        id,unique_ids,ww,hhw,inc,cap,psi,WSR);

options = optimoptions('fsolve', 'Display', 'iter');
STysrev = fsolve(F, T0, options);

xc=log(exp(xLF)+vr.*STysrev);
[w,~]=Marshallian(A0,Ai,B0,Bi,C0,Ci,D,xc,IC,IP,IY,pe,pn,r);

q=w.*exp(xc)./exp(pe);
RSTys=sop*mean(exp(pLF).*q.*weight)+STysrev*mean(vr.*weight)...
    +ext*mean((q-qLF).*weight);

OutData=[R_bar RT RTy RTs RTys RST RSTy RSTs RSTys];

OutFile=fullfile(OutDir,'counterfactualpolicy_appendix.raw');

save(OutFile,'OutData','-ascii','-double','-tabs');



