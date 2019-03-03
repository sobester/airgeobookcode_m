function X=ffdsurf(s,t,u,a)
% FFDSURF 3D free-form deformation
%   X = FFDSURF(s,t,u,a) returns a matrix of points corresponding to a 
%   free-form deformation of surface points s,t,u according to the grid of 
%   control points a. X(:,:,1) are the  x-components, X(:,:,2) the 
%   y-components, and X(:,:,3) the corresponding z-components of the 
%   resulting free-form deformation. This structure of output is compatible 
%   with Matlab graphics functions such as mesh and surf. The input a is 
%   similarly structured
%
%
%   Example
%   =======
%   This will generate the FFD in Figure 4.15(b) from Sobester and 
%   Forrester (2014):
%
% [a(:,:,:,1),a(:,:,:,2),a(:,:,:,3)]=meshgrid([0 1],[0 1],[0 1]);
% a(2,2,2,:)=[1.5 1.5 1.5];
% [s,t,u] = sphere(20);
% s=(s+1)/2;
% t=(t+1)/2;
% u=(u+1)/2;
% X=ffdsurf(s,t,u,a);
% mesh(X(:,:,1),X(:,:,2),X(:,:,3))
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

m=size(a,1)-1;
n=size(a,2)-1;
p=size(a,3)-1;
[ny,nx]=size(s);
X=zeros(ny,nx,3);
term=zeros(m+1,n+1,p+1,3);
f=zeros(m+1);
g=zeros(n+1);
h=zeros(p+1);
for ll=1:nx
    for l=1:ny
        for k=0:p
            for j=0:n
                for i=0:m
                    f(i+1)=nchoosek(m,i)*t(l,ll)^i*(1-t(l,ll))^(m-i);
                    g(j+1)=nchoosek(n,j)*s(l,ll)^j*(1-s(l,ll))^(n-j);
                    h(k+1)=nchoosek(p,k)*u(l,ll)^k*(1-u(l,ll))^(p-k);
                    term(i+1,j+1,k+1,:)=f(i+1)*g(j+1)*h(k+1)*a(i+1,j+1,k+1,:);
                end
            end
        end
        X(l,ll,:)=squeeze(sum(sum(sum(term))));
    end
end

