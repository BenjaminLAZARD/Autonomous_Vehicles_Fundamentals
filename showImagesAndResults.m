start = 0;
stop = start+11178;
directory = '/home/uei/gepperth/DataIN103/JPG/';
nrMaxima = 10;%deemed ok
boxSize = 30;%deemed ok
thresholdRed = 14000;%deemed ok
pas = floor((stop - start)/300);

imgIndex = start;
while  imgIndex < stop
    % charger l'image --> 'img'
    color_img = imread(sprintf('%s/frame_%06d.jpg',directory,imgIndex)) ;
    lab_img = imread(sprintf('%s/lab_%06d.jpg',directory,imgIndex)) ;

    if imgIndex == start
        [image_height, image_width, image_color] = size(color_img);
        fprintf('image in the perspective of the driver: width = %i, height = %i, rgb (yes/no) = %d \n', image_width, image_height, image_color==3);
        [lab_im_height, lab_im_width, lab_im_color] = size(lab_img);
        fprintf('lab_image in the perspective of the driver: width = %i, height = %i, lab (yes/no) = %d \n', lab_im_width, lab_im_height, lab_im_color==3);
    end

    % affichage
    subplot(2,2,1) ;
    axis equal tight;
    imshow(color_img) ;
    subplot(2,2,2) ;
    axis equal tight;
    imshow(lab_img) ;

    L = double(lab_img(:,:,1)) ;
    a = double(lab_img(:,:,2))-128. ;
    b = double(lab_img(:,:,3))-128. ;

    %Calculate F
    %F = zeros(image_height, image_width);
    F = L.*(a+b);
    subplot(2,2,3);
    imagesc(F);
    axis equal tight;

    [x,y,maxVals] = detectMaxima(F,nrMaxima, boxSize) ;


    %Overlay the boxes with maxima on the image
    subplot (2,2,4);
    image(color_img);
    axis equal tight;
    hold on
    for index = 1:nrMaxima
       boxMax = [max(0,x(index)-boxSize/2), max(0,y(index)-boxSize/2), boxSize, boxSize] ;

        if maxVals(index) >= thresholdRed
            rectangle('position', boxMax, 'edgecolor', [1 0 0]) ;
            text(boxMax(1), boxMax(2), num2str(maxVals(index))) ;
        end

    end ;
    hold off

    i = 0;
    set(gcf,'CurrentCharacter','@');
    imgIndex = imgIndex + pas;
    while i<70
        pause(0.01);
        k = get(gcf,'CurrentCharacter');
        if k ~= '@'
            if (k=='a')
                pause(5);
            end
            if (k=='z')
                imgIndex = max(start,imgIndex - 5* pas);
            end
            if (k=='e')
                imgIndex = start;
            end
        end
        i = i + 1;
    end
end
