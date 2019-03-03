function Chord = chord_parallell(~, Epsilon)
%CHORD_PARALLELL Generate chords for wing with LE parallell with TE.
%   Returns the same chord length for the entire span.
%   INPUTS: DihedralParameters - []
%           Epsilon - vector of spanwise stations (along the
%           non-dimensional spanwise variable Epsilon).
%   OUTPUT: Chord - vector (same length as Epsilon) of spanwise chord
%           lengths.
Chord = ones(size(Epsilon));