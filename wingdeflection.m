function d=wingdeflection(x)
% WINGDEFLECTION calculate wing tip deflection
%   D=WINGDEFLECTION(X) returns the tip deflection of a wing defined by X,
%   a vetor of the wing span [m], root thicknes [mm] and tip thickness
%   [mm]. The stiffness of the wing is assumed to come purely from a
%   pultruded carbon spar capping.
%
%   Further global variables need to be set before calling GETCHORDS:
%   wingParameters.tCap (thickness of pultruded carbon capping (top and 
%   bottom [mm]), wingParameters.wSpar (width of spar [mm]).
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


b=x(1);  % WING SPAN [m]
rootThick=x(2); % SPAR THICKNESS AT ROOT [mm]
tipThick=x(3); % SPAR THICKNESS AT TIP [mm]


%% material properties
ETensile=170000;
EComp=159590;
density=1514.3; %kg/m^3

global wingParameters

L=wingParameters.weight; % LIFT LOAD ON WING [N]
bmm=(b*1000)/2;
TR=(rootThick-tipThick)/bmm;

step=10;
xmm=0:step:bmm;
n=length(xmm)-1;

L0=(L-230-170)/((pi/4)*b); % lift at root
l=L0*sqrt(1-(xmm.*2./(1.1*bmm*2)).^2); % lift distribution
T=rootThick-TR.*xmm;

d2nudx2=zeros(n+1,1);
dnudx=zeros(n+1,1);
nu=zeros(n+1,1);

for i=1:n+1
    m=sum((l(i:end).*step.*(xmm(i:end)-xmm(i)))); % Moment        
    tLow=wingParameters.tCap; % Thickness of beam elements
    tUp=wingParameters.tCap*EComp/ETensile; %% Scale thickness based on ratio of stiffness   
    yUp=T(i)/2-tUp/2;   % Distance to centroids
    yLow=-(T(i)/2-tLow/2);   
    IxUp=(1/12)*wingParameters.wSpar*tUp^3; % Individual Ix
    IxLow=(1/12)*wingParameters.wSpar*tLow^3;       
    AUp=wingParameters.wSpar*tUp; % Area of beam elements 
    ALow=wingParameters.wSpar*tLow;   
    neutralAxis=(yUp*AUp+yLow*ALow)/(AUp+ALow); % Neutral axis of beam   
    IxUp=IxUp+AUp.*(yUp-neutralAxis)^2; % Ix of beam elements using parallel axis theorem
    IxLow=IxLow+ALow.*(yLow-neutralAxis)^2;
    overallEI=ETensile*(IxUp+IxLow);  % Overall stiffness
    d2nudx2(i)=(m/1000)/overallEI; % Curvature
    dnudx(i)=sum(d2nudx2(1:i))*step;   % Gradient
    nu(i)=sum(dnudx(1:i))*step;  % Deflection
end
d=nu(end);



