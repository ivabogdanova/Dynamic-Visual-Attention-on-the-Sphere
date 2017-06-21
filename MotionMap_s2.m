function Mvec = MotionMap_s2(s1,s2,BlockSize,WindowSize);
% function for calculating the motion vector  on the sphere
% at a single scale 
% images size: 1024x1024
% scale = 1024/BlockSize
%
% INPUT:
% s1-reference sphere
% s2-prediction sphere
% BlockSize - must be a squared block
% WindowSize- the size of the search window
% 
% OUTPUT:
%   ME: Motion vectors (ME(:,1)-motion of theta, ME(:,2)-motion of phi)
% Mvec: array of size (MxNx2), where Mvec(:,:,1) - motion in theta
%                       Mvec(:,:,2) - motion in phi
%
% external programs used: MotionEstimation.m
%
% Iva Bogdanova,
% January 2008
%


% make the images NxN required by the fns in SpharmonicKit (needed for performing CCM)
% if these two lines are taken out, the program works for MxN images
s1 = imresize(s1, [1024 1024]);
s2 = imresize(s2, [1024 1024]);

n = size(s1);

scale1 = n(2)/BlockSize;
scale2 = n(1)/BlockSize;     %resolution

% perform ME on a single level
%[ME,SphereNew]=MotionEstimation(s1, s2, BlockSize, WindowSize, zeros(scale^2,2));
[ME,SphereNew]=MotionEstimation(s1, s2, BlockSize, WindowSize, zeros(scale2*scale1,2));

%----thresholding the noise motion vectors ----
error = abs(double(rgb2gray(s1)) - double(rgb2gray(s2)));
E1 = size(error,1); % image size in theta
E2 = size(error,2); % size in phi

NumBlocksETH = E1/BlockSize; % number of blocks in theta
NumBlocksEPH = E2/BlockSize; % number of blocks in phi

% initialization for the thersholding
k=1;
mask = ones(NumBlocksETH*NumBlocksEPH,2); % define a matrix for the error-mask

for BlockCountTH=1:NumBlocksETH
    for BlockCountPH=1:NumBlocksEPH
        %Extract a block from error
        BlockE=error(((BlockCountTH-1)*BlockSize+1):(BlockCountTH*BlockSize),((BlockCountPH-1)*BlockSize+1):(BlockCountPH*BlockSize));
        
        % verify the mean value in each error-block and if below a thereshold put 0
        if (mean2(BlockE) <= 4.85)
                mask(k,:)=0;
        end
        k = k + 1;
    end
end

ME = ME.*mask;  % mask the motion vector 
%------------------------------------------------

 Mvec = reshape(ME,[scale1 scale2 2]);
 
 
 % visualization of the motion vector
% % 
% % vec_y = - Mvec(:,:,1);  % !!! the minus sign is added only for perpose of visualization with quiver !!!!
% % vec_x = Mvec(:,:,2);
% % figure; imagesc(s1); hold on
% % %[p,q] = meshgrid(1:1:2048,1:1:1024);
% % [p,q] = meshgrid(1:1:1024,1:1:1024);
% % %quiver(p(1:16:1024,1:32:2048),q(1:16:1024,1:32:2048),vec_x',vec_y');
% % %quiver(p(1:16:1024,1:16:1024),q(1:16:1024,1:16:1024),vec_x(1:4:256,1:4:256)',vec_y(1:4:256,1:4:256)'); hold on %B4 w8
% % %quiver(p(1:8:1024,1:8:1024),q(1:8:1024,1:8:1024),vec_x(1:1:128,1:1:128)',vec_y(1:1:128,1:1:128)'); % b 8, 
% % %quiver(p(1:64:1024,1:64:1024),q(1:64:1024,1:64:1024),vec_x(1:4:64,1:4:64)',vec_y(1:4:64,1:4:64)'); % B 16, w64
% % %quiver(p(1:16:1024,1:16:1024),q(1:16:1024,1:16:1024),vec_x(1:1:64,1:1:64)',vec_y(1:1:64,1:1:64)');  %B 16
% % %quiver(p(1:32:1024,1:32:1024),q(1:32:1024,1:32:1024),vec_x(1:1:32,1:1:32)',vec_y(1:1:32,1:1:32)');  %B 32


