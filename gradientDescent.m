function [theta, J_history] = gradientDescent(X, y, theta, alpha, num_iters, lambda)
%GRADIENTDESCENTMULTI Performs gradient descent to learn theta
%   theta = GRADIENTDESCENTMULTI(x, y, theta, alpha, num_iters) updates theta by
%   taking num_iters gradient steps with learning rate alpha

% Initialize some useful values
m = length(y); % number of training examples
J_history = zeros(num_iters, 1);

for iter = 1:num_iters

    % ====================== YOUR CODE HERE ======================
    % Instructions: Perform a single gradient step on the parameter vector
    %               theta. 
    %
    % Hint: While debugging, it can be useful to print out the values
    %       of the cost function (computeCostMulti) and gradient here.
    %

thetaX = X * theta;
hTheta = sigmoid(thetaX);
error = hTheta - y;


xError = X' * error;

delta = xError / m;

regularisation = lambda/m * theta;
delta = delta + regularisation;

theta = theta - alpha * delta;


    % ============================================================

    J = lrCostFunction(theta, X, y, lambda);
    
    fprintf("Iteration  %4i | Cost: %4.6e\r", iter, J);
    
    % Save the cost J in every iteration    
    J_history(iter) = J;
   
    
    if J_history(10) > 0
      if abs(J_history(end-5) - J) < 0.0000002
      break;
      endif
      endif
    
end

end