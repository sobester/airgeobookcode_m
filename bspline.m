function b=bspline(a,d,m)
% BSPLINE B-spline curve
%   B = BSPLINE(A) returns 21 x,y points for each (n+1)-d segment of a 
%   degree 2 B-spline defined by (n+1)x2 vector of control points A. B 
%   is formated as a 21x2x(n+1)-d matrix.
%
%   B = BSPLINE(A,D) returns 21 x,y points for each (n+1)-D segment of a 
%   degree D B-spline defined by (n+1)x2 vector of control points A.
%
%   B = BSPLINE(A,D,M) returns M x,y points for each (n+1)-D segment of a 
%   degree D B-spline defined by (n+1)x2 vector of control points A.
%
%   Example
%   =======
%   This will generate the FFD in Figure 3.19(a) from Sobester and 
%   Forrester (2014):
%
% a=[0 0
%     0 1
%     1 1
%     1 0
%     2 0
%     2.7 1
%     3 1
%     3 0];
% d=3;
% b=bspline(a,d);
% figure; hold on
% plot(a(:,1),a(:,2),'k-o')
% for i=1:length(a)-d;
%     plot(b(:,1,i),b(:,2,i),'k','LineWidth',2)
% end
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
if exist('m','var')~=1 || isempty(m)==1
    m=21;
end
t=0:1/(m-1):1;
s=length(a)-d;
b=zeros(m,2,s);
tVector=zeros(1,(d+1));
for j=0:s-1
    for i=0:m-1
        for k=0:1:d;
            tVector(k+1)=t(i+1)^(d-k);
        end
        b(i+1,:,j+1)=tVector*((1/factorial(d))*bsplinematrix(d))*a(j+1:j+d+1,:);
    end
end
end