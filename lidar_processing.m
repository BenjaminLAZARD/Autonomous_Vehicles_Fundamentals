

% ------------------------------------------
% DO NOT TOUCH THIS SECTION UNTIL THE MAIN WHILE LOOP!!    

% where are the files?
base_dir     ='/home/uei/gepperth/DataTA23/LIDAR/';
calib_dir    = '/home/uei/gepperth/DataTA23/LIDAR/';
dir_image    = sprintf('%s/kitti_image_02/',base_dir);
dir_velodyne = sprintf('%s/kitti_velodyne/',base_dir);
dir_calib    = sprintf('%s/kitti_calib/',base_dir);
frame        =1;

while(frame<=3)
    
    % load velodyne points - DO NOT TOUCH
    sprintf('%s/%06d.bin',dir_velodyne,frame);
    fid = fopen(sprintf('%s/%06d.bin',dir_velodyne,frame),'rb');
    raw_velo = fread(fid,[4 inf],'single')';
    velo = raw_velo(1:end, 1:3);
    fclose(fid);

    % load transformation matrices - HANDS OFF
    [Tr_velo_to_cam, Tr_cam_to_rect, Tr_project_cam_to_plane] = loadCalibration(sprintf('%s/%06d.txt',dir_calib, frame));
    
    % load image file (color image!) - GUESS WHAT YOU SHOULD NOT DO!
    image_file=sprintf('%s/%06d.png',dir_image,frame);
    color_img=imread(image_file);
    
    %Let us display the image, and show its size
    %figure(frame);
    subplot(2,3,frame);
    image(color_img);
    title('drivers perspective');
    axis equal tight
    [image_height, image_width, image_color] = size(color_img);
    fprintf('image n°%d in the perspective of the driver: width = %i, height = %i, rgb (yes/no) = %d \n',frame, image_width, image_height, image_color==3);
    
    %Let us display one of the transformation matrixes:
    [tr_line, tr_columns] = size(Tr_velo_to_cam);
    fprintf('transformation matrix n°%d_1 : widtgh= %d, height = %d \n', frame, tr_line, tr_columns);    	

    % how many LIDAR points?
    % velo has nrPoint lines, each of which has three entries that correspond to x/y/z coordinates
    nrPoints = size(velo,1);
    fprintf('cloud point n°%d possesses %d points \n', frame, nrPoints);
    fprintf('\n\n\n');
    
     % extend lidar points
     velo_extend = [velo ones(nrPoints, 1)];
     % obtain camera coordinates
     camera_points = velo_extend*transpose(Tr_velo_to_cam);
     %obtain rectified camera coordinates
     rect_points = camera_points*transpose(Tr_cam_to_rect);
     %projection to image plan
     plane_points = rect_points*transpose(Tr_project_cam_to_plane);
     %normalisation
     norm_plane_points = plane_points(:,1:2) ./ [plane_points(:,3) plane_points(:,3)];
     %We have coordinates of the pixels in the plane (not rounded)
   
     %The following code is supposed to be optimal.
     %Unfortunately for some reason it does not work, and we had to use the
     %for loop without enjoying matlab's own gestion of matrixes
     
     %{
     lidar_img = norm_plane_points(norm_plane_points(:,1)>1 & norm_plane_points(:,1)<image_width & norm_plane_points(:,2)<image_height & norm_plane_points(:,2)>image_height/2, :);
     lidar_img = round(lidar_img);
     
     color_img2 = color_img;
     for n  = 1:1000
         color_img2(lidar_img(n,2), lidar_img(n,1), 1:3) = [0 0 0];
     end
     %}
     
     
    color_img2 = color_img;
    color_img3 = color_img;
    % loop over LIDAR points
    for point_index = 1:nrPoints
        %Round coordinates to get pixels values.
        x = round(norm_plane_points(point_index,1));
        y = round(norm_plane_points(point_index,2));
        %Check whether the pixel is in the image
        if (x > 0 && x < image_width && y<image_height && y>1)
            %Apply a diffeent set of colors depending on the area
            color_img2(y,x, 1:3) = [0 255 0];%Top
            if (y >image_height/2)
                color_img2(y,x, 1:3) = [0 0 255];%Bottom
                if (rect_points(point_index,2)>1.62)%1.62 : experimental value
                    color_img2(y,x, 1:3) = [255 0 0];%Ground
                end
            end
        end
            
 
      % cut off pixels above ground plane, with y coordinate < 1.4

    end ;
    %figure(frame);
    subplot(2,3,3+frame);
    image(color_img2);
    axis equal tight;
    

    % FREEDOM ENDS HERE - PLZ DO NOT TOUCH
    % save visual image
    imwrite(color_img,sprintf('project%d.png',frame)) ;
    imwrite(color_img2, sprintf('ex1_im%d.png',frame));
    frame=frame+1;
    
end

