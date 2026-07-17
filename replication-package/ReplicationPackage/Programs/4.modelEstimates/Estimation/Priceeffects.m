function Priceeffects(DataFileName,InDir,OutDir,r,nZC,nRC,nZY,nRY,nZP)

Mat=fullfile(OutDir,'GMMcoefficients.mat');
load(Mat,'thetahat');

est=2;
[id,t,x,p,IC,IP,IY,~,~,pNS]=dataprepareestimate(InDir,DataFileName,...
     r,nZC,nRC,nZY,nRY,nZP,est);

[A0,Ai,B0,Bi,C0,Ci,D]=parammap(thetahat,r,nZC,nRC,nZY,nRY,nZP);

pS=p(:,1);
pc=p(:,2);

%Demands at observed prices
pe=pS;
[wS,yS]=Marshallian(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,pe,pc,r);
qS=wS.*exp(x)./exp(pe);

[wH,~,~]=Hicksian(A0,Ai,B0,Bi,C0,Ci,D,yS,IC,IP,IY,pe,pc,r);
if max(abs(wS-wH))>1e-3 
    keyboard
end    

%Demands at counferfactual prices
pe=pNS;
[wNS,~]=Marshallian(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,pe,pc,r);
qNS=wNS.*exp(x)./exp(pe);

HHData=[id t pS pNS x qS qNS];

OutFile=fullfile(OutDir,'pricepredictions.raw');
    
save(OutFile,'HHData','-ascii','-double','-tabs');
