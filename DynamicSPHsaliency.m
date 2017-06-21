function saliency = DynamicSPHsaliency;
% this function computes the dynamic saliency on the sphere
% external programs used:   IntFeature.m
%                           RGFeature.m
%                           BYFeature.m
%                           compute_conspicuity_on_sphere_3_level.m
%                           pp_norm_image.m
%                           exponential_norm.m
%                           SLpU.m
%                           SpotsAttenuation.m
%                           MotionCue.m
%
% Iva Bogdanova & Alex Bur
% June 2007
%
% last updated April 2008: dynamic VA - adding a loop


gamma = 1.5;                            % Define the gamma value for exponential normalization

N = 17;                               % number of images in the sequence (CAR, N=18)

seq = zeros([1024,2048,3,N],'uint8'); % initialization of the variable containing the sequence

% read the images in the seuqence and put them in a array
for i = 1:N
   %seq(:,:,:,i)=imread(sprintf('/DATA/DynamicVA/ladybug/input/office_room_1_frame_%d.bmp',i));
    seq(:,:,:,i) = imread(sprintf('/Users/ivabogdanova/Omni_images/work/omni_VA/SPHEREomni/dVA_sw/LADYBUG/input/ladybug_%d.bmp',i));
%end
end

S = cat(N,seq);     % write the images in a sequence 

