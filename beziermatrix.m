function m=beziermatrix(n)
% BEZIERMATRIX builds the M matrix in Equation 3.16
%   M = BEZIERMATRIX(N) returns a (d+1)x(d+1) matrix with elements defined
%   by Equation 3.16, where d is the degree of the Bezier curve
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
m=zeros(n+1,n+1);
for i=0:n
    for j=0:n-i
        m(i+1,j+1)=nchoosek(n,j)*nchoosek(n-j,n-j-i)*(-1)^(n-j-i);
    end
end
