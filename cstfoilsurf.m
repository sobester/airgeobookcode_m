function [z, nBP, B] = cstfoilsurf(x, CSTCoefficients)
% CSTFOILSURF Creates a set of points at given abscissas on a CST surface 
% defined by the given CST coefficients. See also fastcstfoilsurf and
% uniformcstfoilsurf, which generate N points. See Section 7.3 of the book
% for a detailed discussion of CST.
% -------------------------------------------------------------------------
% Aircraft Geometry Toolbox v0.1.0, Andras Sobester 2014.
%
% Sobester, A, Forrester, A I J F, "Aircraft Aerodynamic Design - Geometry 
% and Optimization", Wiley, 2014.
% -------------------------------------------------------------------------


CSTCoefficients = CSTCoefficients(:);

nBP = length(CSTCoefficients)-3;

% Compute the matrix of CST polynomial terms...
B = cstmatrix(nBP,x);

% ...and multiply them with the coefficients vector
z = B*CSTCoefficients;
