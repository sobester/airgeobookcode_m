function [Airfoil, DesignCL, ThicknessToChord] = ...
    nearestsc2(DesignCL, ThicknessToChord, Fidelity, N, varargin)
%NEARESTSC2 - returns the NASA SC(2) airfoil nearest to the given CL & T/C
%
%   NEARESTSC2(DesignCL, ThicknessToChord, Fidelity, N, Plot) finds the SC(2)
%   supercritical airfoil nearest to the specified CL and T/C values
%   and samples them uniformly at N points on each surface. If N is not
%   specified or 0, the 'raw' original coordinates are returned (as per the paper
%   by C. Harris). See Section 6.3 in Sobester and Forrester (2014).
%   The function also generates a plot of deviations between the fitted CST
%   surface and the original target points from the Harris paper. The
%   re-sampled coorindates are returned as a cell array of vectors. Set
%   'Plot' to 1 to produce a deviation plot between the raw data and the
%   CST approximation.
%
%   EXAMPLE
%   =======
%   To generate SC(2)-0610, re-sampled at 100 points along a CST regression
%   model fitted to the original data set, type:
%   
%   nearestsc2(0.6, 10, 'High', 100)
%   
% -------------------------------------------------------------------------
% Aircraft Geometry Toolbox v0.1.0, Andras Sobester 2014.
%
% Sobester, A, Forrester, A I J, "Aircraft Aerodynamic Design - Geometry 
% and Optimization", Wiley, 2014.
% -------------------------------------------------------------------------


% Read in the SC(2) coordinate data
load sc2
FoilNo = size(SC2Data,2);

% Calculate differences between target cl and t/c
% and the list of available SC(2) airfoils 
DistMet = zeros(1,FoilNo);
for i=1:FoilNo
    DistMet(i) = (ThicknessToChord - SC2Data(i).TC)^2 + ...
                 (10*DesignCL - 10*SC2Data(i).CL)^2;
end
[~,Nearest] = min(DistMet);


% Extract data for most similar available SC(2) foil
DesignCL = SC2Data(Nearest).CL;
ThicknessToChord = SC2Data(Nearest).TC;

% Point coordinates
xu = SC2Data(Nearest).Coord(103:-1:1,1);
zu = SC2Data(Nearest).Coord(103:-1:1,2);
xl = SC2Data(Nearest).Coord(103:end,1);
zl = SC2Data(Nearest).Coord(103:end,2);

DesignCLstr = num2str(10*DesignCL);
if length(DesignCLstr)==1, DesignCLstr = ['0',DesignCLstr]; end
ThicknessToChordstr = num2str(ThicknessToChord);


if strcmpi(Fidelity,'low') || ~exist('N','var') || N==0
    % The 'raw' coordinates are returned, without smoothing
    Airfoil{1} = xu;
    Airfoil{2} = zu;
    Airfoil{3} = xl;
    Airfoil{4} = zl;
    return
end

disp(['Generating NASA supercritical airfoil SC(2)-',DesignCLstr,ThicknessToChordstr])

global CSTCoefficients

% Re-sampling required via CST
disp('Smoothing and re-distributing SC(2) coordinates...')
Target = {xu, zu, xl, zl};

%==========================================================================
% This can be changed for greater or lesser approximation accuracy
%==========================================================================
nBPUpper = 3;
nBPLower = 4;
%==========================================================================

if nargin>0
    DeviationPlot = varargin{1};
end

[CSTCoeffUpper,CSTCoeffLower] = ...
    findcstcoeff(Target,nBPUpper,nBPLower,DeviationPlot);

CSTCoefficients = CSTCoeffUpper; %#ok<NASGU>
[xu,zu] = divideexplicit(@cstapproximation, 0, 1, N);
CSTCoefficients = CSTCoeffLower;
[xl,zl] = divideexplicit(@cstapproximation, 0, 1, N);


Airfoil{1} = xu;
Airfoil{2} = zu;
Airfoil{3} = xl;
Airfoil{4} = zl;


function z = cstapproximation(x)
global CSTCoefficients
        z = cstfoilsurf(x,CSTCoefficients);
 