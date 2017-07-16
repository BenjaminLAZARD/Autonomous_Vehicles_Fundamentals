%function y = gradients

    directory = '/home/uei/gepperth/DataIN103/JPG/';  
    start = 1000;
    colormap jet;
 
    
    for i = start:start+5
        path = sprintf('%s/frame_%06d.jpg',directory, i);
        img = rgb2gray(imread(path) );

        for filter_index = 0:2
            % gray level image - please display of the other images exactly like this one
            subplot(3,6,filter_index*6+1) ;
            imagesc(img) ;   
            axis equal tight;
            axis off;
            if(i ==start)
               imwrite(img,sprintf('img.png')) ;
            end

            % different filters for each inner iteration
            flt=[1,-1];
            if filter_index==1
                flt=[1,1,1,-1,-1,-1];
            end
            if filter_index==2
                flt=[1,1,1,1,1,-1,-1,-1,-1,-1];
            end
     
            %filterx: calculate & display
            filterx = filter2(flt, img);
            subplot(3,6, filter_index*6 + 2);
            imagesc(filterx);
            axis equal tight;
            axis off;
            if(i ==start)
               imwrite(filterx,sprintf('filterx.png')) ;
            end
            % filtery: calculate & display
            filtery = filter2(flt', img);
            subplot(3,6, filter_index*6 + 3);
            imagesc(filtery);
            axis equal tight;
            axis off;
            if(i ==start)
               imwrite(filtery,sprintf('filtery.png')) ;
            end
            % energy: calculate & display
            energy = (filterx.^2 + filtery.^2).^0.8;
            subplot(3,6, filter_index*6 + 4);
            imagesc(energy);
            axis equal tight;
            axis off;
            if(i ==start)
               imwrite(energy,sprintf('energy.png')) ;
            end
            % angles raw: calculate & display
            orientation = atan2(filtery, filterx);
            subplot(3,6, filter_index*6 + 5);
            imagesc(orientation);
            axis equal tight;
            axis off;
            if(i ==start)
               imwrite(orientation,sprintf('orientation.png')) ;
            end
            % angles filtered: calculate & display
            %threshold is but the average value of the energy.
            threshold = mean(energy(:));
            %threshold = quantile(energy(:),0.7);
            filter = (energy > threshold);
			orientation_f = orientation .* filter; 
			subplot(3,6,filter_index*6 + 6);
			imagesc(orientation_f);
            axis equal tight;
            axis off;
            if(i ==start)
               imwrite(orientation_f,sprintf('orientation_f.png')) ;
            end

       end % loop over filters

       waitforbuttonpress ;
   end % loop over images
%end

