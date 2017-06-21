function M = spotsA(Radius,saliency_resized, I, i);
% this function detects 10 spots of attention and mark them on the input
% image
% Radius -radius (size) of the attenuated spherical region
%
% external programs: 
%           DrawCircle.m
%           FindMax_sph(X)
% uses YAWtb
% 
% evaluation of maximums:
%     1 - red
%     2 - green
%     3- blue
%     4- yellow
%     5- magenda
%     6- cyan
%     7- dark red
%     8- gray
%     9- white
%     10- black
%     
%
% Iva Bogdanova
% November 2007
% last update: April 2008


%read the input image
I = imresize(I, [1024 1024]);
imwrite(I,sprintf('/Users/ivabogdanova/Omni_images/work/omni_VA/SPHEREomni/dVA_sw/LADYBUG/input1024/I1024_frame%d.tif',i));

%map the image on the sphere
%S1 = OmniParToSphere(double(rgb2gray(F1)));
S1 = I;

%[x,y] = size(S1); %for nxn matrix
[x,y,p] = size(S1); % for nxnx3 matrix (color)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1 max in RED
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%for n= 0:2


%find first maximum in the map (Y)
[r1,c1]= FindMax_sph(saliency_resized);


%yashow(saliency_resized,'cmap',gray, 'fig',17);

% find degree resolution
 thetaM = r1(1)*(180/y);
 phiM = c1(1)*(360/x);
    
%saliency_resized(r1(1)-Radius:r1(1)+Radius,c1(1)-Radius:c1(1)+Radius) = 0;

% show the unfolded image
%yashow(S1,'cmap',gray, 'fig',12); title('unfolded input omnidirectional image on the sphere'); %Yawtb
%yashow(X,'cmap',gray, 'fig',1); title('unfolded saliency map on the sphere'); %Yawtb
%hold on

%
% draw circle at center (thetaM,phiM) and attenuate the region
[AC12,fC12]=DrawCircleAttenuation(Radius,thetaM,phiM);

%yashow(fC12,'spheric', 'fig',13); % draw only the circle centered at max
% locate all position of the circle and replace them in the inpit image
% equal to 0

S1_r = squeeze(S1(:,:,1));
S1_g = squeeze(S1(:,:,2));
S1_b = squeeze(S1(:,:,3));
S1_r(fC12 == 1) = 255;
S1_g(fC12 == 1) = 0;
S1_b(fC12 == 1) = 0;
S1(:,:,1) = S1_r;
S1(:,:,2) = S1_g;
S1(:,:,3) = S1_b;

% attenuate the region inside the circle
saliency_resized(AC12==1) = 0;


%----2 max in GREEN---
[r1,c1]= FindMax_sph(saliency_resized);

% find degree resolution
 thetaM = r1(1)*(180/y);
 phiM = c1(1)*(360/x);

[AC12,fC12]=DrawCircleAttenuation(Radius,thetaM,phiM);

S1_r = squeeze(S1(:,:,1));
S1_g = squeeze(S1(:,:,2));
S1_b = squeeze(S1(:,:,3));
S1_r(fC12 == 1) = 0;
S1_g(fC12 == 1) = 255;
S1_b(fC12 == 1) = 0;
S1(:,:,1) = S1_r;
S1(:,:,2) = S1_g;
S1(:,:,3) = S1_b;

saliency_resized(AC12==1) = 0;

% -------------3 max in BLUE-------------------------------------------------
[r1,c1]= FindMax_sph(saliency_resized);

% find degree resolution
 thetaM = r1(1)*(180/y);
 phiM = c1(1)*(360/x);

[AC12,fC12]=DrawCircleAttenuation(Radius,thetaM,phiM); % draw circle at the required max

S1_r = squeeze(S1(:,:,1));
S1_g = squeeze(S1(:,:,2));
S1_b = squeeze(S1(:,:,3));
S1_r(fC12 == 1) = 0;
S1_g(fC12 == 1) = 0;
S1_b(fC12 == 1) = 255;
S1(:,:,1) = S1_r;
S1(:,:,2) = S1_g;
S1(:,:,3) = S1_b;

