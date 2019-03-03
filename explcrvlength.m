function L = explcrvlength(explfun, xmin, xmax)
% EXPLCRVLENGTH Estimates the length of an explicit curve
%    EXPLCRVLENGTH(explfun, xmin, xmax) estimates the length of the explicit
%    curve explfun between the ordinates xmin and xmax.
%
% EXAMPLE
% =======
% Length of a semi-circle of radius = 1 (pi)
% L = explcrvlength(@(x) sqrt(1-x^2), -1, 1)
%
% -------------------------------------------------------------------------
% Aircraft Geometry Toolbox v0.1.0, Andras Sobester 2014.
%
% Sobester, A, Forrester, A I J, "Aircraft Aerodynamic Design - Geometry 
% and Optimization", Wiley, 2014.
% -------------------------------------------------------------------------

x = (xmin:(xmax-xmin)/1000:xmax);

L = 0;

for i=1:length(x)-1
    L = L + sqrt(...
        (x(i+1)-x(i))^2 ...
       +(feval(explfun,x(i+1)) - feval(explfun,x(i)))^2 ...
                );
end
