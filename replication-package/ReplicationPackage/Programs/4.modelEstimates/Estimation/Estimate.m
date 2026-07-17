function Estimate(CoefFileName,DataFileName,OutputFileName,InDir,OutDir,r,nZC,nRC,nZY,nRY,nZP)

p=append(OutputFileName,'.raw');
OutFile=fullfile(OutDir,p);
p=append(OutputFileName,'.mat');
OutMat=fullfile(OutDir,p);

p=append(CoefFileName,'.raw');
CoefFile=fullfile(InDir,p);
theta0=load(CoefFile);

est=1;
[hh,~,x,p,IC,IP,IY,w,Z,~]=dataprepareestimate(InDir,DataFileName,...
    r,nZC,nRC,nZY,nRY,nZP,est);

options = optimoptions('fmincon','display','iter', 'GradObj', 'on', 'FiniteDifferenceType', 'central'); 

objfun=@(theta0)GMM(theta0,x,p,IC,IP,IY,w,Z,r,nZC,nRC,nZY,nRY,nZP);

%Stops optimizer straying to crazy values
lb=theta0-0.1*abs(theta0);
ub=theta0+0.1*abs(theta0);

[thetahat,fval,exitflag]=fmincon(objfun,theta0,[],[],[],[],lb,ub,[],options);

if thetahat<theta0-0.099*abs(theta0)
    disp('Lower bound binds');
    keyboard
end
if thetahat>theta0+0.099*abs(theta0)
    disp('Upper bound binds');
    keyboard
end

[Vr,se]=standarderrors(thetahat,hh,x,p,IC,IP,IY,w,Z,r,nZC,nRC,nZY,nRY,nZP);

% Display results
disp('Estimated Parameters:');
disp(thetahat);
disp('Standard Errors:');
disp(se);

Data=[thetahat se];
save(OutFile,'Data','-ascii','-double','-tabs');
save(OutMat,'thetahat','se','Vr');

