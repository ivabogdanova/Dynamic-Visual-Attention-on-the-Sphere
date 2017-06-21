function saliency_main()


filename = 'LADYBUGimages/input/meeting_6_persons.bmp';

filename_saliency = 'output_images/saliency.tif'; 
                    
filename_int = 'output_images/consp_int.tif'; 
filename_RG = 'output_images/consp_RG.tif'; 
filename_BY = 'output_images/consp_BY.tif';                     
filename_spots = 'output_images/spots.tif';

compute_SPHsaliency(filename,filename_saliency,filename_int,filename_RG,filename_BY,filename_spots);