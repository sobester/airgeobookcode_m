function [Airfoil,varargout] = airfoilgen(AirfoilType,Fidelity,NP,varargin)
%AIRFOILGEN Generates airfoil coordinate sets
%
%   AIRFOILGEN(AirfoilType,Fidelity,NP,varargin) Generates two coordinate 
%   sets correponding to the upper surface (xu, zu) and the lower surface
%   (xl,zl) of an airfoil, packaged as the cell array Airfoil={xu,zu,xl,zl}. 
%   This function is, essentially, a generic gateway to several parametric
%   airfoil definition functions: NACA4, NACA5, CST, CS(2) and parametric
%   supercritical. The exact input arguments depend on the type of airfoil
%   formulation specified. See below for details. 
%
% INPUTS: 
% AirfoilType, Fidelity ('High' or 'Low'), NP (number of points per surface)
% plus further inputs depending on the type of airfoil.
%
% Permitted values of AirfoilType and the required further inputs:
%
% 'NACA4' - NACA 4-digit airfoil
%         - Additional inputs:
%               MaxCamberPercChord
%               MaxCamberLocTenthChord
%               MaxThicknessPercChord
%
%
% 'NACA5' - NACA 5-digit airfoil
%         - Additional inputs:
%               DesignLiftCoefficient
%               MaxCamberLocFracChord (between 0.05 and 0.25)
%               MaxThicknessPercChord (percentage)
%         EXAMPLES:
%         The 'originals', as per Jacobs and Pinkerton (1935):
%         naca5(0.3, 0.05, 12, 'High', 100, 1 ) - NACA 21012
%         naca5(0.3, 0.10, 12, 'High', 100, 1 ) - NACA 22012
%         naca5(0.3, 0.15, 12, 'High', 100, 1 ) - NACA 23012
%         naca5(0.3, 0.20, 12, 'High', 100, 1 ) - NACA 24012
%         naca5(0.3, 0.25, 12, 'High', 100, 1 ) - NACA 25012
%
%
% 'SC2'   - NASA SC(2) supercritical airfoil
%         - Additional inputs:
%               DesignCL
%               ThicknessToChord (%)
%         - Additional outputs:
%               ActualDesignCL
%               ActualThicknessToChord (%)
%         Note: the function will return the SC(2) airfoil that is the most
%         similar to what is required
%
%
% 'SUPERCRIT' - supercritical airfoil with a given design lift coefficient
%         (in the range [0.4 0.7]) and thickness to chord ratio (in the
%         range [10 12] percent).
%         - additional inputs:
%                DesignCL
%                ThicknessToChord (%)
% (see Sobester, A and Powell, S (2013) "Design space dimensionality reduction
% through physics-based geometry re-parameterization", Optimization and Engineering,
% 14(1):37-59. (doi:10.1007/s11081-012-9189-z))
%
%         EXAMPLE: generate and plot a range of supercritical airfoils
%         with CLs between 0.4 and 0.7 at a t/c of 10.5%
%
%         TC = 10.5;
%         for CL = 0.4:0.05:0.7
%           Airfoil = airfoilgen('supercrit', 'High', 120, CL, TC);
%           col = rand(1,3);
%           plot(Airfoil{1},Airfoil{2},'Color',col),hold on,...
%           plot(Airfoil{3},Airfoil{4},'Color',col), axis equal
%         end
%
%
%         
% 'CST'   - Class- and Shape function Transformation airfoil
%         - Additional inputs:
%               CSTCoefficientsUpper
%               CSTCoefficientsLower
%
%         % EXAMPLE: Find CST coefficients of SC(2)-0714...
% 
%  
%           Airfoil = nearestsc2(0.7, 14, 'High', 100, 0);
%           plot(Airfoil{1},Airfoil{2},'g+'),hold on, plot(Airfoil{3},Airfoil{4},'go'), axis equal
%   
%           nBPUpper = 6; nBPLower = 7;
%   
%           [CSTCoeffUpper,CSTCoeffLower] = findcstcoeff(Airfoil,nBPUpper,nBPLower,0);
%   
%           % ...and modify them slightly
%           CSTCoeffUpper(1) = CSTCoeffUpper(1)*1.25;
%           AirfoilType = 'cst';
%           NewAirfoil = airfoilgen(AirfoilType, 'High', 100, CSTCoeffUpper,CSTCoeffLower, 1);
%              
%           plot(NewAirfoil{1},NewAirfoil{2},'ro'),hold on, plot(NewAirfoil{3},NewAirfoil{4},'b+'), axis equal
%  
% -------------------------------------------------------------------------
% Aircraft Geometry Toolbox v0.1.0, Andras Sobester 2014.
%
% Sobester, A, Forrester, A I J, "Aircraft Aerodynamic Design - Geometry 
% and Optimization", Wiley, 2014.
% -------------------------------------------------------------------------


% Deal with the case when several of the additional parameters are received
% as part of a vector, as opposed to comma separated arguments

if nargin >= 4 && iscell(varargin{1})
    VecLen =  length(cell2mat(varargin{1}));
    InpVec = cell2mat(varargin{1});
    if VecLen > 1
        for i=1:VecLen
            varargin{i} = InpVec(i);
        end
    end
end


switch lower(AirfoilType)

    case 'naca4'
        Airfoil = naca4(varargin{1}, varargin{2}, varargin{3},...
            Fidelity, NP, 0);       
    % end NACA4 case
    
    
    case 'naca5'
        Airfoil = naca5(varargin{1}, varargin{2}, varargin{3},...
            Fidelity, NP, 0);       
    % end NACA5 case
    
    
    case 'sc2'
        [Airfoil, ActualDesignCL, ActualThicknessToChord] = ...
         nearestsc2(varargin{1}, varargin{2}, Fidelity, NP);
        varargout(1) = ActualDesignCL;
        varargout(2) = ActualThicknessToChord;
    % end SC2 case
    
    case 'cst'
        if strcmpi(Fidelity,'high')
            [xu, zu] = uniformcstfoilsurf(varargin{1}, NP);
            [xl, zl] = uniformcstfoilsurf(varargin{2}, NP);
        else
            [xu, zu] =    fastcstfoilsurf(varargin{1}, NP);
            [xl, zl] =    fastcstfoilsurf(varargin{2}, NP);
        end
        Airfoil{1} = xu(:);
        Airfoil{2} = zu(:);
        Airfoil{3} = xl(:);
        Airfoil{4} = zl(:);
    % end CST case
    
    case 'supercrit'
        Airfoil = supercrit1012(varargin{1},varargin{2},Fidelity,NP);
    % end CST case
        
    otherwise
        warning('Unknown airfoil type in airfoilgen.') %#ok<WNTAG>
        Airfoil = {};
end


