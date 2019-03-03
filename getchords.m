function [E,C]=getchords(X,plottaper)
% GETCHORDS calculate wing chord lengths
%   [E,C]=GETCHORDS(X,PLOTTAPER) returns chords of a wing defined by the
%   root, b/6 and b/3 chords in input X, which results in a wing closest to
%   an elliptic planform. PLOTTAPER=1 plots the returned chords and an
%   elliptic planform.
%
%   Further global variables need to be set before calling GETCHORDS:
%   wingParameters.b (wing span), wingParameters.weight (weight of aircraft
%   minus the wing), wingParameters.loading (wing loading).
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
global wingParameters

b=wingParameters.b;
L=wingParameters.weight+wingweight(b);
S=L/wingParameters.loading;

sectionLength=b/6;

chord0=X(1);
chord1=X(2);
chord2=X(3);
tr0=chord1/chord0;
tr1=chord2/chord1;

area0=(chord0+chord1)*sectionLength/2;
area1=(chord1+chord2)*sectionLength/2;
area2=S/2-area0-area1;
chord3=(2*area2/sectionLength)-chord2;
tr2=chord3/chord2;

stations=21;
stationLength=(b/2)/(stations-1);
x=0:stationLength:b/2;
% eliptic chords
idealProfile=sqrt(1-(x.*2./b).^2);
idealRoot=(S/2)/sum((idealProfile(1:end-1)+idealProfile(2:end)).*stationLength/2);
idealChords=idealProfile.*idealRoot;
for i=1:stations
    if x(i)<=sectionLength
        C(i)=chord0*(tr0+(1-tr0)*((sectionLength-x(i))/sectionLength));
    elseif x(i)<=sectionLength*2
        C(i)=chord1*(tr1+(1-tr1)*((sectionLength*2-x(i))/sectionLength));
    else
        C(i)=chord2*(tr2+(1-tr2)*((sectionLength*3-x(i))/sectionLength));
    end
end

if exist('plottaper','var')==1
    figure
    plot(x,C)
    hold on
    plot(x,idealChords,'r')
end
E=mean((C(1:end-2)-idealChords(1:end-2)).^2);
