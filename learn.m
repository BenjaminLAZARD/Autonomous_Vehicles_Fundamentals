function learn
    nr_datapoints = 40 ;
    nr_iterations = 100 ;
    % create noisy data
    [xtrain,ytrain] = createPoints(2,1,nr_datapoints,2,'train') ;
    [xtest,ytest] = createPoints(2,1,nr_datapoints,2,'test') ;
    
    %Plot these data on 2 separate figures
    figure(1);
    subplot(2,1,1);hold on;
    plot(xtrain, ytrain,'b*');
    title('training set (complexity evolution)','fontweight','bold', 'fontsize', 14);
    xlabel('observation', 'fontsize', 14); ylabel('expected value', 'fontsize', 14);hold off;
    
    subplot(2,1,2); hold on;
    plot(xtest, ytest, 'b*');
    title('testing set (complexity evolution)','fontweight','bold', 'fontsize', 14);
    xlabel('observation', 'fontsize', 14); ylabel('expected value', 'fontsize', 14);hold off;
    
    figure(2);
    subplot(2,1,1);hold on;
    plot(xtrain, ytrain,'b*');
    title('training set (nr_{iterations} evolution)','fontweight','bold', 'fontsize', 14);
    xlabel('observation', 'fontsize', 14); ylabel('expected value', 'fontsize', 14);hold off;
    
    subplot(2,1,2); hold on;
    plot(xtest, ytest, 'b*');
    title('testing set (nr_{iterations} evolution)','fontweight','bold', 'fontsize', 14);
    xlabel('observation', 'fontsize', 14); ylabel('expected value', 'fontsize', 14);hold off;
    
    figure(1);
    
    %optimizing model_complexity with 40 datapoints and 100 iterations.
    error = ones(7,3);
    for k = 1:7
        [error(k,2), error(k,3)] = learn2(xtrain, ytrain, xtest, ytest, k, nr_iterations, 1);
        error(k,1) = k;
    end
    %display the results
    fprintf('f being polynomial with complexity between 1 and %d\n From left to right, polynomial order, training error, and generalization error', size(error,1));
    error
    [a, b]= sort(error(:,3), 'ascend');
    fprintf('minimum generalization_error = %f for complexity = %d \n', a(1), b(1));
    [a, b]= sort(error(:,2), 'ascend');
    fprintf('minimum training_error = %f for complexity = %d \n', a(1), b(1));
    
    %Looking at the effect of the number of training iterations, with 40
    %datapoints and a complexity of 5.    
    start=50; stop=750; step=50;
    error2 = ones(floor((stop-start)/step),3);
    j=1;
    for k = 50:50:750
        [error2(j,2), error2(j,3)] = learn2(xtrain, ytrain, xtest, ytest, 5, k, 2);
        error2(j,1) = k;
        j = j + 1;
    end
    %display the results
    fprintf('f being polynomial with complexity=5 and nr_iterations between %d and %d\n From left to right, nr_iterations, training error, and generalization error', start, stop);
    error2
    [a, b]= sort(error2(:,3), 'ascend');
    fprintf('minimum generalization_error = %f for nr_iterations = %d \n', a(1), error2(b(1),1));
    [a, b]= sort(error2(:,2), 'ascend');
    fprintf('minimum training_error = %f for nr_iterations = %d \n', a(1), error2(b(1),1));
end

function [train_error, generalization_error] = learn2(xtrain, ytrain, xtest, ytest, model_complexity, nr_iterations, fig)
  %rng(0)
  epsilon = 0.05 ; % leave untouched

  % create weight vector w (see lecture) and set to zero
  w = zeros(1,model_complexity) ;

  % do learning on training set
  w_learned = gradientDescent(w,xtrain,ytrain,nr_iterations,0.05);

  % measure train and generalization errors
  train_error = E(w_learned,xtrain,ytrain);
  generalization_error = E(w_learned,xtest,ytest);

  % apply learned function to train and test sets
  est_y_train = apply_f_to_data(w_learned,xtrain) ;  
  est_y_test = apply_f_to_data(w_learned,xtest) ;
  
  figure(fig);
  subplot(2,1,1);hold on;
  plot(xtrain, est_y_train, 'go');
  legend('data set','computed model', 'Location', 'SouthWest');
  
  subplot(2,1,2); hold on;
  plot(xtest, est_y_test, 'ro');
  legend('data set','model calculated on the training set', 'Location', 'SouthWest');

end

function y = apply_f_to_data (w,x)
  y = zeros(1,numel(x)) ;
  for i = 1:numel(x)
    y(i) = f(w,x(i)) ;
  end
end

% loss function: takes an array of input values x, an array
% of target values y, and the parameter vector to be used for 
% the approximating function f
% FILL WITH OWN CODE!!
function err = E(w,x,y)
  err = 0. ;
  for i = 1:numel(y)
      err = err + (y(i)- f(w,x(i)))^2;
  end
  err = err/numel(y);
end

% approximating function: polynomial of degree K
function y = f(w,x)
  y=0. ;
  for pot = 1:numel(w) 
    y = y+w(pot)*x^(pot-1) ;
  end
end

% derivative of loss function w.r.t. parameters
% takes  an array of input values x, an array
% of target values y, and the parameter vector to be used for 
% the approximating function f
% fiLL WITH OWN CODE!!
function deriv = dE_dwi(w,x,y)
  deriv = zeros(1,numel(w)) ;
  for j = 1:numel(deriv)
      for l = 1:numel(y)
          deriv(j) = deriv(j) + (f(w,x(l)) - y(l))*x(l)^(j-1);
      end
      deriv(j) = 2*deriv(j)/numel(y);
  end
end


function w = gradientDescent(w0, x,y, steps,eps)
  w = w0 + 0.1;
  for i=1:steps
    delta = 0. ;
    
    for sample = 1:numel(x)  
      delta = delta+(-1.*eps)*dE_dwi (w,x,y) ;
    end
    delta = delta / (numel(x) + 0.1) ;
    w = w+delta ;
  end
end

function [x,y] = createPoints(a,b,nrPoints,noise,md)
  x = zeros(1,nrPoints) ;

  low=0. ;
  high = 3.;
  if strcmp(md,'train')==1
    low = 0. ;
    high = 1. ;
  end
  for i = 1:nrPoints
    x(i) = low+(high-low)/(nrPoints+0.0)*(i+0.0) ;
    y(i) = a*x(i)+b+noise*rand() ;
  end
end








  
  
