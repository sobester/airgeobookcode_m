function [N,K]=nurbs(a,d,z,kn,n)
% NURBS NURBS curve
%   N = NURBS(A) returns 21 x,y points for of a  degree 2 nurbs defined by 
%   (n+1)x2 vector of control points A, with uniform weights and knot.
%   vector
%
%   N = NURBS(A,D) returns 21 x,y points for of a  degree D nurbs defined 
%   by (n+1)x2 vector of control points A, with uniform weights and knot
%   vector.
%
%   N = NURBS(A,D,Z) returns 21 x,y points for of a  degree D nurbs defined
%   by (n+1)x2 vector of control points A, with control point weights
%   defined by (n+1)x1 vector Z, and a uniform knot vector.
%
%   N = NURBS(A,D,Z,KN) returns 21 x,y points for of a  degree D nurbs 
%   defined by (n+1)x2 vector of control points A, with control point 
%   weights defined by (n+1)x1 vector Z, and knot vector KN.
%
%   N = NURBS(A,D,Z,KN,N) returns N x,y points for of a  degree D nurbs 
%   defined by (n+1)x2 vector of control points A, with control point 
%   weights defined by (n+1)x1 vector Z, and knot vector KN.
%
%   Example
%   =======
%   This will generate an aerofoil similar to Figure 3.17 from Sobester and 
%   Forrester (2014):
%
% a=[1.0	0
%     0.5	0.08
%     0.0	-0.05
%     0.0	0.025
%     0.0	0.10
%     0.4	0.20
%     1.0	0.0];
% d=3;
% z=ones(length(a),1);
% kn=[0 0 0 0 1 1 1 2 2 2 2];
% n=nurbs(a,d,z,kn);
% figure
% hold on
% plot(n(:,1),n(:,2),'k','LineWidth',2)
% plot(a(:,1),a(:,2),'k-o')
% 
% EXAMPLE 2 (added flexibility to lower surface of aerofoil by reducing 
% degree and adding acontrol point (similar to Figure 3.17)):
%
% a=[1.0	0.0
%     0.8	0.05
%     0.5	0.00
%     0     -0.05
%     0     0.025];
% d=2;
% z=ones(length(a));
% kn=[0 0 0 1 2 3 3 3];
% [n,k]=nurbs(a,d,[],kn);
% plot(n(:,1),n(:,2),'k--','LineWidth',2)
% plot(a(:,1),a(:,2),'k--*')
% plot(k(:,1),k(:,2),'r*')
%
% -------------------------------------------------------------------------
% Aircraft Geometry Toolbox v0.1.0, Andras Sobester 2014.
%
% Sobester, A, Forrester, A I J, "Aircraft Aerodynamic Design - Geometry 
% and Optimization", Wiley, 2014.
% -------------------------------------------------------------------------
%
% Copyright 2014 A I J Forrester
%
% This program is free software: you can redistribute it and/or modify  it
% under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any
% later version.
% 
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser
% General Public License for more details.
% 
% You should have received a copy of the GNU General Public License and GNU
% Lesser General Public License along with this program. If not, see
% <http://www.gnu.org/licenses/>.
if exist('d','var')~=1 || isempty(d)==1
    d=2;
end
if exist('z','var')~=1 || isempty(z)==1
    z=ones(length(a),1);
end
if exist('kn','var')~=1 || isempty(kn)==1
    kn=0:length(a)+d;
end
if exist('n','var')~=1 || isempty(n)==1
    n=21;
end

order=d+1;
startPoint=kn(order);
endPoint=kn(end-order+1);
t=startPoint:(endPoint-startPoint)/(n-1):endPoint;

for j=1:n
    for k=1:order
        for i=1:length(kn)-(k)         
            if k==1
                if (t(j)>=kn(i) && t(j)<kn(i+1)) || (t(j)==kn(i+1) && t(j)==t(end))
                    B(i,k,j)=1;
                else
                    B(i,k,j)=0;
                end
            else
                if kn(i+k-1)==kn(i) && kn(i+k)==kn(i+1)
                    B(i,k,j)=0;
                elseif kn(i+k)==kn(i+1)
                    B(i,k,j)=((t(j)-kn(i))/(kn(i+k-1)-kn(i)))*B(i,k-1,j);
                elseif  kn(i+k-1)==kn(i)
                    B(i,k,j)=((kn(i+k)-t(j))/(kn(i+k)-kn(i+1)))*B(i+1,k-1,j);
                else
                    B(i,k,j)=((t(j)-kn(i))/(kn(i+k-1)-kn(i)))*B(i,k-1,j)+((kn(i+k)-t(j))/(kn(i+k)-kn(i+1)))*B(i+1,k-1,j);
                end
            end
        end
    end
    for i=1:length(a)
        pTerm(i,:,j)=a(i,:).*z(i).*B(i,order,j);
        weightTerm(i,j)=z(i)*B(i,order,j);
    end
    N(j,:)=sum(pTerm(:,:,j))/sum(weightTerm(:,j));   
end
for i=order:length(kn)-(order-1)
    [a,b]=min(abs(t-kn(i)));
    K(i-order+1,:)=N(b,:);
end

