function [x,z] = fastcstfoilsurf(CSTCoefficients, N)
% Creates an array of N points on a CST surface defined by the given CST 
% coefficients. This is a fast procedure, but there is no guarantee of 
% uniform distribution. If uniformity is needed use the slower
% uniformcstfoilsurf.m

x = (0:1/(N-1):1);

z = cstfoilsurf(x,CSTCoefficients);