function out = MotionFeature(s1,s2);
%
% funcrion that calculates the motion magnitude at resolution 256, i.e. blocksize=4 and search
% window=16 on two images.
%
% INPUT:
%       s1,s2: spherical images (MxNx3)
%      
%
% OUTPUT: 
% out - the motion magnitude
% 
% external programs used:   MotionMap_s2.m
%                          
%
% Iva Bogdanova
% April, 2008


% -----MV at 256------
Mvec_256 = MotionMap_s2(s1,s2,4,16);

theta_256 = Mvec_256(:,:,1);    % motion inTHETA 
phi_256 = Mvec_256(:,:,2);      % motion in PHI

move_theta = theta_256';
move_phi = phi_256';

% motion magnitude at resolution 256
mag_motion = sqrt(move_theta.^2 + move_phi.^2);

out = mag_motion;


