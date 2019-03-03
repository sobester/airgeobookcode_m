% FIGURE4_2 plots translated Bezier wing
%
%    FIGURE4_2 uses equation 4.2, calling the bezier function to create the
%    translated surface in Figure 4.2
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


le=[0 0 0
    0.2 0.33 0
    0.1 0.66 0
    0 1 0];

Pu0=bezier(up1);
P0w=bezier(le);
for i=1:21
    for j=1:21  
    C(i,j,:)=Pu0(i,:)+P0w(j,:)-[0 0 0];
    end
end
figure
m=mesh(C(:,:,1),C(:,:,2),C(:,:,3));
hold on
plot3(Pu0(:,1),Pu0(:,2),Pu0(:,3),'k','LineWidth',3)
plot3(P0w(:,1),P0w(:,2),P0w(:,3),'k','LineWidth',3)
set(m,'FaceAlpha',0,'EdgeColor',[0 0 0]);
axis equal
axis off
