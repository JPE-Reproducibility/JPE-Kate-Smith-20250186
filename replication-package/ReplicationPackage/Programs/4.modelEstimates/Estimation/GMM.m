function [g,dg]=GMM(theta,x,p,IC,IP,IY,w,Z,r,nZC,nRC,nZY,nRY,nZP)

g=GMMobj(theta,x,p,IC,IP,IY,w,Z,r,nZC,nRC,nZY,nRY,nZP);

% Gradient (using finite differences)
if nargout > 1
    N=length(w);
    epsilon = 1e-8;
    dg = zeros(size(theta));
    for i = 1:length(theta)
       theta1 = theta;
       theta2 = theta;
       theta1(i) = theta1(i) + epsilon;
           
       theta2(i) = theta2(i) - epsilon;
           
       obj1 = GMMobj(theta1,x,p,IC,IP,IY,w,Z,r,nZC,nRC,nZY,nRY,nZP);
       obj2 = GMMobj(theta2,x,p,IC,IP,IY,w,Z,r,nZC,nRC,nZY,nRY,nZP);
            
       dg(i) = (1/N)*(obj1 - obj2) / (2 * epsilon);
    end
end
