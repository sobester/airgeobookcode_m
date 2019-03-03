% FIGURE4_1 plots lofted Bezier wing
%
%    FIGURE4_1 uses equation 4.1, calling the bezier function to create the
%    lofted surface in Figure 4.1
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

up1=[0.0 0 0.0
     0.0 0 0.1
     0.4 0 0.2
     1.0 0 0.0];

up2=[0.0 1 0.0
     0.0 1 0.1
     0.2 1 0.1
     0.5 1 0];

u=0:1/20:1;
for i=1:21
    bezierLoftUpper(i,:,:)=(1-u(i)).*bezier(up1) + u(i).*bezier(up2);
end
figure
m=mesh(bezierLoftUpper(:,:,1),bezierLoftUpper(:,:,2),bezierLoftUpper(:,:,3));
set(m,'FaceAlpha',0,'EdgeColor',[0 0 0]);
hold on
set(m,'FaceAlpha',0,'EdgeColor',[0 0 0]);
plot3(bezierLoftUpper(1,:,1),bezierLoftUpper(1,:,2),bezierLoftUpper(1,:,3),'k','LineWidth',3)
plot3(bezierLoftUpper(end,:,1),bezierLoftUpper(end,:,2),bezierLoftUpper(end,:,3),'k','LineWidth',3)
axis equal
axis off