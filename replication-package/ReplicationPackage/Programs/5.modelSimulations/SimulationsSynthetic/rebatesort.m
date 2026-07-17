function [ICB,IYB]=rebatesort(A0,Ai,B0,Bi,C0,Ci,D,x,ICE,ICB,IP,IYE,IYB,...
    p1,p2,r,T,Top)

[wb,~]=Marshallian(A0,Ai,B0,Bi,C0,Ci,D,x,ICB,IP,IYB,p1,p2,r);

[w,~]=Marshallian(A0,Ai,B0,Bi,C0,Ci,D,x,ICE,IP,IYE,p1,p2,r);

ICB(wb<=w,:)=ICE(wb<=w,:);
IYB(wb<=w,:)=IYE(wb<=w,:);

if isempty(T)==0
    indexB=max(ICB~=ICE,[],1)';
    indexY=max(IYB~=IYE,[],1)';

    ICB(wb>w,indexB)=ICB(wb>w,indexB)*(T/Top);
    IYB(wb>w,indexY)=IYB(wb>w,indexY)*(T/Top);
end