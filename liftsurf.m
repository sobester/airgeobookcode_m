function LiftSurfGeometry = liftsurf(LiftSurfInput)

%LIFTSURF Generates a lifting surface (e.g., wing) geometry. 
%
%In order to fully define the geometry of the wing, LIFTSURF requires:
%
%   1. The spanwise variation of chord. This must be defined in a separate
%   function of the non-dimensional span station parameter (epsilon). Use 
%   this to define taper, trailing edge kinks and other unusual trailing
%   edge shapes. The name of the function should be specified in 
%   LiftSurfInput.Chord.Funct. Its inputs should be given in
%   LiftSurfInput.Chord.Parameters. Pre-defined functions and their
%   parameters are:
%       chord_parallell - []
%       chord_simpletaper - Taper Ratio
%       chord_doubletaper - [Taper Ratio 1, Taper Ratio 2, Kink Station]
%
%   2. The spanwise variation of the twist angle. This must be defined in a
%   separate function of the non-dimensional span station parameter (epsilon).
%   The name of the function should be specified in 
%   LiftSurfInput.Twist.Funct. Its inputs should be given in
%   LiftSurfInput.Twist.Parameters. Pre-defined functions and their
%   parameters are:
%       twist_linear - [setting angle (root), additional twist at tip]
%
%   3. The spanwise variation of the dihedral angle. This must be defined
%   in a separate function of a non-dimensional span station parameter 
%   (epsilon). The name of the function should be specified in 
%   LiftSurfInput.Dihedral.Funct. Its inputs should be given in
%   LiftSurfInput.Dihedral.Parameters. Pre-defined functions and their
%   parameters are:
%       dihedral_constant - [dihedral angle]
%       dihedral_unifloadbeam - [baseline dihedral, load factor]
%
%   4. The spanwise variation of the local sweep angle. This must be defined
%   in a separate function of the non-dimensional span station parameter
%   (epsilon). The name of the function should be specified in 
%   LiftSurfInput.Sweep.Funct. Its inputs should be given in
%   LiftSurfInput.Sweep.Parameters. Pre-defined functions and their
%   parameters are:
%       sweepangle_constant - [baseline sweep, winglet span ratio,
%                              winglet inflexion ratio, winglet sweep amplitude,
%                              root forward fillet ratio, 
%                              root forward fillet max additional sweep]
%
%   5. The spanwise variation of the wing cross-section. This must be defined
%   in a separate function of the non-dimensional span station parameter (epsilon).
%   LiftSurfInput.Airfoil.Funct should contain the name of the function,
%   with LiftSurfInput.Airfoil.Parameters specifying its input parameters
%   and LiftSurfInput.Airfoil.NPoints specifying the number of points that will
%   make up the airfoil. Pre-defined functions and their parameters are:
%       airfoil_linear - {'root airfoil',[root airfoil parameter vector],
%                         'tip airfoil',[tip airfoil parameter vector]}
%
%   6. At least two of: area, aspect ratio, span and internal volume.
%   LIFTSURF permits the definition of more than two, as well as a root
%   chord and a target wetted area, in which case weightings have to be
%   assigned to each variable and LIFTSURF will attempt to find a
%   compromise.
%
%   Note: the span station parameter epsilon should be regarded as distance
%   along a coordinate axis 'glued' to the wing. This allows the
%   specification of variables along the wing even if it curves upwards at
%   a 90 degree angle or more (winglet).
%
%   LiftSurfGeometry = liftsurf(LiftSurfInput)
%
%   The fields of the structure LiftSurfInput are:
%
%   Target... - target values for the parameters of the wing.
%   w...      - the weightings of these values, expressing the relative 
%             importance of reaching them. 
%   Epsilon   - vector of epsilon stations where cross sections are
%             computed
%   NPoints   - number of points making up each cross-section
%   LSPlotRequired - 1 if a 3d plot of the wing is required
%   STLFileName - the name of the stl file to be created (use [] if stl
%             file not required).
%   
%   Examples: to be found in the scripts BLENDEDWINGBODY and WINGBLEND. 
%
%   See also CHORDFUNCT, TWISTANGLEFUNCT, DIHEDRALFUNCT, SWEEPANGLEFUNCT, 
%   AIRFOILFUNCT.
% 
% -------------------------------------------------------------------------
% Aircraft Geometry Toolbox v0.1.0, Andras Sobester 2014.
%
% Sobester, A, Forrester, A I J, "Aircraft Aerodynamic Design - Geometry 
% and Optimization", Wiley, 2014.
% -------------------------------------------------------------------------


