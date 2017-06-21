function out = MotionCue(s1,s2,i,gamma);
%
% funcrion that calculates the motion conspicuity map starting form the
% motion field defined at resolution 256, i.e. blocksize=4 and search
% window=16 on image sequence with number of frames i.
%
% INPUT:
%       s1,s2: spherical images (MxNx3)
%       i - output frame counter
%
% OUTPUT: 
% out - the motion conspicuity map
% 
% external programs used:   MotionMap_s2.m
%                           SLpU.m
%
% Iva Bogdanova
% March, 2008


% -----MV at 256------
Mvec_256 = MotionMap_s2(s1,s2,4,8);

%move_theta = theta_256';
%move_phi = phi_256';

Mvec_128 = MotionMap_s2(s1,s2,8,8);
Mvec_64 = MotionMap_s2(s1,s2,16,16);
Mvec_32 = MotionMap_s2(s1,s2,32,32);
Mvec_16 = MotionMap_s2(s1,s2,64,16);

%figure; imagesc(mag_motion); colorbar; title('motion magnitude at level
%256');

% gaussian pyramid on the motion magnitude
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
% level2 = sqrt(level2_theta.^2 + level2_phi.^2);
% level3 = sqrt(level3_theta.^2 + level3_phi.^2);
% level4 = sqrt(level4_theta.^2 + level4_phi.^2);
% level5 = sqrt(level5_theta.^2 + level5_phi.^2);
% level6 = sqrt(level6_theta.^2 + level6_phi.^2);

% % motion phase
 level2 = atan2(level2_theta,level2_phi);
 level3 = atan2(level3_theta,level3_phi);
 level4 = atan2(level4_theta,level4_phi);
 level5 = atan2(level5_theta,level5_phi);
 level6 = atan2(level6_theta,level6_phi);



% -----CENTER SURROUND on motion------

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
map25 = exponential_norm(M25_u,gamma);


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
map26 = exponential_norm(M26_u,gamma);



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
map36 = exponential_norm(M36_uu,gamma);

map36(map36 ==NaN) = 0;





% -------SALIENCY map at resolution 512 (level 1)----------
motion_cue = map25 + map26 + map36;

%motion_cue_255 = gray2ind(abs(motion_cue),255); % put the values beteen
%1-255
%figure; yashow(motion_cue_255,'cmap', gray); title('motion cue on sphere');

out = abs(motion_cue);


