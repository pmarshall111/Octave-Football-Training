function p = predict(Theta1, Theta2, X, vector)
%PREDICT Predict the label of an input given a trained neural network
%   p = PREDICT(Theta1, Theta2, X) outputs the predicted label of X given the
%   trained weights of a neural network (Theta1, Theta2)

% Useful values
m = size(X, 1);
num_labels = size(Theta2, 1);

% You need to return the following variables correctly 
p = zeros(size(X, 1), 1);

% ====================== YOUR CODE HERE ======================
% Instructions: Complete the following code to make predictions using
%               your learned neural network. You should set p to a 
%               vector containing labels between 1 to num_labels.
%
% Hint: The max function might come in useful. In particular, the max
%       function can also return the index of the max element, for more
%       information see 'help max'. If your examples are in rows, then, you
%       can use max(A, [], 2) to obtain the max for each row.
%

% X 5000 x 400
% Theta1 25 x 401
% Theta2 10 x 26

X = [ones(m,1), X]; %adding bias unit 5000 x 401

A = sigmoid(X * Theta1'); % 5000 x 25

A = [ones(size(A,1),1), A]; %adding bias unit 5000 x 26

output = A * Theta2';

size(output)

%letsSee = output(1:5,:)
%letsSeeExp = exp(letsSee)
%sumExp = sum(letsSeeExp, 2)
%softmax = letsSeeExp ./ sumExp
%totalEachRow = sum(softmax, 2)


%letsSeeSig = sigmoid(output)(1:5,:)
%letsSeeSigExp = exp(letsSeeSig)
%sumSigExp = sum(letsSeeSigExp, 2)
%softmaxSig = letsSeeSigExp ./ sumSigExp
%totalEachRowSig = sum(softmaxSig, 2)


guessesLetsSee = ones(10,10);

for idx = 1:10
  guessesLetsSee(idx, :) = output(vector(idx),:);
  output(idx);
endfor

guessesLetsSeeExp = exp(guessesLetsSee)
sumGuessesExp = sum(guessesLetsSeeExp, 2)
softmaxGuesses = guessesLetsSeeExp ./ sumGuessesExp
totalEachRowGuesses = sum(softmaxGuesses,2)

gLSSig = sigmoid(guessesLetsSee)
gLSSigExp = exp(gLSSig)
sGLSSigExp = sum(gLSSigExp, 2)
softmaxSig = gLSSigExp ./ sGLSSigExp
total = sum(softmaxSig, 2)

%Judging from this, I assume that you used softmax BEFORE you call sigmoid function on the output.

[a,p] = max(output, [], 2);

% =========================================================================


end
