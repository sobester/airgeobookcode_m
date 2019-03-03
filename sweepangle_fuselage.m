function SweepAngle = sweepangle_fuselage(SweepParameters, Epsilon)
%SWEEPANGLE_CONSTANT Straight swept leading edge.
%   Returns the wing spanwise slope angle vector corresponding to a basic,
%   spanwise constant dihedral angle. DihedralParameters is simply that
%   constant dihedral angle in this case. Use this as a template for
%   user-defined dihedral functions.
%   INPUTS: SweepParameters - sweep angle (constant along the span)
%           Epsilon - vector of spanwise stations (along the
%           non-dimensional spanwise variable Epsilon).
%   OUTPUT: SweepAngle - vector (same length as Epsilon) of spanwise
%           leading edge sweep angles.



BaselineSweep = SweepParameters(1);
WingletSpanRatio = SweepParameters(2);
WingletInflexionRatio = SweepParameters(3);
WingletSweepAmplitude = SweepParameters(4);
RootFwdFilletRatio = SweepParameters(5);
RootFwdFilletMaxAdditionalSweep = SweepParameters(6);
FuselageSide = SweepParameters(7);

% Baseline sweep
SweepAngle = BaselineSweep*ones(size(Epsilon));
BaseEpsilon =  Epsilon;

% Winglet / wingtip rake
if WingletSpanRatio > 0
    
    i1 = 1;
    while Epsilon(i1) < WingletSpanRatio, i1 = i1 + 1; end
    
    % Reset Epsilon datum to the start of the winglet
    Epsilon = Epsilon - Epsilon(i1);
    Epsilon(1:i1-1) = 0;
    i2 = i1;
    
    
    while Epsilon(i2) < (1-WingletSpanRatio)*WingletInflexionRatio,  i2 = i2 + 1; end
    Epsilon(i2+1:end) = 0;
    
    % Epsilon(i1) ---> 0
    % Epsilon(i2) ---> 2pi
    
    SweepAngle = SweepAngle + (sin(2*pi*Epsilon/Epsilon(i2)-pi/2)+1)*WingletSweepAmplitude;
    
end


%Root fillet

if RootFwdFilletRatio > 0
 
    Epsilon = BaseEpsilon;
    
    AddSweep = ((RootFwdFilletRatio - (Epsilon-FuselageSide))/RootFwdFilletRatio)*RootFwdFilletMaxAdditionalSweep;
    
    AddSweep(Epsilon > RootFwdFilletRatio + FuselageSide) = 0;
    
    %AddSweep(Epsilon < FuselageSide) = 0;
    
    AddSweep(Epsilon < FuselageSide) = 90*(Epsilon(Epsilon < FuselageSide)/FuselageSide).^2;
    
    SweepAngle = SweepAngle + AddSweep;
    
end
    