global  TA  TAR  TS  TV  TRC  TWA Eps
global wTA wTAR wTS wTV wTRC wTWA
global LSI


% Extract data from input structure

TargetArea = LiftSurfInput.TargetArea;
wTargetArea = LiftSurfInput.wTargetArea;

TargetAspectRatio = LiftSurfInput.TargetAspectRatio;
wTargetAspectRatio = LiftSurfInput.wTargetAspectRatio;

TargetSpan = LiftSurfInput.TargetSpan;
wTargetSpan = LiftSurfInput.wTargetSpan;

TargetVolume = LiftSurfInput.TargetVolume;
wTargetVolume = LiftSurfInput.wTargetVolume;

TargetRootChord = LiftSurfInput.TargetRootChord;
wTargetRootChord = LiftSurfInput.wTargetRootChord;

TargetWettedArea = LiftSurfInput.TargetWettedArea;
wTargetWettedArea = LiftSurfInput.wTargetWettedArea;

Epsilon = LiftSurfInput.Epsilon;

LSPlotRequired = LiftSurfInput.LSPlotRequired;

LiftsurfName = LiftSurfInput.Name;


TA  = abs(TargetArea);
TAR = abs(TargetAspectRatio);
TS  = abs(TargetSpan);
TV  = abs(TargetVolume);
TRC = abs(TargetRootChord);
TWA = abs(TargetWettedArea);

% Compute normalized weightings
wTotal = wTargetArea + wTargetAspectRatio + wTargetSpan +...
    wTargetVolume + wTargetRootChord + wTargetWettedArea;

wTA  =  abs(wTargetArea)/wTotal;
wTAR =  abs(wTargetAspectRatio)/wTotal;
wTS  =  abs(wTargetSpan)/wTotal;
wTV  =  abs(wTargetVolume)/wTotal;
wTRC =  abs(wTargetRootChord)/wTotal;
wTWA =  abs(wTargetWettedArea)/wTotal;

LSI = LiftSurfInput;


% Deal with zero targets
if TA==0, TA=1;  wTA=0;  end
if TAR==0,TAR=1; wTAR=0; end
if TS==0, TS=1;  wTS=0;  end
if TV==0, TV=1;  wTV=0;  end
if TRC==0,TRC=1; wTRC=0; end
if TWA==0,TWA=1; wTWA=0; end

Eps = Epsilon;

% Ensure the problem is not under-constrained
if sum([TA TAR TS TV]~=0) < 2
    error('At least 2 of S, AR, b or V are needed to define the wing.')
end

% A starting point for the search process
if TA*TAR > 0
    X0 = [2/TAR sqrt(TA*TAR)/2];
elseif TA == 0 || TAR == 0
    X0 = [ 1 TS/2];
end

FUN = @lsdiff;

display('Optimizing planform geometry...')
OptVec = fminsearch(FUN,X0);
% Some more optimization options below:
%   OptVec = ga(FUN,2,[],[],[],[],[0.1 10],[0.1 10],[],Options);
%   OptVec = fminsearch(FUN,OptVec,Options);

% % % Full search
%      Range1 = (0.25:0.01:0.4);
%      Range2 = (8:0.01:9);
%      for i=1:length(Range1)
%          disp([num2str(i),' of ',num2str(length(Range1))])
%          for j=1:length(Range2)
%              M(j,i) = feval(FUN,[Range1(i),Range2(j)]);
%          end
%      end
%   pcolor(Range1,Range2,M)


  
display('Planform optimization complete.')


