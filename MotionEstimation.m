function [ME,ImageNew]=MotionEstimation(Image1, Image2, BlockSize, WindowSize, MEprev);

% This function performs a local motion estimation
% between two spherical images. It reconstructs the estimation of Image2 from 
% Image1 using a block matching method with only translatory block
% movements. Image2 is divided into blocks and then the algorithm searches
% the best matching block in the Image1 in the MSE sense. 
% The periodicity in the azimuthal direction is taken into 
% account (for blocks on the left and right edges of the spherical image,
% phi=0 is equivalent to phi=2*pi)
%
% Input parameters:
% Image1, Image2: Two spherical images given on an equiangular spherical grid 
%                 of size 2B*2B where B is the frequency bandwidth of the
%                 data.
% BlockSize: One dimension of the block size. Blocks are assumed to be square
%            (ex. BlockSize=4 uses blocks of size 4x4)
% WindowSize: One dimension of the window size. Window is assumed to be
%             square
% MEprev: If you do a motion estimation within the multiresolutional framework, 
%         this is the Motion vectors matrix from the previous resolution level. 
%         If you do just a single resolution motion estimation this paramter 
%         should be set to a zero matrix of size (NumberOfBlocks^2,2)
%             
% Output parameters:
% ME: Motion vectors (ME(:,1)-motion of theta, ME(:,2)-motion of phi)
% ImageNew: An estimated Image2
%
% Reference: Tosic, I. ; Bogdanova, I. ; Frossard, P. ; Vandergheynst, P.,
% "Multiresolution Motion Estimation for Omnidirectional
% Images",Proceedings of EUSIPCO, 2005
%
% works for MxN spherical images
% last modified December 2007
% Nov'08: adding an initial condition for verofication when to compue the best
% matching depending on the luminance of the texture
% 


%initial parameters
M1=size(Image1,1);%image size in TH
M2=size(Image1,2);% image size in PH
NumBlocksTH=M1/BlockSize;%number of blocks in TH
NumBlocksPH=M2/BlockSize;%number of blocks in TH
p=WindowSize/2;%maximal movement corresponding to half of the window size

%initialization
k=1;
ME=zeros(NumBlocksTH*NumBlocksPH,2);
ImageNew=[];

%Best matching block search for each block
for BlockCountTH=1:NumBlocksTH
    ImageRowNew=[];
    for BlockCountPH=1:NumBlocksPH
        %Extract a block from Image2
        Block=Image2(((BlockCountTH-1)*BlockSize+1):(BlockCountTH*BlockSize),((BlockCountPH-1)*BlockSize+1):(BlockCountPH*BlockSize));
        
        %%% if verification on the smoothness in each block
        if (std2(Block) < 255.0/25.0)%%%
            % don't compute the motion vector %%%
            BBlock = zeros(BlockSize,BlockSize);%%% should be not defined with a value!!!
        else%%%
            %Calculate the center of the search window
            th0=((BlockCountTH-1)*BlockSize+BlockSize/2)+MEprev(k,1);
            ph0=mod(((BlockCountPH-1)*BlockSize+BlockSize/2)+MEprev(k,2),M1);
        
            %Find the best match for the extracted block in Image1
            [ME(k,:),BBlock,MSE]=BestBlock(Image1,Block,p,th0,ph0);
        end%%%
        
        
        %Add the found block to the reconstructed image
        ImageRowNew=[ImageRowNew BBlock];
        k=k+1;
    end
    ImageNew=[ImageNew; ImageRowNew];
end

%Update the motion vectors (only within the multiresolutional framework)
ME=ME+MEprev;
%imshow(ImageNew)