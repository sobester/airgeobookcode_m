function B=nurbsweight(kn,degree,u)
% NURBSWEIGHT calculates NURBS basis functions using Equation 3.32 & 3.33
%   B = NURBSWEIGHT(KN,D,U) returns a (d+1)x(d+1) matrix with elements 
%   defined by Equation 3.32 & 3.33, where KN is the knot vetor, D is the 
%   degree and U is the positoin along the position along the NURBS.
%
%   Called by nurbs
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
B=zeros(length(kn)-1,degree+1);
for k=1:degree+1
    for i=1:length(kn)-(k)        
        if k==1 % intitialize recursive calculation at d=1
            if (u>kn(i) && u<=kn(i+1)) || (u==kn(1) && i==degree+1)
                B(i,k)=1;
            else
                B(i,k)=0;
            end
        else % d>1 basis functions  
            % catch denominator=0 cases
            if kn(i+k-1)==kn(i) && kn(i+k)==kn(i+1)
                B(i,k)=0;
            elseif kn(i+k)==kn(i+1)
                B(i,k)=((u-kn(i))/(kn(i+k-1)-kn(i)))*B(i,k-1);
            elseif  kn(i+k-1)==kn(i)
                B(i,k)=((kn(i+k)-u)/(kn(i+k)-kn(i+1)))*B(i+1,k-1);
            else
                B(i,k)=((u-kn(i))/(kn(i+k-1)-kn(i)))*B(i,k-1)+((kn(i+k)-u)/(kn(i+k)-kn(i+1)))*B(i+1,k-1);
            end
        end
    end  
end