OptChordFactor = OptVec(1);
OptScaleFactor = OptVec(2);


display('Building geometry...')
[LSurfX, LSurfY, LSurfZ,...
    LSAreaProjection, LSSpan, LSLELength, LSRootToTip, LSVolume,...
    LSAspectRatio, LSRootChord, LSWettedArea]=...
    liftsurfgen(LiftSurfInput, OptChordFactor, OptScaleFactor, Epsilon, LSPlotRequired, LiftsurfName, 'High');


% Lifting surface parameters
disp('LIFTING SURFACE GEOMETRY SUMMARY')
disp('--------------------------------')
disp(['Area.      Importance: ',num2str(wTA*100),'% Target: ',num2str(TA),' Actual: ',num2str(LSAreaProjection),' Abs.rel. error: ',num2str(100*abs(LSAreaProjection-TA)/ TA),'%'])
disp(['AR.        Importance: ',num2str(wTAR*100),'% Target: ',num2str(TAR),' Actual: ',num2str(LSAspectRatio) ,' Abs.rel. error: ',num2str(100*abs(LSAspectRatio  -TAR)/TAR),'%'])
disp(['Span.      Importance: ',num2str(wTS*100),'% Target: ',num2str(TS),' Actual: ',num2str(LSSpan) ,' Abs.rel. error: ',num2str(100*abs(LSSpan  -TS)/TS),'%'])
disp(['Volume.    Importance: ',num2str(wTV*100),'% Target: ',num2str(TV),' Actual: ',num2str(LSVolume),' Abs.rel. error: ',num2str(100*abs(LSVolume  -TV)/TV),'%'])
disp(['RootChord. Importance: ',num2str(wTRC*100),'% Target: ',num2str(TRC),' Actual: ',num2str(LSRootChord),' Abs.rel. error: ',num2str(100*abs(LSRootChord  -TRC)/TRC),'%'])
disp(['WettedArea.Importance: ',num2str(wTWA*100),'% Target: ',num2str(TWA),' Actual: ',num2str(LSWettedArea),' Abs.rel. error: ',num2str(100*abs(LSWettedArea  -TWA)/TWA),'%'])

disp('Geometry complete.')


% Package up lifting surface geometry into a structure
LiftSurfGeometry.X = LSurfX;
LiftSurfGeometry.Y = LSurfY;
LiftSurfGeometry.Z = LSurfZ;
LiftSurfGeometry.AreaProjection = LSAreaProjection;
LiftSurfGeometry.Span = LSSpan;
LiftSurfGeometry.LELength = LSLELength;
LiftSurfGeometry.RootToTip = LSRootToTip;
LiftSurfGeometry.Volume = LSVolume;
LiftSurfGeometry.AspectRatio = LSAspectRatio;
LiftSurfGeometry.RootChord = LSRootChord;
LiftSurfGeometry.WettedArea = LSWettedArea;

end
% END of function liftsurf





function diff = lsdiff(Vec)

global  TA  TAR  TS  TV  TRC  TWA Eps
global wTA wTAR wTS wTV wTRC wTWA
global LSI

[~, ~, ~,AreaProjection, Span, ~, ~,...
    WingVolume, AspectRatio, RootChord, WettedArea]=...
    liftsurfgen(LSI, Vec(1), Vec(2), Eps, 0, [],'Low');

diff = wTA*( abs(TA  - AreaProjection)/TA  )^2  + ...
      wTAR*( abs(TAR - AspectRatio   )/TAR )^2  + ...
       wTS*( abs(TS  -  Span         )/TS  )^2  + ...
       wTV*( abs(TV  -  WingVolume   )/TV  )^2  + ...
      wTRC*( abs(TRC - RootChord     )/TRC )^2  + ...
      wTWA*( abs(TWA - WettedArea    )/TWA )^2;
 
end
% END of function lsdiff