saliency_resized(AC12==1) = 0;

% --4 max in  YELLOW--------------
[r1,c1]= FindMax_sph(saliency_resized);

% find degree resolution
 thetaM = r1(1)*(180/y);
 phiM = c1(1)*(360/x);
 
[AC12,fC12]=DrawCircleAttenuation(Radius,thetaM,phiM); % draw circle at the required max

S1_r = squeeze(S1(:,:,1));
S1_g = squeeze(S1(:,:,2));
S1_b = squeeze(S1(:,:,3));
S1_r(fC12 == 1) = 255;
S1_g(fC12 == 1) = 255;
S1_b(fC12 == 1) = 0;
S1(:,:,1) = S1_r;
S1(:,:,2) = S1_g;
S1(:,:,3) = S1_b;

saliency_resized(AC12==1) = 0;

% --5 max-- MAGENDA---------
[r1,c1]= FindMax_sph(saliency_resized);

% find degree resolution
 thetaM = r1(1)*(180/y);
 phiM = c1(1)*(360/x);

[AC12,fC12]=DrawCircleAttenuation(Radius,thetaM,phiM);% draw circle at the required max

S1_r = squeeze(S1(:,:,1));
S1_g = squeeze(S1(:,:,2));
S1_b = squeeze(S1(:,:,3));
S1_r(fC12 == 1) = 255;
S1_g(fC12 == 1) = 0;
S1_b(fC12 == 1) = 255;
S1(:,:,1) = S1_r;
S1(:,:,2) = S1_g;
S1(:,:,3) = S1_b;


