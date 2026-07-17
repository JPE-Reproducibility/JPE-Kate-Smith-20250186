clear
close all

addpath(fullfile(fileparts(pwd), 'Simulations'));

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
DataFileName='simulationdata';

%Raise price sensitivity
OutFileName='sensitivity1.raw';
sensitivity=1;
maxs=0.52;
adjust=0.81;
Counterfactualpolicy(DataFileName,OutFileName,InDir,OutDir,r,nZC,nRC,nZY,nRY,nZP,s,maxs,sensitivity,adjust)

%Reduce price sensitivity
OutFileName='sensitivity2.raw';
sensitivity=1;
adjust=1.19;
maxs=0.52;
Counterfactualpolicy(DataFileName,OutFileName,InDir,OutDir,r,nZC,nRC,nZY,nRY,nZP,s,maxs,sensitivity,adjust)

%Income adjustments
DataFileName='simulationdata';
OutFileName='counterfactualpolicy_incadj.raw';
Counterfactualpolicyincadj(DataFileName,OutFileName,InDir,OutDir,r,nZC,nRC,nZY,nRY,nZP,s)

%Minimize public resources used
DataFileName='simulationdata';
SPFile='psi';
OSFile='opts';
RevEffect(DataFileName,SPFile,OSFile,InDir,OutDir,r,nZC,nRC,nZY,nRY,nZP,s)