function [WingSurfX, WingSurfY, WingSurfZ,...
    AreaProjection, Span, LELength, RootToTip, WingVolume, AspectRatio,...
    RootChord, WettedArea]=...
    liftsurfgen(LiftSurfInput, ChordFactor, ScaleFactor, Epsilon, PlotRequired, LiftsurfName, Fidelity)


% Epsilon is the spanwise coordinate axis attached to wing leading edge
% (this is more useful than the y axis, as it allows winglets, etc.)

% The elements required to define each section
TwistAngle                = twistanglefunct(Epsilon,...
                                            LiftSurfInput.Twist.Funct,...
                                            LiftSurfInput.Twist.Parameters);
TiltAngle                 = dihedralfunct(LiftSurfInput.Dihedral.Funct,...
                                          LiftSurfInput.Dihedral.Parameters, Epsilon);
[XRef, YRef, ZRef]        = airfoilrefpoint(Epsilon,TiltAngle,...
                                            LiftSurfInput.Sweep.Funct,...
                                            LiftSurfInput.Sweep.Parameters);

% Reference points with baseline sweep only                                        
LiftSurfInputBSO = LiftSurfInput;
LiftSurfInputBSO.Sweep.Parameters(2:6) = 0;
[XRefBSO, ~, ~]         = airfoilrefpoint(Epsilon,TiltAngle,...
                                            LiftSurfInput.Sweep.Funct,...
                                            LiftSurfInputBSO.Sweep.Parameters);
                                        
Chord                     = ChordFactor*chordfunct(Epsilon,...
                                                   LiftSurfInput.Chord.Funct,...
                                                   LiftSurfInput.Chord.Parameters);

                           
                                               Chord = Chord - (XRef-XRefBSO);                                              
                                               
                                               
Airfoils                  = airfoilfunct(Epsilon,...
                                            LiftSurfInput.Airfoil.NPoints,...
                                            Fidelity,...
                                            LiftSurfInput.Airfoil.Funct,...
                                            LiftSurfInput.Airfoil.Parameters);


RootChord = Chord(1)*ScaleFactor;

StepLength = zeros(1,length(YRef)-1);
for i=1:length(YRef)-1
    StepLength(i) = YRef(i+1)-YRef(i);
end

% Array pre-allocation
XDim = length(Airfoils{1}{1})+length(Airfoils{1}{3});
ES = size(Epsilon);
LEProjectionX = zeros(ES);
LEProjectionY = zeros(ES);
TEProjectionX = zeros(ES);
TEProjectionY = zeros(ES);
LEZ = zeros(ES);
FoilArea = zeros(ES);
FoilPerimeter = zeros(ES);
WingSurfX = zeros(length(Epsilon),XDim);
WingSurfY = zeros(length(Epsilon),XDim);
WingSurfZ = zeros(length(Epsilon),XDim);


WingSectionsX = zeros(length(Epsilon),XDim);
WingSectionsZ = zeros(length(Epsilon),XDim);


