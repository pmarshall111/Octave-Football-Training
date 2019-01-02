function [all_theta] = oneVsAllGradDesc(X, y, num_labels, lambda)
%ONEVSALL trains multiple logistic regression classifiers and returns all
%the classifiers in a matrix all_theta, where the i-th row of all_theta 
%corresponds to the classifier for label i
%   [all_theta] = ONEVSALL(X, y, num_labels, lambda) trains num_labels
%   logistic regression classifiers and returns each of these classifiers
%   in a matrix all_theta, where the i-th row of all_theta corresponds 
%   to the classifier for label i

% Some useful variables
m = size(X, 1); %5000
n = size(X, 2); %400

% You need to return the following variables correctly 
all_theta = zeros(num_labels, n + 1);

% Add ones to the X data matrix
X = [ones(m, 1) X];

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the following code to train num_labels
%               logistic regression classifiers with regularization
%               parameter lambda. 
%
% Hint: theta(:) will return a column vector.
%
% Hint: You can use y == c to obtain a vector of 1's and 0's that tell you
%       whether the ground truth is true/false for this class.
%
% Note: For this assignment, we recommend using fmincg to optimize the cost
%       function. It is okay to use a for-loop (for c = 1:num_labels) to
%       loop over the different classes.
%


alpha = 0.00000025;
num_iters = 10000;

endCost = [-1;-1;-1]

for i = 1:num_labels
  initial_theta = zeros(n + 1, 1);
  
  [theta, J_history] = gradientDescent(X, (y == i), initial_theta, alpha, num_iters, lambda);
  
  J_history(1:10);
  
  plot(J_history);
  
  fprintf("End cost after %f iters: %f", num_iters, J_history(end-1));
  
  endCost(i) = J_history(end-1);
                 
   all_theta(i,:) = theta;
endfor


endCost

% =========================================================================


end
