function [CSTCoefficientsUpper,CSTCoefficientsLower] = ...
    findcstcoeff(Target,nBPUpper,nBPLower,DeviationPlot)
%FINDCSTCOEFF Returns the vector of CST coefficients for a target airfoil.
%A plot of deviations between the target points and the fitted airfoil is
%also included if the last argument is included and set to 1. For a
%detailed discussion of the mathematical formulation, refer to Section 7.3
%of the book referenced below.
%
% Inputs:
%       Target - name of target airfoil or 
%                cell array of coordinates {xu zu xl zl}
%       nBPUpper - desired order of the Bernstein polynomials that make up the
%              approximation of the upper surface
%       nBPLower - desired order of the Bernstein polynomials that make up the
%              approximation of the lower surface
%
% Output:
%       CSTCoefficientsUpper, CSTCoefficientsLower - the CST coefficients 
%               of the approximation of the target airfoil
%
% Example
% =======
% Load the raw coordinates for SC(2)-0714 and apply a CST of order 4 (upper
% surface) and 5 (lower surface) to them:
% Airfoil = nearestsc2(0.7, 14, 'low', 0, 1);          
% nBPUpper = 4; nBPLower = 5;
% [CSTCoeffUpper,CSTCoeffLower] = findcstcoeff(Airfoil,nBPUpper,nBPLower,1); 
%
%
% -------------------------------------------------------------------------
% Aircraft Geometry Toolbox v0.1.0, Andras Sobester 2014.
%
% Sobester, A, Forrester, A I J, "Aircraft Aerodynamic Design - Geometry 
% and Optimization", Wiley, 2014.
% -------------------------------------------------------------------------

% Load list of coordinates of the target airfoil
if ischar(Target)
    [XTargetUpper,ZTargetUpper0,...
     XTargetLower,ZTargetLower0] = readfoildata(Target);
else
    XTargetUpper  = Target{1};
    ZTargetUpper0 = Target{2};
    XTargetLower  = Target{3};
    ZTargetLower0 = Target{4};
end
    
% This is an explicit formulation, so we need to check whether the x
% coordinates are monotonically ascending and eliminate any points where
% the curve comes back on itself (this might happen, e.g., near the leading
% edge of highly cambered NACA profiles)
monotonicitycheck
        
% Remove trailing edge 'wedge' term from target airfoil
ZTEUpper = ZTargetUpper0(end);
ZTELower = ZTargetLower0(end);
ZTargetUpper = ZTargetUpper0 - XTargetUpper*ZTEUpper;
ZTargetLower = ZTargetLower0 - XTargetLower*ZTELower;

% Compute coefficients for upper surface
B = cstmatrix(nBPUpper,XTargetUpper');
CSTCoefficientsUpper = B\ZTargetUpper(:);

% Insert the trailing edge 'wedge' back
CSTCoefficientsUpper(end-1) = ZTEUpper;

% Compute coefficients for lower surface
B = cstmatrix(nBPLower,XTargetLower');
CSTCoefficientsLower = B\ZTargetLower(:);

% Insert the trailing edge 'wedge' back
CSTCoefficientsLower(end-1) = ZTELower;


% Graphical representation of the deviation
% between the target airfoil and the CST approximation
if exist('DeviationPlot','var') && ...
    DeviationPlot==1

    ZUpper = cstfoilsurf(XTargetUpper, CSTCoefficientsUpper);
    ZLower = cstfoilsurf(XTargetLower, CSTCoefficientsLower);
    
    % Target and approximation superimposed
    figure, hold on
    plot(XTargetUpper,ZUpper,'r')
    plot(XTargetUpper,ZTargetUpper0,'+')
    plot(XTargetLower,ZLower,'r')
    plot(XTargetLower,ZTargetLower0,'+')
    
    % Deviations
    DevLower = cstdeviations(XTargetLower(:), ZTargetLower0(:), CSTCoefficientsLower);
    DevUpper = cstdeviations(XTargetUpper(:), ZTargetUpper0(:), CSTCoefficientsUpper);
    
    % Deviation plot
    figure, hold on
    
    % Wind tunnel manufacturing tolerances
    % as a benchmark for asessing deviations
    patch([-1 -0.2 -0.2 0.2 0.2 1 1 0.2 0.2 -0.2 -0.2 -1],...
        [-7e-4 -7e-4 -3.5e-4 -3.5e-4 -7e-4 -7e-4 ...
        7e-4 7e-4 3.5e-4 3.5e-4 7e-4 7e-4], [0.7 0.8 0.9]);
    plot([0 0],[-3.5e-4 3.5e-4],'k')
    text(-0.8,-6e-4,'Lower surface')
    text(0.4,-6e-4,'Upper surface')
    text(0,-7.5e-4,'Leading edge','Rotation',90)
    set(gca,'XTick',[-1 0 1])
    set(gca,'XTickLabel',{'1','0','1'})
    xlabel('X'); ylabel('Approximation error [units of chord, orthogonal]')
    title(['n_{BP}^u=',num2str(nBPUpper),'   n_{BP}^l=',num2str(nBPLower)])
    
    plot( -XTargetLower(:),DevLower,'k','LineWidth',1.5)
    plot( XTargetUpper(:),DevUpper,'k','LineWidth',1.5)
    ylim([-1e-3 1e-3])

end

    function monotonicitycheck
        i = 2;
        while i <= length(XTargetUpper)
            if XTargetUpper(i)<=XTargetUpper(i-1)
                XTargetUpper(i) = [];
                ZTargetUpper0(i) = [];
                disp('Non-explicit target point removed before CST.')
                disp('This usually means that there were x<0 points in the list.')
            else
                i=i+1;
            end
        end
        i = 2;
        while i <= length(XTargetLower)
            if XTargetLower(i)<=XTargetLower(i-1)
                XTargetLower(i) = [];
                ZTargetLower0(i) = [];
                disp('Non-explicit target point removed before CST.')
                disp('This usually means that there were x<0 points in the list.')
            else
                i=i+1;
            end
        end
    end

end