for i=1:length(Epsilon)
    
    [XUpper,YUpper,ZUpper,...
        XLower,YLower,ZLower,...
        FoilArea(i), FoilPerimeter(i),...
        XUpperOriginal,...
        ZUpperOriginal,...
        XLowerOriginal,...
        ZLowerOriginal] = ...
        liftsurfsection(Airfoils{i},...
        Chord(i),...
        YRef(i), XRef(i), ZRef(i),...
        TwistAngle(i),...
        TiltAngle(i));
    
    % Scale up the non-dimensional wing
    XUpper  =   XUpper*ScaleFactor;
    YUpper  =   YUpper*ScaleFactor;
    ZUpper  =   ZUpper*ScaleFactor;
    XLower  =   XLower*ScaleFactor;
    YLower  =   YLower*ScaleFactor;
    ZLower  =   ZLower*ScaleFactor;
    
    
    XUpperOriginal  =   XUpperOriginal*ScaleFactor;
    ZUpperOriginal  =   ZUpperOriginal*ScaleFactor;
    XLowerOriginal  =   XLowerOriginal*ScaleFactor;
    ZLowerOriginal  =   ZLowerOriginal*ScaleFactor;
    
    
    if i==length(Epsilon)
        TipX = XUpper(1);
        TipY = YUpper(1);
        TipZ = ZUpper(1);
    end
    
    % LE and TE point projections onto the xy plane
    LEProjectionX(i) = XUpper(1);
    TEProjectionX(i) = XUpper(end);
    LEProjectionY(i) = YUpper(1);
    TEProjectionY(i) = YUpper(end);
    LEZ(i) = ZUpper(1);
    
    WingSurfX(i,:) = [XLower(end);XUpper(end:-1:2);XLower]';
    WingSurfY(i,:) = [YLower(end);YUpper(end:-1:2);YLower]';
    WingSurfZ(i,:) = [ZLower(end);ZUpper(end:-1:2);ZLower]';
    
    WingSectionsX(i,:) = [XLowerOriginal(end);XUpperOriginal(end:-1:2);XLowerOriginal]';
    WingSectionsZ(i,:) = [ZLowerOriginal(end);ZUpperOriginal(end:-1:2);ZLowerOriginal]';
    
end


WingVolume = sum(StepLength.*FoilArea(1:end-1))*ScaleFactor^3;
WettedArea = sum(StepLength.*FoilPerimeter(1:end-1))*ScaleFactor^2;

% Projected wing area calculation
AreaProjection = 0; LELength = 0;
for i = 1:length(LEProjectionX)-1
    AreaProjection = AreaProjection + ...
        polyarea([LEProjectionX(i) ...
        TEProjectionX(i) ...
        TEProjectionX(i+1)...
        LEProjectionX(i+1)],...
        [LEProjectionY(i) ...
        TEProjectionY(i) ...
        TEProjectionY(i+1)...
        LEProjectionY(i+1)]);
    LEPi = [LEProjectionX(i), LEProjectionY(i), LEZ(i)];
    LEPip1 = [LEProjectionX(i+1), LEProjectionY(i+1), LEZ(i+1)];
    LELength = LELength + sum((LEPi-LEPip1).^2).^0.5;
end

Span = 2*TipY;

AspectRatio = Span^2/(2*AreaProjection);

RootToTip = sum([TipX,TipY,TipZ].^2).^0.5;


% Saving / plotting =======================================================


% 1. 3D Matlab surface plot
if sum(ismember(1,PlotRequired)) > 0
    xlabel('x');ylabel('y');zlabel('z');
    surf(WingSurfX, WingSurfY, WingSurfZ,ones(size(WingSurfZ)));
    hold on
    surf(WingSurfX, -WingSurfY, WingSurfZ,ones(size(WingSurfZ)));
    axis equal
    title(LiftsurfName)
end


% 2. Sections saved in text files in a folder
if sum(ismember(2,PlotRequired)) > 0
    if ~exist(LiftsurfName,'dir')
        mkdir(LiftsurfName);
    end
    for i=1:size(WingSurfX,1)
        % For each section
        WS = [WingSurfX(i,2:end)' WingSurfY(i,2:end)' WingSurfZ(i,2:end)']; %#ok<NASGU>
        save([LiftsurfName,'\section',num2str(i),'.txt'],'WS','-ascii');
        WS2d = [WingSectionsX(i,2:end)' WingSectionsZ(i,2:end)']; %#ok<NASGU>
        save([LiftsurfName,'\section2d',num2str(i),'.txt'],'WS2d','-ascii');
    end        
end


% 3. Save STL (stereolitography) file
if sum(ismember(3,PlotRequired)) > 0
    if ~isempty(LiftsurfName)
        STLFileName = [LiftsurfName, '.stl'];
        disp(['Generating STL file ',STLFileName]);
        surf2stl(STLFileName,WingSurfX, WingSurfY, WingSurfZ);
    end
end

end
% ===== End of liftsurfgen ================================================