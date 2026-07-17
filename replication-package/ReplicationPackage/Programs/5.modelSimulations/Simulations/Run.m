clear
close all

working=".../ReplicationPackage/";

InDir  = fullfile(working, 'dataOutput', 'dataAnalysis');
OutDir = fullfile(working, 'dataOutput', 'dataAnalysis');

%Parameters dimensions
r=2;              %Order of Engel curve
nZC=59;           %No. of intercept preference shifters
nRC=10;           %No. of intercept rebate shifters
nZY=10;           %No. of Engel curve preference shifters
nRY=0;            %No. of Engel curve rebate shifters
nZP=10;           %No. of price preference shifters

%Observed subsidy rate
s=0.39;

Mat=fullfile(OutDir,'GMMcoefficients.mat');
load(Mat,'thetahat');

%Observed policy
DataFileName='observedpolicydata';
ci=0;
Observedpolicy(DataFileName,InDir,OutDir,thetahat,r,nZC,nRC,nZY,nRY,nZP,s,ci)

%Counterfactual policy
DataFileName='simulationdata';
OutFileName='counterfactualpolicy.raw';
sensitivity=0;
adjust=[];
maxs=0.52;
Counterfactualpolicy(DataFileName,OutFileName,InDir,OutDir,r,nZC,nRC,nZY,nRY,nZP,s,maxs,sensitivity,adjust)

%Compute confidence bands
DataFileName='observedpolicydata';
REPS=100;
[thetehatdraws]=drawcoefficients(OutDir,REPS);
for ci=1:REPS
    Observedpolicy(DataFileName,InDir,OutDir,thetehatdraws(ci,:)', ...
        r,nZC,nRC,nZY,nRY,nZP,s,ci)
end

