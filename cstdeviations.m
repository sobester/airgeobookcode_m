function DevLower = cstdeviations(XTarget, ZTarget, CSTCoefficients)


% Create a very dense sample set for CST
DenseCST_X = [0:0.000001:0.1,0.1001:0.00001:1];
DenseCST_Z = cstfoilsurf(DenseCST_X, CSTCoefficients);

plot(DenseCST_X, DenseCST_Z,'g+')



 for i=1:length(XTarget)
     % Compute vector of distances
     DistVect = sqrt( (DenseCST_X(:)-XTarget(i)).^2 + (DenseCST_Z(:)-ZTarget(i)).^2 );
     [MinDist, MinInd] = min(DistVect);
     plot([XTarget(i), DenseCST_X(MinInd)],[ZTarget(i), DenseCST_Z(MinInd)], 'k');
     DevLower(i) = MinDist; %#ok<*AGROW>
 end
 
 
 Signs = 2*inpolygon(XTarget, ZTarget, DenseCST_X, DenseCST_Z)-1;


 if sum(ZTarget)<0
     % Lower surface of an airfoil
      DevLower = DevLower(:).*Signs(:);
 else
      DevLower = -DevLower(:).*Signs(:);
 end
 