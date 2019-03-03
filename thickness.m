function C=thickness(x)
% THICKNESS evaluates the SUHPA thickness constraints
%   C=THICKNESS(X) returns a scalar C, which is the maximum difference
%   between the desired thikness and the calculated thickness of the wing
%   defined by X, i.e. if C<0 the thickness constraint is satisfied. The 
%   wing is defined by X, in the same way as for SUHPADRAG. The first three 
%   elements of the X imput vector are the span [m] and the root and tip 
%   thickness to chord ratio, respectively.
%
%   If wingParameters.foil='naca44xx', no further inputs are required
%
%   If wingParameters.foil='nacaxxxx', the 4th and 5th elements of X are
%   the maximum camber and its location (as per the first two-digits of the
%   NACA 4-digit definition.
%
%   If wingParameters.foil='hermite', X may have either 9 elements (with
%   X(4:9) being the hermite foil definition of a constant aerofoil
%   throughout the span) or 27 elements (with X(4:9), X(10:15), X(16:21)
%   and X(22:27) being the hermite foil defintion at the root, b/6, b/3 and
%   b/2 locations along span b - with linear variation between aerofoils).
%   The six hermite foil variables are (suggested ranges in brackets):
%    1  tension_upper_nose [0.1,0.4] |T_A^upper|
%    2  tension_lower_nose [0.1,0.4] |T_A^lower|
%    3  tension_upper_tail [0.1,2] |T_B^upper|
%    4  tension_lower_tail [0.1,2] |T_B^lower|
%    5  angle_lower_tail (deg) [-15,15] alpha_c
%    6  angle_tail (deg) [1,30] alpha_b
%
%   Further global variables need to be set before calling
%   SUHPACONSTRAINTS: wingParameters.weight (aircraft weight minus wing
%   weight [N]), wingParameters.loading (wing loading [N/m^2])
%   wingParameters.foil (aerofoil type).
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
b=x(1);  % WING SPAN [m]
%wingParameters.b=b;
rootThick=x(2)/1000; % SPAR THICKNESS AT ROOT [mm]
tipThick=x(3)/1000; % SPAR THICKNESS AT TIP [mm]
TR=(rootThick-tipThick)/(b/2);
L=wingParameters.weight+wingweight(b);
S=L/wingParameters.loading;
[chords,error]=fminsearch(@getchords,[0.8 0.6 0.5]);
sectionLength=b/6;
area0=(chords(1)+chords(2))*sectionLength/2;
area1=(chords(2)+chords(3))*sectionLength/2;
area2=S/2-area0-area1;
chords(4)=(2*area2/sectionLength)-chords(3);


stations=4;
y=0:sectionLength:b/2;
for i=1:stations
    t=rootThick-TR.*y(i);
    if strcmp(wingParameters.foil,'naca44xx')==1 || strcmp(wingParameters.foil,'nacaxxxx')==1
        tc=t/chords(i);
    elseif strcmp(wingParameters.foil,'hermite')
        if length(x)==9
            [upper,lower,tc] = hermite_airfoil(x(4),x(5),x(6),x(7),x(8),x(9));
        else
            [upper,lower,tc] = hermite_airfoil(x(4+(i-1)*6),x(5+(i-1)*6),x(6+(i-1)*6),x(7+(i-1)*6),x(8+(i-1)*6),x(9+(i-1)*6));
        end
    else
        error('airfoil type not supported')
    end
    thickViolation(i) = t-tc*chords(i);
end
C=max(thickViolation);