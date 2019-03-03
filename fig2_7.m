% B747 forward fuselage style cross section geometry (Figure 2.7)

if exist('COMTANON','var')
    COMTANON = 1; %#ok<GPFST>
else
    global COMTANON %#ok<TLEV>
    COMTANON = 1;
end

B747f = [0.4  0.5  0.5  1   0.28  0.5  0.5  1];

doublelobebasic(fillz(100),B747f,1,1);
