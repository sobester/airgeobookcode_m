% WINGBLEND is an example script illustrating the use of the liftsurf
% function. It generates a wing with a wing-to-fuselage type blend at the 
% root. The output is available as a Matlab surface or (using Bill 
% McDonald's surf2stl function) as an STL file. 
% -------------------------------------------------------------------------
% Aircraft Geometry Toolbox v0.1.0, Andras Sobester 2014.
%
% Sobester, A, Forrester, A I J, "Aircraft Aerodynamic Design - Geometry 
% and Optimization", Wiley, 2014.
% -------------------------------------------------------------------------


% ========= LiftSurfInput definition

LiftSurfInput.Name = 'wingblend';

LiftSurfInput.LSPlotRequired = [1 3];

LiftSurfInput.TargetArea = 16;
LiftSurfInput.wTargetArea = 1;

LiftSurfInput.TargetAspectRatio = 10;
LiftSurfInput.wTargetAspectRatio = 1;

LiftSurfInput.TargetSpan = 14;
LiftSurfInput.wTargetSpan = 0;

LiftSurfInput.TargetVolume = 0;
LiftSurfInput.wTargetVolume = 0;

LiftSurfInput.TargetRootChord = 0;
LiftSurfInput.wTargetRootChord = 0;

LiftSurfInput.TargetWettedArea = 0;
LiftSurfInput.wTargetWettedArea = 0;

LiftSurfInput.Epsilon = [0:0.01:0.05,0.05+1/15:(1-0.05)/15: 1];

LiftSurfInput.Dihedral.Funct = 'dihedral_unifloadbeam';
LiftSurfInput.Dihedral.Parameters = [15 -0.05  0 0];

LiftSurfInput.Sweep.Funct = 'sweepangle_constant';
LiftSurfInput.Sweep.Parameters = [25 0 0 0 0.05 60];

LiftSurfInput.Twist.Funct = 'twistangle_linear';
LiftSurfInput.Twist.Parameters = [0 15];
 
LiftSurfInput.Chord.Funct = 'chord_simpletaper_rootfillet';
LiftSurfInput.Chord.Parameters = [0.3 0.05 0.1];

LiftSurfInput.Airfoil.Funct = 'airfoil_linear';
LiftSurfInput.Airfoil.Parameters = {'supercrit',[0.7, 12],'supercrit',[0.4, 12], 0.05, 1.3};

LiftSurfInput.Airfoil.NPoints = 50;


% ========= liftsurf call

LiftSurfGeometry = liftsurf(LiftSurfInput);
         
