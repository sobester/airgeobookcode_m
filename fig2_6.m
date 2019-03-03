% A cross section geometry similar to that of the wing-to-body fairing
% section of an Embraer 145 (Figure 2.6)

if exist('COMTANON','var')
    COMTANON = 0;
end

wtbfmax = [  0.4   0.12   0.5    0.65    0.411  0.5   0.5      1];

doublelobebasic(fillz(100),wtbfmax,1,1);