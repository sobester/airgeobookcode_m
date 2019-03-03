function N=nurbssurface(A,d,kn,z,n)
% NURBSSURFACE NURBS surface
%   N = NURBSSURFACE(A) returns a 21x21x3 matrix of points on a degree 2 
%   NURBS surface defined by equally weighted control points A, with a 
%   uniform knot vector. N(:,:,1) are the  x-components, N(:,:,2) the 
%   y-components, and N(:,:,3) the corresponding z-components of the 
%   surface. This structure of output is compatible with Matlab graphics 
%   functions such as mesh and surf. The input A is similarly structured
%
%   N = NURBSSURFACE(A) returns a 21x21x3 matrix of points on a degree d 
%   NURBS surface defined by equally weighted control points A, with a 
%   uniform knot vector.
%
%   N = NURBSSURFACE(A) returns a 21x21x3 matrix of points on a degree d 
%   NURBS surface defined by equally weighted control points A, with the 
%   number of control points + (d+1) knot vector defined by kn.
%
%   N = NURBSSURFACE(A) returns a 21x21x3 matrix of points on a degree d 
%   NURBS surface defined by control points A with weightings z.
%
%   N = NURBSSURFACE(A) returns an nxnx3 matrix of points on a degree d 
%   NURBS surface defined by control points A.
%
%   Example
%   =======
%   This will generate the surface in Figure 4.10(a) from Sobester and 
%   Forrester (2014):
%
% P(:,:,1)=[-0.25 0 0.25 0.5 0.75 1 1.25
%     -0.25 0 0.25 0.5 0.75 1 1.25
%     -0.25 0 0.25 0.5 0.75 1 1.25
%     -0.25 0 0.25 0.5 0.75 1 1.25
%     -0.25 0 0.25 0.5 0.75 1 1.25
%     -0.25 0 0.25 0.5 0.75 1 1.25
%     -0.25 0 0.25 0.5 0.75 1 1.25];
% P(:,:,2)=[-0.25 -0.25 -0.25 -0.25 -0.25 -0.25 -0.25 
%     0 0 0 0 0 0 0
%     0.25 0.25 0.25 0.25 0.25 0.25 0.25
%     0.5 0.5 0.5 0.5 0.5 0.5 0.5
%     0.75 0.75 0.75 0.75 0.75 0.75 0.75
%     1 1 1 1 1 1 1
%     1.25 1.25 1.25 1.25 1.25 1.25 1.25];
% P(:,:,3)=-(P(:,:,1)-0.5).^2+(P(:,:,2)-0.5).^2;
% P(4,4,3)=1;
% 
% kn=[0 0 0 1 2 3 4 5 5 5];
% d=2;
% N=nurbssurface(P,d,kn);
% m=mesh(N(:,:,1),N(:,:,2),N(:,:,3));
% hold on
% plot3(P(:,:,1),P(:,:,2),P(:,:,3),'k.','MarkerSize',20)
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
if exist('d','var')~=1 || isempty(d)==1
    d=2;
end
if exist('z','var')~=1 || isempty(z)==1
    z=ones(length(A),1);
end
if exist('kn','var')~=1 || isempty(kn)==1
    kn=0:length(A)+d;
end
if exist('n','var')~=1 || isempty(n)==1
    n=21;
end
order=d+1;
startPoint=kn(order);
endPoint=kn(end-order+1);
t=startPoint:(endPoint-startPoint)/(n-1):endPoint;
N=zeros(n,n,3);
for l=1:n
    for j=1:n 
        Nl=nurbsweight(kn,d,t(l));
        Nj=nurbsweight(kn,d,t(j));
        pTerm(1)=(z(:).*Nj(1:length(A),order))'*A(:,:,1)*(z(:).*Nl(1:length(A),order));
        pTerm(2)=(z(:).*Nj(1:length(A),order))'*A(:,:,2)*(z(:).*Nl(1:length(A),order));
        pTerm(3)=(z(:).*Nj(1:length(A),order))'*A(:,:,3)*(z(:).*Nl(1:length(A),order));
        weightTerm=(z'*Nj(1:length(A),order))*(z'*Nl(1:length(A),order));
        N(l,j,:)=pTerm/weightTerm;
    end
end
