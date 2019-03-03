function B = cstmatrix(nBP,x)
% Constructs matrix of CST polynomial terms. See Section 7.3 of the book
% referenced below for a detailed discussion of the Class Shape
% Transformation.
% -------------------------------------------------------------------------
% Aircraft Geometry Toolbox v0.1.0, Andras Sobester 2014.
%
% Sobester, A, Forrester, A I J F, "Aircraft Aerodynamic Design - Geometry 
% and Optimization", Wiley, 2014.
% -------------------------------------------------------------------------

% Airfoil class function exponents
N1 = 0.5;
N2 =   1;

x = x(:);

B = zeros(length(x),nBP+3);

% Bernstein polynomial terms

% Class function
C = x.^N1.*(1-x).^N2;

for r=0:nBP
    % Shape function
    S = nchoosek(nBP,r)*x.^r.*(1-x).^(nBP-r);
    B(:,r+1) = C.*S;
end

% Trailing edge thickness term(s)
B(:,nBP+2) = x;

% Leading edge shaping term(s)
B(:,nBP+3) = x.^N2.*(1-x).^N1.*(1-x).^nBP;