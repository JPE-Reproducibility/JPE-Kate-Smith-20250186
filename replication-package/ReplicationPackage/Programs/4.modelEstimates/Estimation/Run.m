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

%Estimate model
CoefFileName='startingvalues';
DataFileName='estimationdata';
OutputFileName='GMMcoefficients';
Estimate(CoefFileName,DataFileName,OutputFileName,InDir,OutDir,r,nZC,nRC,nZY,nRY,nZP)

%Check concavity and monotonicity
DataFileName='estimationdata';
Restrictions(DataFileName,InDir,OutDir,r,nZC,nRC,nZY,nRY,nZP)

%Prediction for hold sample
CoefFileName='GMMcoefficients';
DataFileName='holdoutdata';
OutputFileName='holdoutpredictions';
Holdout(CoefFileName,DataFileName,OutputFileName,InDir,OutDir,r,nZC,nRC,nZY,nRY,nZP)
DataFileName='insampledata';
OutputFileName='insamplepredictions';
Holdout(CoefFileName,DataFileName,OutputFileName,InDir,OutDir,r,nZC,nRC,nZY,nRY,nZP)

%Flypaper validation
CoefFileName='startingvalues';
DataFileName='flyvalid_estimationdata';
OutputFileName='Valdcoefficients';
Estimate(CoefFileName,DataFileName,OutputFileName,InDir,OutDir,r,nZC,nRC,nZY,nRY,nZP)
CoefFileName='Valdcoefficients';
DataFileName='flyvalid_holdoutdata1';
OutputFileName='flyvalidpredictions1';
Holdout(CoefFileName,DataFileName,OutputFileName,InDir,OutDir,r,nZC,nRC,nZY,nRY,nZP)
DataFileName='flyvalid_holdoutdata2';
OutputFileName='flyvalidpredictions2';
Holdout(CoefFileName,DataFileName,OutputFileName,InDir,OutDir,r,nZC,nRC,nZY,nRY,nZP)

%Prie responses for hold sample
DataFileName='priceeffectsdata';
Priceeffects(DataFileName,InDir,OutDir,r,nZC,nRC,nZY,nRY,nZP)

%Draw Engel curves
DataFileName='engelcurvesdata';
EngelCurves(DataFileName,InDir,OutDir,r,nZC,nRC,nZY,nRY,nZP)