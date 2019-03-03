function [x,z] = uniformcstfoilsurf(CSTCoefficients, N)
% UNIFORMCSTFOILSURF(CSTCoefficients, N)
%       
% Creates a uniformly distributed array of N points on a CST surface defined
% by the given CST coefficients. This is somewhat time-consuming, so if speed
% is of the essence (rather than uniformity), fastcstfoilsurf.m should be used. 
% -------------------------------------------------------------------------
% Aircraft Geometry Toolbox v0.1.0, Andras Sobester 2014.
%
% Sobester, A, Forrester, A I J, "Aircraft Aerodynamic Design - Geometry 
% and Optimization", Wiley, 2014.
% -------------------------------------------------------------------------


display('Generating CST airfoil surface with uniformly distributed points...')

[x,z] = divideexplicit(@cstsrf, 0, 1, N);

    function zcoord = cstsrf(xcoord)
        zcoord = cstfoilsurf(xcoord,CSTCoefficients(:));
    end
end