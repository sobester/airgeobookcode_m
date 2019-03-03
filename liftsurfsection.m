function [XUpper,YUpper,ZUpper,...
          XLower,YLower,ZLower,...
          FoilArea, FoilPerimeter,...
          XUpperOriginal,...
          ZUpperOriginal,...
          XLowerOriginal,...
          ZLowerOriginal] = ...
    liftsurfsection(Airfoil, Chord,...
                    SpanwiseLoc, StreamwiseLoc, VerticalLoc,...
                    TwistAngle, DihedralAngle)
                           
% Copyright: A. Sobester 2011

% Basic airfoil, chord = [0,1]
XUpper = Airfoil{1};
ZUpper = Airfoil{2};
XLower = Airfoil{3};
ZLower = Airfoil{4};

% Chord scaling
XUpper = XUpper*Chord;
ZUpper = ZUpper*Chord;
XLower = XLower*Chord;
ZLower = ZLower*Chord;



% Compute the airfoil cross sectional area
FoilArea = polyarea(XUpper,ZUpper) + polyarea(XLower,ZLower);


% Compute the perimeter of the airfoil
FoilPerimeter = 0;
for i=1:length(XUpper)-1
    FoilPerimeter = FoilPerimeter + ...
        sqrt((XUpper(i+1)-XUpper(i))^2 + (ZUpper(i+1)-ZUpper(i))^2);
end
for i=1:length(XLower)-1
    FoilPerimeter = FoilPerimeter + ...
        sqrt((XLower(i+1)-XLower(i))^2 + (ZLower(i+1)-ZLower(i))^2);
end


% Rotate the airfoil around the LE by the twist angle
[theta,rho] = cart2pol(XUpper,ZUpper);
[XUpper, ZUpper] = pol2cart(theta + TwistAngle*pi/180,rho);
[theta,rho] = cart2pol(XLower,ZLower);
[XLower, ZLower] = pol2cart(theta + TwistAngle*pi/180,rho);



% The original, scaled airfoil, before rotation, translation, etc.
XUpperOriginal = XUpper;
ZUpperOriginal = ZUpper;
XLowerOriginal = XLower;
ZLowerOriginal = ZLower;



% Rotate the airfoil around a line parallel with the x axis
% at its maximum z-coordinate point

% Drop the airfoil down so that the max point is on the x axis
MaxZ = max(ZUpper);
ZUpper = ZUpper - MaxZ;
ZLower = ZLower - MaxZ;
YUpper = zeros(size(XUpper));
YLower = zeros(size(XLower));

% Now rotate each point in the Z-Y plane
[theta,rho] = cart2pol(YUpper,ZUpper);
[YUpper, ZUpper] = pol2cart(theta + DihedralAngle*pi/180,rho);
[theta,rho] = cart2pol(YLower,ZLower);
[YLower, ZLower] = pol2cart(theta + DihedralAngle*pi/180,rho);

% Translate the airfoil back with its LE at the origin
XUpper = XUpper - XUpper(1);
YUpper = YUpper - YUpper(1);
ZUpper = ZUpper - ZUpper(1);
XLower = XLower - XLower(1);
YLower = YLower - YLower(1);
ZLower = ZLower - ZLower(1);

% Translate it streamwise
XUpper = XUpper + StreamwiseLoc;
XLower = XLower + StreamwiseLoc;

% Translate it vertically
ZUpper = ZUpper + VerticalLoc;
ZLower = ZLower + VerticalLoc;

% Translate it spanwise
YUpper = YUpper + SpanwiseLoc;
YLower = YLower + SpanwiseLoc;