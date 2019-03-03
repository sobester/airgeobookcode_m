function [x,z] = divideexplicit(explfun, xmin, xmax, N)
% Internal function.
% Approximates the curve z = explfun(x), x in [xmin,xmax]
% with N segments of equal length and returns the coordinate
% sets x and z = explfun(x) (explfun must take vector input). 
%
% EXAMPLE:
% [x,z] = divideexplicit(@sin, 0, 2*pi, 10);
% plot((0:0.01:2*pi),sin((0:0.01:2*pi))), hold on
% plot(x,z,'ro'), axis equal
%
% -------------------------------------------------------------------------
% Aircraft Geometry Toolbox v0.1.0, Andras Sobester 2014.
%
% Sobester, A, Forrester, A I J F, "Aircraft Aerodynamic Design - Geometry 
% and Optimization", Wiley, 2014.
% -------------------------------------------------------------------------



% First we estimate the length of the curve...
LCurve = explcrvlength(explfun, xmin, xmax);

% ...in order to be able to compute the division lengths 
DeltaL = LCurve / (N-1);

% Approx. the curve between xmin and  xmax with segments
% of length DeltaL
options = optimset('TolX',1e-5,'MaxFunEvals',100,'MaxIter',100);
x = zeros(N,1);
x(1) = xmin;
for i=2:N-1
    CurrentPoint = x(i-1);
    x(i) = fminbnd(@eucldistfun, CurrentPoint,...
        min([CurrentPoint+DeltaL,xmax]), options);
end
x(N) = xmax;


% Compute the function value at the x's found. Note that
% explfun must take vector input.
z = feval(explfun, x);

    function d = eucldistfun(absc)
    % Computes the difference between the distance between 
    % [CurrentPoint, explfun(CurrentPoint)] and 
    % [absc        , explfun(absc)]
    % and the target distance.
    
    d = sqrt(...
        (CurrentPoint - absc)^2 + ...
        (feval(explfun,CurrentPoint) - feval(explfun,absc))^2 ...
            );
        
    d = abs(d - DeltaL);
    
    end % nested function eucldistfun

end
