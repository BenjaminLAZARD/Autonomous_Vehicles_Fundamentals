function dijkstra

  start = 1; % start node
  destination = 17; % destination node
  costMatrix = zeros(17,17) + inf;
  
  % Represent the map as bidirectional cost matrix
  costMatrix(1,2) = 3 ;
  costMatrix(1,4) = 3 ;
  costMatrix(2,3) = 2 ;
  costMatrix(2,5) = 4 ;
  costMatrix(2,6) = 2 ;
  costMatrix(3,4) = 4 ;
  costMatrix(3,5) = 1 ;
  costMatrix(4,9) = 4 ;
  costMatrix(5,8) = 4 ;
  costMatrix(6,7) = 3 ;
  costMatrix(7,8) = 4 ;
  costMatrix(7,14) = 4 ;
  costMatrix(8,13) = 12 ; %2
  costMatrix(9,10) = 5 ;%15
  costMatrix(10,11) = 3 ;
  costMatrix(11,12) = 2 ;
  costMatrix(11,17) = 4 ;
  costMatrix(12,13) = 3 ;
  costMatrix(12,16) = 2 ;
  costMatrix(13,14) = 3 ;
  costMatrix(14,15) = 2 ;
  costMatrix(15,16) = 4 ;
  costMatrix(16,17) = 2 ;
  for i=1:17
      for j=1:i
          costMatrix(i,j) = costMatrix(j,i) ;
      end
  end
  
  n = size(costMatrix,1);
  S(1:n) = 0;     % vector, set of visited vectors
  dist(1:n) = inf;   % Lowest cost between the source node and any other node;
  prev(1:n) = n+1;    % Previous node, informs about the best previous node known to reach each network node 

  dist(start) = 0;
  S(start) = 1 ;

  % Loop until all nodes are visited
  while sum(S)~=n
      % Distance from the source node to candidate nodes
      frontier = zeros(1,n) + inf ;
      
      % Populate the frontier with candidate node costs.
      for node=1:n
          % if the node has been already visited
          if S(node)==1
              for dest_node=1:n 
                  % we search accessible nodes that have not been visited
                  % already, eg on the frontier
                  if (costMatrix(node,dest_node)~=inf && S(dest_node)==0) 
                      % check if this dest_node has not been reached
                      % already in this for loop
                      if (frontier(dest_node) > dist(node) + costMatrix(node,dest_node))
                          frontier(dest_node) = dist(node) + costMatrix(node,dest_node);
                          prev(dest_node) = node ;
                      end
                  end
              end 
          end
      end
      
      % Select the node with minimum cost
      [shortest_cost, idx_selectedNode] = min(frontier);
      
      % Set the selected node as visited
      S(idx_selectedNode)=1;
      
      % Update shortest cost and previous node information from selected
      % node to other nodes
      dist(idx_selectedNode) = shortest_cost ;
  end
  selected_path = [destination];
  % Extract the optimm path by backtracking the vector prev
  while selected_path(1)~=start
        selected_path = [prev(selected_path(1)) selected_path];
  end
  
  selected_path
  shortest_path = dist(destination)
  
  
    % Let us plot the result
    % approximate position of the points to display the map
    clf ;
    x = [130 227 387 473 319 216 273 460 659 905 958 789 539 409 551 873 1072] ;
    y = [882 705 662 756 573 430 320 431 616 647 465 318 248 181 128 137 221] ;
    img = imread('ex5/map.png') ;
    imagesc(img) ;
    hold on
    for i = 1: n
        for j = 1:i
            if(costMatrix(i,j) < inf)
                plot([x(i) x(j)], [y(i) y(j)], 'bo-','Linewidth',2.5,'MarkerSize',15, 'MarkerFaceColor','b');
                text((x(i)+x(j))/2 + 0, (y(i) + y(j))/2 +20, num2str(costMatrix(i,j)), 'fontsize', 20,'FontWeight','bold') ;
            end
        end
    end
    plot(x(selected_path), y(selected_path), 'ro-','Linewidth',3,'MarkerSize',15, 'MarkerFaceColor','r');
    for i = 1: n
        text(x(i)-5-5*round(i/10), y(i), num2str(i), 'fontsize', 12,'FontWeight','bold')
    end
    hold on
    axis equal tight
    axis off
end