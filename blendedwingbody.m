% BLENDEDWINGBODY is an example script illustrating the use of the liftsurf
% function. It generates a wing and a blended centrebody. The output is
% available as a Matlab surface or (using Bill McDonald's surf2stl
% function) as an STL file. 
% -------------------------------------------------------------------------
% Aircraft Geometry Toolbox v0.1.0, Andras Sobester 2014.
%
% Sobester, A, Forrester, A I J, "Aircraft Aerodynamic Design - Geometry 
% and Optimization", Wiley, 2014.
% -------------------------------------------------------------------------

Span = 3.5;
FuselageWidth = 0.2;
FuselageHeight = 0.24;

% ========= LiftSurfInput definition

LiftSurfInput.Name = 'blendedwingbody';

% Generate plot (1) and STL file (3), but not cross section txt files (2)
LiftSurfInput.LSPlotRequired = [1 3];

LiftSurfInput.TargetArea = 0.9;
LiftSurfInput.wTargetArea = 1;

LiftSurfInput.TargetAspectRatio = 8.9;
LiftSurfInput.wTargetAspectRatio = 0;

LiftSurfInput.TargetSpan = 3.5;
LiftSurfInput.wTargetSpan = 1;

LiftSurfInput.TargetVolume = 0;
LiftSurfInput.wTargetVolume = 0;

LiftSurfInput.TargetRootChord = 1;
LiftSurfInput.wTargetRootChord = 1;

LiftSurfInput.TargetWettedArea = 0;
LiftSurfInput.wTargetWettedArea = 0;

LiftSurfInput.Epsilon = [0:0.005:0.3,0.5:0.1:1];

% Fuselage side station is included
FuselageSide = FuselageWidth/Span;

LiftSurfInput.Dihedral.Funct = 'dihedral_unifloadbeam';
LiftSurfInput.Dihedral.Parameters = [0 0 0 0];

LiftSurfInput.Sweep.Funct = 'sweepangle_fuselage';
LiftSurfInput.Sweep.Parameters = [1.88 0 0 0 0.25 90 FuselageSide-0.01];

LiftSurfInput.Twist.Funct = 'twistangle_linear';
LiftSurfInput.Twist.Parameters = [-3 -3];
 
LiftSurfInput.Chord.Funct = 'chord_simpletaper_rootfillet_fuselage';
LiftSurfInput.Chord.Parameters = [0.51 0 0 0];

LiftSurfInput.Airfoil.Funct = 'airfoil_linear_fuselage';
LiftSurfInput.Airfoil.Parameters = {'NACA5',[0.3, 0.15, 15],'NACA5',[0.3, 0.15, 15], 0.2, 0.2};

LiftSurfInput.Airfoil.NPoints = 100;

% ========= liftsurf call
LiftSurfGeometry = liftsurf(LiftSurfInput);
         
