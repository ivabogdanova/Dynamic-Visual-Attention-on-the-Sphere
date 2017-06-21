function [lowP,hiP] = LapPyrSf(in,NLEV,filter)
%
% Spherical Laplacian Pyramid
% in - signal
% NLEV - number of levels (WARNING: not fully under control!)

for k=1:NLEV
    % Filter and Dowmsample
    lowP = SLpDf(in,filter);
    % Upsample and Filter / Predict
    temp = SLpUf(lowP,filter);
    hiP{k} = in - temp;
    in = lowP;
end