for i = 1:(N-1)
    tic         % START  TIMER
    
    I = imresize(S(:,:,:,i),[1024 1024]);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %           intensity                   %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
  
    % compute feature intensity in cartesian domain
    intensity_xy = IntFeature(I);

    % compute feature intensity in phi theta domain
    intensity_phi_theta = intensity_xy;


    %------------------------%
    %UPDATE: Alex 08. 11. 07.%
    %------------------------%

    % compute intensity conspicuity map
    cmap_int = compute_conspicuity_on_sphere(intensity_phi_theta,gamma);

    % compute intensity conspicuity map
    % cmap_int = compute_conspicuity_on_sphere_3_level(intensity_phi_theta,gamma);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Red -green color opponency            %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % compute feature RG in cartesian domain
    RG_xy = RGFeature(I);

    % compute feature RG in phi theta domain
    RG_phi_theta = RG_xy;

    %------------------------%
    %UPDATE: Alex 08. 11. 07.%
    %------------------------%

    % compute RG conspicuity map
    cmap_RG = compute_conspicuity_on_sphere(RG_phi_theta,gamma);

    % compute RG conspicuity map
    %% cmap_RG = compute_conspicuity_on_sphere_3_level(RG_phi_theta, gamma);


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Yellow-Blue color opponency           %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % compute feature RG in cartesian domain
    YB_xy = BYFeature(I);

    % compute feature RG in phi-theta domain
    BY_phi_theta = YB_xy;

    %------------------------%
    %UPDATE: Alex 08. 11. 07.%
    %------------------------%

    % compute BY conspicuity map
    cmap_BY = compute_conspicuity_on_sphere(BY_phi_theta, gamma);

    % compute BYconspicuity map
    %% cmap_BY = compute_conspicuity_on_sphere_3_level(BY_phi_theta, gamma);


    %------------------------------------------------------------%
    % Compute the cues and finally the final saliency map        %
    %------------------------------------------------------------%


    %--------------------%
    % Chromatic features %
    %--------------------%

    % normalize all conspicuity maps from 0 to 1
    % cmap_RG = pp_norm_image(cmap_RG,0.0,1.0);
    % cmap_BY = pp_norm_image(cmap_BY,0.0,1.0);


    %------------------------%
    %UPDATE: Alex 08. 11. 07.%
    %------------------------%

    % % apply weighting scheme to all conspicuity maps
    % cmap_int = weight_w_norm(cmap_int);
    % cmap_RG = weight_w_norm(cmap_RG);
    % cmap_BY = weight_w_norm(cmap_BY);


    % apply exponential normalization to all conspicuity maps

    cmap_RG = exponential_norm(cmap_RG,gamma);
    cmap_BY = exponential_norm(cmap_BY,gamma);

    %------------------------%
    % compute chromatic cue %
    chromatic_cue = (cmap_RG + cmap_BY)/2;
    chromatic_cue = pp_norm_image(chromatic_cue,0.0,1.0);
    chromatic_cue = exponential_norm(chromatic_cue,gamma);
    
    %%% maxCHROMA = max(max(chromatic_cue))

    %-------------------------------------------------------%
    % compute intensity cue                                 %
    % it simply correspond to the conspicuity intensity     %
    %-------------------------------------------------------%
    cmap_int = pp_norm_image(cmap_int,0.0,1.0);
    cmap_int = exponential_norm(cmap_int,gamma);

    intens_cue = cmap_int;
    
    %%% maxINT = max(max(intens_cue))


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % compute MOTION cue                                    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cmap_motion = MotionCue(S(:,:,:,i),S(:,:,:,i+1),i,gamma);
    cmap_motion = pp_norm_image(cmap_motion,0.0,1.0);
    cmap_motion = exponential_norm(double(cmap_motion),gamma);

    motion_cue = cmap_motion;

    %%% maxMOTION=max(max(motion_cue))

    % sum all cue maps
    saliency = (intens_cue + chromatic_cue + motion_cue)/3.0;
    
    %%% maxSALIENCY = max(max(saliency))

    % solve the bord effect for ladybug images
    saliency(400:512,:) = 0.0;                              % LADYBUG images: attenuate the empty band in (theta,phi)
    %saliency(1:50,:) = 0.0; saliency(300:512,:) = 0.0;     % hyperbolic mirror
    %saliency(1:150,:) = 0.0; saliency(390:512,:) = 0.0;    % KAIDAN
    %saliency(1:49,:) = 0.0;                                % for im2 image
    %saliency(256:512,:) = 0.0;                             % for im2 image


    %normalize the saliency map from 0 to 1.0
    saliency = pp_norm_image(saliency,0.0,1.0);

    %resized the saliency map to the original size of the image
    SaliencyResized = SLpU(saliency);


    % VARIBLES conspicuity internal saving
    cmap_int = pp_norm_image(cmap_int,0.0,1.0);
    cmap_RG = pp_norm_image(cmap_RG,0.0,1.0);
    cmap_BY = pp_norm_image(cmap_BY,0.0,1.0);
    cmap_motion = pp_norm_image(cmap_motion,0.0,1.0);
    
    %figure; imagesc(cmap_motion); colorbar;
   
    
    % compute and draw the spots 
    Radius = 2*pi/20; % define the radius of the circle to be drawn and the attenuation 
    spotsAttenuation(Radius,SaliencyResized, S(:,:,:,i),i);


    % store saliency & conspicuity maps
    imwrite(cmap_int,sprintf('/Users/ivabogdanova/Omni_images/work/omni_VA/SPHEREomni/dVA_sw/LADYBUG/intensity_cue/frame%d.tif',i));
    imwrite(cmap_RG,sprintf('/Users/ivabogdanova/Omni_images/work/omni_VA/SPHEREomni/dVA_sw/LADYBUG/RG_cue/frame%d.tif',i));
    imwrite(cmap_BY,sprintf('/Users/ivabogdanova/Omni_images/work/omni_VA/SPHEREomni/dVA_sw/LADYBUG/BY_cue/frame%d.tif',i));
    imwrite(cmap_motion,sprintf('/Users/ivabogdanova/Omni_images/work/omni_VA/SPHEREomni/dVA_sw/LADYBUG/motion_amplitude/frame%d.tif',i));
    imwrite(saliency,sprintf('/Users/ivabogdanova/Omni_images/work/omni_VA/SPHEREomni/dVA_sw/LADYBUG/saliency/frame%d.tif',i));

    t(i) = toc; % STOP THE TIMER
end

figure; plot(t)     % plot the time of computation for each of the images in the sequence

