function saliency = compute_saliency_synth()
% this function computes the saliency on the sphere
% external programs used:  IntFeature.m
%                           RGFeature.m
%                           BYFeature.m
%                           compute_conspicuity_on_sphere_3_level.m
%                           pp_norm_image.m
%                           exponential_norm.m
%                           SLpU.m
%                           SpotsAttenuation.m
%
% Iva Bogdanova & Alex Bur
% June 2007
%



%Define the gamma value
gamma=1.5;


% read omni directional image
I = imread('/DATA/VA_ladybug_2_0/LADYBUGimages/input/ball_classeur_3_frame_0008.bmp');
% yashow(I,'spheric','cmap',gray, 'fig',1);% YAWTB 
% yashow(I,'spheric','cmap',gray, 'fig',6);% YAWTB 
% yashow(I,'spheric','cmap',gray, 'fig',7);% YAWTB 
% yashow(I,'spheric','cmap',gray, 'fig',8);% YAWTB 
%title('input LADYBUG image');

I = imresize(I,[1024 1024]);
yashow(I,'spheric','cmap',gray, 'fig',1);

%---------------------------------------%
% intensity                             %
%---------------------------------------%
 
  
% compute feature intensity in cartesian domain
intensity_xy = IntFeature(I);

% compute feature intensity in phi theta domain
intensity_phi_theta = intensity_xy;


%------------------------%
%UPDATE: Alex 08. 11. 07.%
%------------------------%

%% % compute intensity conspicuity map
 cmap_int = compute_conspicuity_on_sphere(intensity_phi_theta,1.0);

% compute intensity conspicuity map
% cmap_int = compute_conspicuity_on_sphere_3_level(intensity_phi_theta, gamma);

%------------------------%


yashow(cmap_int,'spheric','cmap',gray, 'fig',2);% YAWTB 
yashow(cmap_int,'cmap',gray, 'fig',5);% YAWTB 

cmap_euclidian = imread('/DATA/VA_ladybug_2_0/LADYBUGimages/input/euclidian_saliency.tif');

yashow(cmap_euclidian,'spheric','cmap',gray, 'fig',3);% YAWTB 