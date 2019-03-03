function [XRef, YRef, ZRef] = airfoilrefpoint(Epsilon, TiltAngle, Funct, Parameters)
% AIRFOILREFPOINT Leading edge point location. Internal function.

SweepAngle = sweepanglefunct(Funct, Parameters, Epsilon);

% Root section LE always in the origin
XRef  = zeros(size(Epsilon));
YRef  = zeros(size(Epsilon));
ZRef = zeros(size(Epsilon));


SegmentLength = zeros(1,length(Epsilon)-1);
for i=1:length(Epsilon)-1
    SegmentLength(i) = Epsilon(i+1) - Epsilon(i);
end

XRef(1) = 0;
YRef(1) = 0;
ZRef(1) = 0;

for i=2:length(Epsilon)
    XRef(i)  = XRef(i-1)  + SegmentLength(i-1)*cos(TiltAngle(i-1) *pi/180)*...
                                                   sin(SweepAngle(i-1)*pi/180);
    YRef(i)  = YRef(i-1)  + SegmentLength(i-1)*cos(TiltAngle(i-1) *pi/180)*...
                                                   cos(SweepAngle(i-1)*pi/180);
    ZRef(i)  = ZRef(i-1)   + SegmentLength(i-1)*sin(TiltAngle(i-1)*pi/180);
end

