function C = basicclassfun(Arg, N1, N2, a1, a2)
% Returns the value of the basic fuselage function [Equation (2.16)]
% for a given Arg in [0,1]. This is also the basic CST class function.
% -------------------------------------------------------------------------
% Aircraft Geometry Toolbox v0.1.0, Andras Sobester 2014.
%
% Sobester, A, Forrester, A I J F, "Aircraft Aerodynamic Design - Geometry 
% and Optimization", Wiley, 2014.
% -------------------------------------------------------------------------


% Defaults
if ~exist('a1','var')
    a1 = 0;
end

if ~exist('a2','var')
    a2 = 1;
end

C = (Arg-a1).^N1.*(a2-Arg).^N2;