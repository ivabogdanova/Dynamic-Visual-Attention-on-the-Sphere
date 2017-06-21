function c_map = compute_conspicuity_on_sphere(Feature_theta_phi,gamma)
%
% function for calculating the conspicuity map of a feature image
% through VA algorithm based on center surround mechanism 
% uses: SphLow, SLpU as external functions
% YAWTB, SpharmonicKit
%
% input image must be NxN (powers of 2) 
% AND must is in the THETA PHI domain
%
% Iva Bogdanova & Alex Bur
% June 2007
%


n = size(Feature_theta_phi);

%-----------------------------------------%
% create  the levels of Laplacian Pyramid %
%-----------------------------------------%
    
%level 1compute_conspicuity_on_sphere.m
f1 = SphLow(Feature_theta_phi);
f1_down = f1(1:2:n(1), 1:2:n(2)); 


%level 2
f2 = SphLow(f1_down);
f2_down = f2(1:2:n(1)/2, 1:2:n(2)/2);

%level 3
f3 = SphLow(f2_down);
f3_down = f3(1:2:round(n(1)/4), 1:2:round(n(2)/4));

%level 4
f4 = SphLow(f3_down);
f4_down = f4(1:2:n(1)/8, 1:2:n(2)/8);

%level 5
f5 = SphLow(f4_down);
f5_down = f5(1:2:n(1)/16, 1:2:n(2)/16);

%level 6
f6 = SphLow(f5_down);
f6_down = f6(1:2:n(1)/32, 1:2:n(2)/32);

%level 7
f7 = SphLow(f6_down);
f7_down = f7(1:2:n(1)/64, 1:2:n(2)/64);

%level 8
f8 = SphLow(f7_down);
f8_down = f8(1:2:n(1)/128, 1:2:n(2)/128);

% visualization on the sphere of both fi and fi_down
%yashow(f8, 'spheric','fig',14); title('8 level Gassian sphere'); colormap gray; view(-113,50);
%yashow(f8_down, 'spheric','fig',15); title('8 level down sampled sphere'); colormap gray; view(-113,50);


%-----------------------------------------------%
% compute the center surround difference        %
% 6 multiscale level : cmap25,cmap26,           %
%               cmap36,cmap37,cmap47,cmap48     %
%-----------------------------------------------%


%--------- L2-L5 at scale 2------------

% upsample level 5 to level 2
L5_u2 = SLpU(SLpU(SLpU(f5_down)));

% center surround difference
M25 = f2_down - L5_u2;



%imwrite(M2,'map25.tif');

% Upsample cmap25 to level 1 ----> (1 level up)
M25_u = SLpU(M25);

%TAKE THE ABSOLUTE VALUE
abs_M25_u = abs(M25_u);                                                       

%compute the weighting coeff
map25 = exponential_norm(abs_M25_u,gamma);

%map25 = weight_w_norm(abs_M25_u);

% cmap14 visualization
%yashow(map25,'spheric', 'cmap', gray, 'fig',4);title('unfolded MAP2 = L2-L5 at level 2');


%--------- L2-L6 at scale 2------------

% upsample level 5 to level 2
L6_u2 = SLpU(SLpU(SLpU(SLpU(f6_down))));

% center surround difference
M26 = f2_down - L6_u2;



%imwrite(M2,'map25.tif');

% Upsample cmap25 to level 1 ----> (1 level up)
M26_u = SLpU(M26);

%TAKE THE ABSOLUTE VALUE
abs_M26_u = abs(M26_u);                                                       

%compute the weighting coeff
map26 = exponential_norm(abs_M26_u,gamma);

%map26 = weight_w_norm(abs_M26_u);

% cmap14 visualization
%yashow(map26,'spheric', 'cmap', gray, 'fig',5);title('unfolded MAP2 = L2-L5 at level 2');

%--------- L3-L6 at scale 3------------

% upsample level 6 to level 3
L6_u3 = SLpU(SLpU(SLpU(f6_down)));

% center surround difference
M36 = f3_down - L6_u3;



%imwrite(M3,'map36.tif');

% Upsample cmap63 to level 1  ----> (2 levels up)
M36_uu = SLpU(SLpU(M36));      

%TAKE THE ABSOLUTE VALUE
abs_M36_uu = abs(M36_uu);                                                       

%compute the weighting coeff
map36 = exponential_norm(abs_M36_uu,gamma);

%map36 = weight_w_norm(abs_M3_uu);

% cmap14 visualization
%yashow(map36, 'spheric','cmap', gray, 'fig',6);title('unfolded MAP3 = L3-L6 at level 3');

%--------- L3-L7 at scale 3------------

% upsample level 6 to level 3
L7_u3 = SLpU(SLpU(SLpU(SLpU(f7_down))));

% center surround difference
M37 = f3_down - L7_u3;


%imwrite(M3,'map36.tif');

% Upsample cmap63 to level 1  ----> (2 levels up)
M37_uu = SLpU(SLpU(M37));      

%TAKE THE ABSOLUTE VALUE
abs_M37_uu = abs(M37_uu);                                                       

%compute the weighting coeff
map37 = exponential_norm(abs_M37_uu,gamma);

%map37 = weight_w_norm(abs_M37_uu);

% cmap14 visualization
%yashow(map37, 'spheric','cmap', gray, 'fig',7);title('unfolded MAP3 = L3-L6 at level 3');


%--------- L4-L7 at scale 4------------

% upsample level 7 to level 4
L7_u4 = SLpU(SLpU(SLpU(f7_down)));

% center surround difference
M47 = f4_down - L7_u4;



%imwrite(M4,'map47.tif');

% Upsample cmap74 to level 1  ----> (3 levels up)
M47_uuu = SLpU(SLpU(SLpU(M47)));      

%TAKE THE ABSOLUTE VALUE
abs_M47_uuu = abs(M47_uuu);                                                      

%compute the weighting coeff
map47 = exponential_norm(abs_M47_uuu,gamma);
%map47 = weight_w_norm(abs_M4_uuu);

% cmap14 visualization
%yashow(map47, 'spheric','cmap', gray, 'fig',8);title('unfolded MAP4 = L4-L7 at level 4');

%--------- L4-L8 at scale 4------------

% upsample level 8 to level 4
L8_u4 = SLpU(SLpU(SLpU(SLpU(f8_down))));

% center surround difference
M48 = f4_down - L8_u4;


%imwrite(M4,'map47.tif');

% Upsample cmap74 to level 1  ----> (3 levels up)
M48_uuu = SLpU(SLpU(SLpU(M48)));      

%TAKE THE ABSOLUTE VALUE
abs_M48_uuu = abs(M48_uuu);                                                      

%compute the weighting coeff
map48 = exponential_norm(abs_M48_uuu,gamma);
%map48 = weight_w_norm(abs_M48_uuu);

% cmap14 visualization
%yashow(map48, 'spheric','cmap', gray, 'fig',9);title('unfolded MAP4 = L4-L7 at level 4');



%---------------------------------------------------------------%
%MAP COMBINATION: at level 1                                   %
%                                                              %
%C = N(cmap14) + N(cmap25) + N(cmap36) + N(cmap47) +N(cmap58)  %                                    
%                                                              %
%---------------------------------------------------------------%

%---sum the maps at scale 1----
map = map25 + map26 + map36 + map37 + map47 + map48;



% cmap14 visualization
%figure(6); imagesc(map); axis image; colormap gray; title('unfolded Intensity map at level 1');

%yashow(map,'spheric', 'cmap', gray, 'fig',7);title('intensity map on the sphere');
%imwrite(map,'mapS.tif');

c_map = map;



