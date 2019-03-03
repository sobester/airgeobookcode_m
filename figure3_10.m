% FIGURE3_10 plots Bezier spline aerofoil
%
%   FIGURE3_10 plots the Bezier spline aerofoil in figure 3.10 using the
%   code in Lisiting 3.4. The script is rather long-winded for
%   demonstrative purposes. For example, the for i=1:101 ... loop can be
%   replaced by calls to BEZIER
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

% control points
p0=[1 0]';
p1=[0.5 0.08]';
p2=[0 -0.05]';
q1=[0 0.1]';
q2=[0.4 0.2]';
q3=[1 0]';

% weights
zp=[1 1 1 1];
zq=[1 1 1 1];

% calculate connection point
p3=(2/(2+3))*p2+(3/(2+3))*q1;
q0=p3;

figure
hold on

% calculate rational cubic Bezier for t[0,1]
t=0:0.01:1;
for i=1:101
    lower(i,:)=((1-t(i))^3*zp(1)*p0+...
        3*t(i)*(1-t(i))^2*zp(2)*p1+...
        3*t(i)^2*(1-t(i))*zp(3)*p2+...
        t(i)^3*zp(4)*p3)./...
        ((1-t(i))^3*zp(1)+...
        3*t(i)*(1-t(i))^2*zp(2)+...
        3*t(i)^2*(1-t(i))*zp(3)+...
        t(i)^3*zp(4)); 
    upper(i,:)=((1-t(i))^3*zq(1)*q0+...
        3*t(i)*(1-t(i))^2*zq(2)*q1+...
        3*t(i)^2*(1-t(i))*zq(3)*q2+...
        t(i)^3*zq(4)*q3)./...
        ((1-t(i))^3*zq(1)+...
        3*t(i)*(1-t(i))^2*zq(2)+...
        3*t(i)^2*(1-t(i))*zq(3)+...
        t(i)^3*zq(4));
end

% plot
plot(lower(:,1),lower(:,2),'k','LineWidth',2)
plot(upper(:,1),upper(:,2),'k','LineWidth',2)

% plot control points
plot(p0(1),p0(2),'k.','MarkerSize',30)
plot(p1(1),p1(2),'k.','MarkerSize',30)
plot(p2(1),p2(2),'k.','MarkerSize',30)

plot(q0(1),q0(2),'k.','MarkerSize',30)
plot(q1(1),q1(2),'k.','MarkerSize',30)
plot(q2(1),q2(2),'k.','MarkerSize',30)
plot(q3(1),q3(2),'k.','MarkerSize',30)

% plot control polygon
plot([p0(1) p1(1)],[p0(2) p1(2)],'k','LineWidth',0.5)
plot([p1(1) p2(1)],[p1(2) p2(2)],'k','LineWidth',0.5)
plot([p2(1) p3(1)],[p2(2) p3(2)],'k','LineWidth',0.5)

plot([p3(1) q1(1)],[p3(2) q1(2)],'k','LineWidth',0.5)
plot([q1(1) q2(1)],[q1(2) q2(2)],'k','LineWidth',0.5)
plot([q2(1) q3(1)],[q2(2) q3(2)],'k','LineWidth',0.5)

axis equal
axis off

