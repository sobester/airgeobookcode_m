% A cross section geometry similar to that of the MD-80/90/B737 family
% (Figure 2.5)

if exist('COMTANON','var')
    COMTANON = 0;
end

B737f = [0.46  0.5  0.5  1   0.47  0.5  0.5  1];

doublelobebasic(fillz(100),B737f,1,1);