          

Airfoil = nearestsc2(0.7, 14, 'low', 0, 1);          
nBPUpper = 4; nBPLower = 5;
[CSTCoeffUpper,CSTCoeffLower] = findcstcoeff(Airfoil,nBPUpper,nBPLower,1);
  