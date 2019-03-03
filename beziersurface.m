function B=beziersurface(A,N)
% BEZIERSURFACE Bezier surface
%   B = BEZIERSURFACE(A) returns a 21x21x3 matrix of points on a Bezier 
%   surface defined by control points A. B(:,:,1) are the x-components,
%   B(:,:,2) the y-components, and B(:,:,3) the corresponding z-components 
%   of the surface. This structure of output is compatible with Matlab
%   graphics functions such as mesh and surf. The input A is similarly
%   structured
%
%   B = BEZIERSURFACE(A,N) returns an NxNx3 matrix of points on a Bezier 
%   surface defined by control points A.
%
%   Example
%   =======
%   This will generate Figure 4.5 from Sobester and Forrester (2014):
%
% A(:,:,1)=[0 0.5 1
%     0 0.5 1
%     0 0.5 1
%     0 0.5 1];
% A(:,:,2)=[0 0 0
%     0.5 0.5 0.5
%     1 1 1
%     1.5 1.5 1.5];
% A(:,:,3)=[0 1 0
%     -1 0 -1
%     0 1 0
%     -1 0 0.5];
% B=beziersurface(A);
% m=mesh(B(:,:,1),B(:,:,2),B(:,:,3));
% set(m,'FaceAlpha',0,'EdgeColor',[0 0 0]);
% axis square
% axis off
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
% Lesser General Public License along with this program. If no

if exist('N','var')~=1 || isempty(N)==1
    N=21;
end

u=0:1/(N-1):1;
t=0:1/(N-1):1;
n=size(A,2)-1;
m=size(A,1)-1;
if size(A,3)<4;
    A(:,:,4)=ones(m+1,n+1);
end
f=zeros(m+1,n+1);
g=zeros(m+1,n+1);
term=zeros(m+1,n+1,3);
B=zeros(m+1,n+1,3);
for l=0:N-1
for k=0:N-1
    for j=0:n
        for i=0:m
        f(i+1,j+1)=nchoosek(m,i)*u(l+1)^i*(1-u(l+1))^(m-i);
        g(i+1,j+1)=nchoosek(n,j)*t(k+1)^j*(1-t(k+1))^(n-j);
        term(i+1,j+1,:)=A(i+1,j+1,4)*f(i+1,j+1)*A(i+1,j+1,1:3)*g(i+1,j+1);  
        end
    end
    B(k+1,l+1,:)=sum(sum(term));
end
end
