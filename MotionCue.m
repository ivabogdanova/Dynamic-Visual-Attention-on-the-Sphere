function out = MotionCue(s1,s2,i,gamma);
%
% funcrion that calculates the motion conspicuity map based on a motion
% pyramid.
%
% INPUT:
%       s1,s2: spherical images (MxNx3)
%       i - output frame counter
%       gamma - parameter for exponential normalization /( =1.5
%
% OUTPUT: 
% out - the motion conspicuity map (phase+ amplitude)
% 
% external programs used:   MotionMap_s2.m
%                           SLpU.m
%
% Iva Bogdanova
% November, 2008


% -----Motion pyramid------
Mvec_256 = MotionMap_s2(s1,s2,4,8);
Mvec_128 = MotionMap_s2(s1,s2,8,8);
Mvec_64 = MotionMap_s2(s1,s2,16,16);
Mvec_32 = MotionMap_s2(s1,s2,32,32);
Mvec_16 = MotionMap_s2(s1,s2,64,16);


% extraction of the PHI and THETA for each of the levels
% resolution 256
level2_theta = Mvec_256(:,:,1)';    
level2_phi = Mvec_256(:,:,2)';

% resolution 128
level3_theta = Mvec_128(:,:,1)'; 
level3_phi = Mvec_128(:,:,2)';

% resolution 64
level4_theta = Mvec_64(:,:,1)'; 
level4_phi = Mvec_64(:,:,2)';

%resolution 32
level5_theta = Mvec_32(:,:,1)'; 
level5_phi = Mvec_32(:,:,2)';

%resolution 16
level6_theta = Mvec_16(:,:,1)'; 
level6_phi = Mvec_16(:,:,2)';


% % motion magitude
ampl2 = sqrt(level2_theta.^2 + level2_phi.^2);
ampl3 = sqrt(level3_theta.^2 + level3_phi.^2);
ampl4 = sqrt(level4_theta.^2 + level4_phi.^2);
ampl5 = sqrt(level5_theta.^2 + level5_phi.^2);
ampl6 = sqrt(level6_theta.^2 + level6_phi.^2);

% % motion phase
 level2 = atan2(level2_theta,level2_phi);
 level3 = atan2(level3_theta,level3_phi);
 level4 = atan2(level4_theta,level4_phi);
 level5 = atan2(level5_theta,level5_phi);
 level6 = atan2(level6_theta,level6_phi);



% %%%%%%%%%%%%%%%-----CENTER SURROUND on motion PHASE----%%%%%%%%%%%%%%%%%%

% upsample level 5 to level 2
L5_u2 = SLpU(SLpU(SLpU(level5)));

% center surround difference
d25 = level2 - L5_u2;
if (d25 >= pi)
    d25 = 2*pi - d25;
end

%M25 = abs(level2) - abs(L5_u2);
M25 = abs(d25);
%M25(M25 < 0) = 0.0;

% Upsample cmap25 to level 1 ----> (1 level up)
M25_u = SLpU(M25);

%compute the weighting coeff
map25_phase = exponential_norm(M25_u,gamma);


% ------L2-L6-----
% upsample level 6 to level 2
L6_u2 = SLpU(SLpU(SLpU(SLpU(level6))));

% center surround difference
d26 = level2 - L6_u2;
if (d26 >= pi)
    d26 = 2*pi - d26;
end
%M26 = abs(level2) - abs(L6_u2);
M26 = abs(d26);
%M26(M26 < 0) = 0.0;

% Upsample cmap25 to level 1 ----> (1 level up)
M26_u = SLpU(M26);
                                                      
%compute the weighting coeff
map26_phase = exponential_norm(M26_u,gamma);



%--------- L3-L6 at scale 3------------

% upsample level 6 to level 3
L6_u3 = SLpU(SLpU(SLpU(level6)));

% center surround difference
d36 = level3 - L6_u3;
if (d36 >= pi)
    d36 = 2*pi - d36;
end
%M36 = abs(level3) - abs(L6_u3);
M36 = abs(d36);
%M36(M36 < 0) = 0.0;

% Upsample cmap63 to level 1  ----> (2 levels up)
M36_uu = SLpU(SLpU(M36));  

%compute the weighting coeff
map36_phase = exponential_norm(M36_uu,gamma);

map36_phase(map36_phase ==NaN) = 0;


% -------PHASE conspicuity map at resolution 512 (level 1)----------
motion_cue_phase = map25_phase + map26_phase + map36_phase;

out_phase = abs(motion_cue_phase);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% %%%%%%%%%%%%%%%-----CENTER SURROUND on motion AMPLITUDE----%%%%%%%%%%%%%%%%%%

% upsample level 5 to level 2
aL5_u2 = SLpU(SLpU(SLpU(ampl5)));

% center surround difference
a25 = ampl2 - aL5_u2;

aM25 = abs(a25);

% Upsample cmap25 to level 1 ----> (1 level up)
aM25_u = SLpU(aM25);

%compute the weighting coeff
map25_amplitude = exponential_norm(aM25_u,gamma);


% ------L2-L6-----
% upsample level 6 to level 2
aL6_u2 = SLpU(SLpU(SLpU(SLpU(ampl6))));

% center surround difference
a26 = ampl2 - aL6_u2;

aM26 = abs(a26);

% Upsample cmap25 to level 1 ----> (1 level up)
aM26_u = SLpU(aM26);
                                                      
%compute the weighting coeff
map26_amplitude = exponential_norm(aM26_u,gamma);



%--------- L3-L6 at scale 3------------

% upsample level 6 to level 3
aL6_u3 = SLpU(SLpU(SLpU(ampl6)));

% center surround difference
a36 = ampl3 - aL6_u3;

aM36 = abs(a36);

% Upsample cmap63 to level 1  ----> (2 levels up)
aM36_uu = SLpU(SLpU(aM36));  

%compute the weighting coeff
map36_amplitude = exponential_norm(aM36_uu,gamma);

map36_amplitude(map36_amplitude == NaN) = 0;


% -------AMPLITUDE conspicuity map at resolution 512 (level 1)----------
motion_cue_amplitude = map25_amplitude + map26_amplitude + map36_amplitude;

out_amplitude = abs(motion_cue_amplitude);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%----------final MOTION conspicuity map -------%

%out = exponential_norm(out_phase,gamma) + exponential_norm(out_amplitude,gamma);
out = exponential_norm(out_amplitude,gamma);    % motion amplitude/phase  only




