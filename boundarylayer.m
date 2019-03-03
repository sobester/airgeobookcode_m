function [cd,effectivefoil]=boundarylayer(v,ds,xc,yc,theta,dy,Re,nu,nlimit,plotting)
% BOUNDARYLAYER - non-coupled e^n boundary layer method
%   [cd,effectivefoil]=BOUNDARYLAYER(v,ds,xc,yc,dy,theta,Re,nu,nlimit,plotting)
%   Estimates the drag over an aerofoil using a simplified e^n method
%
%   INPUTS (can be calculated using PANEL)
%   v: magnitude of surface velocity
%   ds: panel lengths
%   xc: x-location of panel centres
%   yc: y-location of panel centres
%   theta: angle of panels
%   dy: vertical distance between panel end-points
%   Re: Reynolds number
%   nu: kinematic viscoscity
%   nlimit: e^n method constant - set at, e.g. 9
%   plotting: 0 = no plot, 1 = quiver plot of aerfoloil and boundary layer
%   displacement thickness
%
%   OUTPUTS
%   cd: drag coeficient
%   effectivefoil: inputed aerofoil, plus displacement thickness
%
% EXAMPLE
% =======
%
% Calls PANEL and BOUNDARYLAYER to calculate the pressure over, and lift 
% and drag of a NACA0012 aerfoil at 10 degrees angle of attack and compares 
% the pressure to experimental data.
%
% alpha=10;
% Re=2.88e6;
% rho=1.2;
% nlimit=7;
% mu=1.8e-5;
% nu=mu/rho;
% U=Re*nu;
% npoints=201; % this can have dramatic effects on the results
% % calculate aerofoil coordinates
% A=naca4(0,0,12,'Low',npoints,0);
% % format to pass to panel()
% xu=A{1};
% yu=A{2};
% xl=A{3}(end:-1:2);
% yl=A{4}(end:-1:2);
% aerofoilPoints=[xl' xu'; yl' yu']';
% % call panel()
% [cl,cp,ux,uy,v,ds,xc,yc,theta,dy]=panel(aerofoilPoints,alpha,Re,1);
% % call BOUNDARYLAYER
% [cd,ef]=BOUNDARYLAYER(v,ds,xc,yc,theta,dy,Re,nu,nlimit,1);
% 
% % Validation data (NACA0012 @ 10deg upper surface cp 
% % - Gregory & O'Reilly, NASA R&M 3726, Jan 1970)
% upperCp=[0 -3.66423
%     0.00218341 -5.04375
%     0.00873362 -5.24068
%     0.0131004 -4.67125
%     0.0174672 -4.32079
%     0.0480349 -2.74347
%     0.0742358 -2.26115
%     0.0982533 -1.95405
%     0.124454 -1.7345
%     0.146288 -1.55884
%     0.176856 -1.36109
%     0.28821 -1.00829
%     0.320961 -0.941877
%     0.384279 -0.787206
%     0.447598 -0.654432
%     0.515284 -0.543461
%     0.576419 -0.432633
%     0.637555 -0.343703
%     0.700873 -0.254725
%     0.766376 -0.1657
%     0.831878 -0.098572
%     0.893013 -0.00964205
%     0.958515 0.0793835
%     1 0.124088];
% 
% % plot Cp
% figure
% plot(xc(npoints:-1:1),cp(npoints:-1:1),'b');
% hold on
% plot(xc(npoints:(npoints-1)*2),cp(npoints:(npoints-1)*2),'r');
% plot(upperCp(:,1),upperCp(:,2),'go')
% titletext=['cl=',num2str(cl),' cd=',num2str(cd)];
% title(titletext)
% legend('lower','upper','experiment','Location','SouthEast')
% xlabel('x/c')
% ylabel('c_p')
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