function B=bsplinesurface(A,N)
% BSPLINESURFACE B-spline surface
%   B = BSPLINESURFACE(A) returns a 21x21xnxnx3 matrix of points on a 
%   degree 2 B-spline surface defined by control points A. The surface 
%   comprises nxn patches. B(:,:,1,1,1) are the x-components of the 1,1
%   patch B(:,:,1,1,2) the y-components, and B(:,:,1,1,3) the corresponding 
%   z-components of the path. This structure of output is compatible 
%   with Matlab graphics functions such as mesh and surf. The input A is 
%   similarly structured
%
%   B = BSPLINESURFACE(A,N) returns an NxNxnxnx3 matrix of points on a 
%   B-spline surface defined by control points A.
%
%   calls bsplinematrix
%
%   Example
%   =======
%   This will generate the surface in Figure 4.7 from Sobester and 
%   Forrester (2014):
%
% A(:,:,1)=[-0.25 0 0.25 0.5 0.75 1 1.25
%     -0.25 0 0.25 0.5 0.75 1 1.25
%     -0.25 0 0.25 0.5 0.75 1 1.25
%     -0.25 0 0.25 0.5 0.75 1 1.25
%     -0.25 0 0.25 0.5 0.75 1 1.25
%     -0.25 0 0.25 0.5 0.75 1 1.25
%     -0.25 0 0.25 0.5 0.75 1 1.25];
% A(:,:,2)=[-0.25 -0.25 -0.25 -0.25 -0.25 -0.25 -0.25 
%     0 0 0 0 0 0 0
%     0.25 0.25 0.25 0.25 0.25 0.25 0.25
%     0.5 0.5 0.5 0.5 0.5 0.5 0.5
%     0.75 0.75 0.75 0.75 0.75 0.75 0.75
%     1 1 1 1 1 1 1
%     1.25 1.25 1.25 1.25 1.25 1.25 1.25];
% A(:,:,3)=[0 0.5 1 1.5 1 0.5 0
%     -0.5 0 0.5 1 0.5 0 -0.5
%     -1 -0.5 0 0 0 -0.5 -1
%     -1.5 -1 0 1 0 -1 -1.5
%     -1 -0.5 0 0 0 -0.5 -1
%     -0.5 0 0.5 1 0.5 0 -0.5
%     0 0.5 1 1.5 1 0.5 0];
% A(:,:,3)=-(A(:,:,1)-0.5).^2+(A(:,:,2)-0.5).^2;
% 
% B=bsplinesurface(A,11);
% 
% figure
% hold on
% plot3(A(:,:,1),A(:,:,2),A(:,:,3),'k.','MarkerSize',20)
% for g=1:5
%     for j=1:5
%         surf(B(:,:,j,g,1),B(:,:,j,g,2),B(:,:,j,g,3))
%     end
% end
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
u=0:0.1:1;
t=0:0.1:1;
d=2;
M=(1/factorial(d))*bsplinematrix(d);
B=zeros(N,N,5,5,3);
for j=0:length(A)-d-1
    for g=0:length(A)-d-1
        for l=0:N-1
            for k=0:N-1               
                B(k+1,l+1,j+1,g+1,1)=[t(k+1)^2 t(k+1), 1]*M*A(j+1:j+d+1,g+1:g+d+1,1)*M'*[u(l+1)^2 u(l+1), 1]';
                B(k+1,l+1,j+1,g+1,2)=[t(k+1)^2 t(k+1), 1]*M*A(j+1:j+d+1,g+1:g+d+1,2)*M'*[u(l+1)^2 u(l+1), 1]';
                B(k+1,l+1,j+1,g+1,3)=[t(k+1)^2 t(k+1), 1]*M*A(j+1:j+d+1,g+1:g+d+1,3)*M'*[u(l+1)^2 u(l+1), 1]';
            end
        end
    end
end

