% FIGURE4_3 plots Coons Bezier wing
%
%    FIGURE4_3 uses equation 4.4, calling the bezier function to create the
%    Coons surface in Figure 4.3
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

up1=[0 0.0 0.0
    0 0.0  0.1
    0 0.4  0.2
    0 1.0  0.0];


up2=[1 0.0 0.0
    1 0.0  0.1
    1 0.2  0.1
    1 0.5  0];

le=[0 0  0
    0.33 0.2  0
    0.66 0.1  0
    1 0  0];
te=[0 1  0
    0.33 0.8  0
    0.66 0.6  0
    1 0.5 0];

u=0:1/20:1;
w=0:1/20:1;
Pu0=bezier(up1);
    Pu1=bezier(up2);
    P0w=bezier(le);
    P1w=bezier(te);
for i=1:21
    for j=1:21
    
    C(i,j,1)=[(1-u(i)) u(i)]*[P0w(j,1); P1w(j,1)] + [(1-w(j)) w(j)]*[Pu0(i,1);Pu1(i,1)]...
        -[(1-u(i)) u(i)]*[0 1;0 1]*[(1-w(j)) w(j)]';
    C(i,j,2)=[(1-u(i)) u(i)]*[P0w(j,2);P1w(j,2)]+[(1-w(j)) w(j)]*[Pu0(i,2);Pu1(i,2)]...
        -[(1-u(i)) u(i)]*[0 0;1 0.5]*[(1-w(j)) w(j)]';
    C(i,j,3)=[(1-u(i)) u(i)]*[P0w(j,3);P1w(j,3)]+[(1-w(j)) w(j)]*[Pu0(i,3);Pu1(i,3)]...
        -[(1-u(i)) u(i)]*[0 0;0 0]*[(1-w(j)) w(j)]';
    end
end
figure
m=mesh(C(:,:,2),C(:,:,1),C(:,:,3));
hold on
plot3(Pu0(:,2),Pu0(:,1),Pu0(:,3),'k','LineWidth',3)
plot3(Pu1(:,2),Pu1(:,1),Pu1(:,3),'k','LineWidth',3)

plot3(P0w(:,2),P0w(:,1),P0w(:,3),'k','LineWidth',3)
plot3(P1w(:,2),P1w(:,1),P1w(:,3),'k','LineWidth',3)
set(m,'FaceAlpha',0,'EdgeColor',[0 0 0]);
axis equal
axis off

