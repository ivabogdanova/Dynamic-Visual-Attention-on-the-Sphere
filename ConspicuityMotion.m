function out = ConspicuityMotion;
%
% funcrion that calculates the motion conspicuity map
%
% input must be scuared matrix
%
% OUTPUT: 
% out - the motion conspicuity map
% 
% external programs used:   MotionMap_s2.m
%                           SLpU.m
%
% Iva Bogdanova
% March, 2008


% read the two  spherical images 

s1 = imread('office_room_1_frame_0001.bmp');    % 1024x2048
s2 = imread('office_room_1_frame_0002.bmp');    % 1024x2048

% % MV at scale 512
% Mvec_512 = MotionMap_s2(s1,s2,2,32);

% % MV at scale  256
% Mvec_256 = MotionMap_s2(s1,s2,4,32);

% MV at scale 128 
%Mvec_128 = MotionMap_s2(s1,s2,8,32); % makes it NxN matrix first

% % MV at scale 64x64
 Mvec_64 = MotionMap_s2(s1,s2,16,32);

% MV at scale  32x32
Mvec_32 = MotionMap_s2(s1,s2,32,32);

% MV at scale 16x16 
Mvec_16 = MotionMap_s2(s1,s2,64,32);


% sum three levels at scale 512
out_theta = SLpU(SLpU(SLpU(SLpU(SLpU(Mvec_16(:,:,1)))))) + SLpU(SLpU(SLpU(SLpU(Mvec_32(:,:,1))))) + SLpU(SLpU(SLpU(Mvec_64(:,:,1))));
out_phi = SLpU(SLpU(SLpU(SLpU(SLpU(Mvec_16(:,:,2)))))) + SLpU(SLpU(SLpU(SLpU(Mvec_32(:,:,2))))) + SLpU(SLpU(SLpU(Mvec_64(:,:,2))));

move_theta = out_theta';
move_phi = out_phi';
% fig_s1 = imresize(s1,[1024,1024]);
% figure,imagesc(fig_s1),hold on
% [p,q] = meshgrid(1:1:1024,1:1:1024);
% % draw the motion vector field
% quiver(p(1:16:1024,1:16:1024),q(1:16:1024,1:16:1024),move_phi(1:8:512,1:8:512),move_theta(1:8:512,1:8:512));

% motion magnitude
mag_move = move_theta + move_phi;
% figure; imagesc(mag_move);


% rescale to 255 values
% theta_255 = gray2ind(abs(out_theta),255);
% phi_255 = gray2ind(abs(out_phi),255);
% out(:,:,1)=theta_255';
% out(:,:,2)=phi_255';


