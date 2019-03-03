function b=bezier(a,z,n)
% BEZIER Bezier curve
%   B = BEZIER(A) returns a 21x2 vector of x,y points along a Bezier
%   curve defined by vector of  control points A.
%
%   B = BEZIER(A,Z) returns a 21x2 vector of x,y points along a Bezier
%   curve defined by vector of control points A with weights Z.
%
%   B = BEZIER(A,Z,N) returns an Nx2 vector of x,y points along a Bezier
%   curve defined by vector of control points A with weights Z.
%
%   Example
%   =======
%   This will generate the FFD in Figure 3.7 from Sobester and 
%   Forrester (2014):
%
%   A = [1 10; 2 5; 7.7 3.9; 0 2];
%   Z = ones(4,1);
%   N = 41;
%   B = BEZIER(A,Z,N);
%   plot(B(:,1),B(:,2));
%   hold on
%   plot(A(:,1),A(:,2),'k--o')
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

if exist('z','var')~=1 || isempty(z)==1
    z=ones(length(a),1);
end
if exist('n','var')~=1 || isempty(n)==1
    n=21;
end
t=0:1/(n-1):1;
np=size(a,1)-1;
terms=zeros(np+1,size(a,2));
ratTerms=zeros(np+1,size(a,2));
b=zeros(n,size(a,2));
for i=0:n-1
    for j=0:np      
        terms(j+1,:)=a(j+1,:)*z(j+1)*nchoosek(np,j)*t(i+1)^j*(1-t(i+1))^(np-j);
        ratTerms(j+1,:) = z(j+1) * nchoosek(np,j)*t(i+1)^j*(1-t(i+1))^(np-j);
        b(i+1,:)=sum(terms,1)./sum(ratTerms,1);
    end
end
b(n,:)=a(end,:);