saliency_resized(AC12==1) = 0;
% % 
% % % --6 max--CYAN----
% % [r1,c1]= FindMax_sph(saliency_resized);
% % 
% % % find degree resolution
% %  thetaM = r1(1)*(180/y);
% %  phiM = c1(1)*(360/x);
% % 
% % [AC12,fC12]=DrawCircleAttenuation(Radius,thetaM,phiM);% draw circle at the required max
% % 
% % S1_r = squeeze(S1(:,:,1));
% % S1_g = squeeze(S1(:,:,2));
% % S1_b = squeeze(S1(:,:,3));
% % S1_r(fC12 == 1) = 0;
% % S1_g(fC12 == 1) = 255;
% % S1_b(fC12 == 1) = 255;
% % S1(:,:,1) = S1_r;
% % S1(:,:,2) = S1_g;
% % S1(:,:,3) = S1_b;
% % 
% % saliency_resized(AC12==1) = 0;
% % 
% % % --7 max--DARK RED--------------
% % [r1,c1]= FindMax_sph(saliency_resized);
% % 
% % % find degree resolution
% %  thetaM = r1(1)*(180/y);
% %  phiM = c1(1)*(360/x);
% %  
% % 
% % [AC12,fC12]=DrawCircleAttenuation(Radius,thetaM,phiM); % draw circle at the required max
% % 
% % S1_r = squeeze(S1(:,:,1));
% % S1_g = squeeze(S1(:,:,2));
% % S1_b = squeeze(S1(:,:,3));
% % S1_r(fC12 == 1) = 128;
% % S1_g(fC12 == 1) = 0;
% % S1_b(fC12 == 1) = 0;
% % S1(:,:,1) = S1_r;
% % S1(:,:,2) = S1_g;
% % S1(:,:,3) = S1_b;
% % 
% % saliency_resized(AC12==1) = 0;
% % 
% % % --8 max--GRAY--------------
% % [r1,c1]= FindMax_sph(saliency_resized);
% % 
% % % find degree resolution
% %  thetaM = r1(1)*(180/y);
% %  phiM = c1(1)*(360/x);
% %  
% %  
% % [AC12,fC12]=DrawCircleAttenuation(Radius,thetaM,phiM); % draw circle at the required max
% % 
% % S1_r = squeeze(S1(:,:,1));
% % S1_g = squeeze(S1(:,:,2));
% % S1_b = squeeze(S1(:,:,3));
% % S1_r(fC12 == 1) = 128;
% % S1_g(fC12 == 1) = 128;
% % S1_b(fC12 == 1) = 128;
% % S1(:,:,1) = S1_r;
% % S1(:,:,2) = S1_g;
% % S1(:,:,3) = S1_b;
% % 
% % saliency_resized(AC12==1) = 0;
% % 
% % % --9 max--WHITE--------------
% % [r1,c1]= FindMax_sph(saliency_resized);
% % 
% % % find degree resolution
% %  thetaM = r1(1)*(180/y);
% %  phiM = c1(1)*(360/x);
% % 
% % [AC12,fC12]=DrawCircleAttenuation(Radius,thetaM,phiM); % draw circle at the required max
% % 
% % S1_r = squeeze(S1(:,:,1));
% % S1_g = squeeze(S1(:,:,2));
% % S1_b = squeeze(S1(:,:,3));
% % S1_r(fC12 == 1) = 255;
% % S1_g(fC12 == 1) = 255;
% % S1_b(fC12 == 1) = 255;
% % S1(:,:,1) = S1_r;
% % S1(:,:,2) = S1_g;
% % S1(:,:,3) = S1_b;
% % 
% % saliency_resized(AC12==1) = 0;
% % 
% % % --10 max--BLACK-------------
% % [r1,c1]= FindMax_sph(saliency_resized);
% % 
% % % find degree resolution
% %  thetaM = r1(1)*(180/y);
% %  phiM = c1(1)*(360/x);
% % 
% % [AC12,fC12]=DrawCircleAttenuation(Radius,thetaM,phiM);% draw circle at the required max
% % 
% % S1_r = squeeze(S1(:,:,1));
% % S1_g = squeeze(S1(:,:,2));
% % S1_b = squeeze(S1(:,:,3));
% % S1_r(fC12 == 1) = 0;
% % S1_g(fC12 == 1) = 0;
% % S1_b(fC12 == 1) = 0;
% % S1(:,:,1) = S1_r;
% % S1(:,:,2) = S1_g;
% % S1(:,:,3) = S1_b;
% % 
% % saliency_resized(AC12==1) = 0;
% % 
% % 
% % % --11 max--????-------------
% % [r1,c1]= FindMax_sph(saliency_resized);
% % 
% % % find degree resolution
% %  thetaM = r1(1)*(180/y);
% %  phiM = c1(1)*(360/x);
% % 
% % [AC12,fC12]=DrawCircleAttenuation(Radius,thetaM,phiM);% draw circle at the required max
% % 
% % S1_r = squeeze(S1(:,:,1));
% % S1_g = squeeze(S1(:,:,2));
% % S1_b = squeeze(S1(:,:,3));
% % S1_r(fC12 == 1) = 255;
% % S1_g(fC12 == 1) = 0;
% % S1_b(fC12 == 1) = 128;
% % S1(:,:,1) = S1_r;
% % S1(:,:,2) = S1_g;
% % S1(:,:,3) = S1_b;
% % 
% % saliency_resized(AC12==1) = 0;
% % 
% % % --12 max--????-------------
% % [r1,c1]= FindMax_sph(saliency_resized);
% % 
% % % find degree resolution
% %  thetaM = r1(1)*(180/y);
% %  phiM = c1(1)*(360/x);
% % 
% % [AC12,fC12]=DrawCircleAttenuation(Radius,thetaM,phiM);% draw circle at the required max
% % 
% % S1_r = squeeze(S1(:,:,1));
% % S1_g = squeeze(S1(:,:,2));
% % S1_b = squeeze(S1(:,:,3));
% % S1_r(fC12 == 1) = 255;
% % S1_g(fC12 == 1) = 128;
% % S1_b(fC12 == 1) = 0;
% % S1(:,:,1) = S1_r;
% % S1(:,:,2) = S1_g;
% % S1(:,:,3) = S1_b;
% % 
% % saliency_resized(AC12==1) = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

imwrite(S1,sprintf('/Users/ivabogdanova/Omni_images/work/omni_VA/SPHEREomni/dVA_sw/LADYBUG/spots_amplitude/frame%d.tif',i));
