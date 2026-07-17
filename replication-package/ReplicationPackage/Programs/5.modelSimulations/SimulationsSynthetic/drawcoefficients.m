function [thetehatdraws]=drawcoefficients(OutDir,REPS)

OutMat=fullfile(OutDir,'GMMcoefficients.mat');
load(OutMat,'thetahat','Vr');

rng(146); %Set seed of random number generator
p=size(thetahat,1); %Number of estimated parameters
thetehatdraws=repmat(thetahat',[REPS 1])+randn(REPS,p)*chol(Vr); %Draws 

