M = csvread("trainingSetMASSIVE.csv");

size(M)

numbRows = size(M,1);

shuffledData = M(randperm(numbRows),:);
trainingSet = shuffledData(1:numbRows*0.7,:);
testSet = shuffledData(numbRows*0.7 + 1:end,:);


X = trainingSet(:, 1:end-4);
odds = trainingSet(:, end-3:end-1);
y = trainingSet(:, end:end);

%[X, mu, sigma] = featureNormalize(X); %normalising to avoid NaN in the big featured costs

num_labels = 3;

fprintf('\nTraining One-vs-All Logistic Regression...\n')

lambda = 2;
[all_theta] = oneVsAllGradDesc(X, y, num_labels, lambda);

fprintf('Program paused. Press enter to continue.\n');
pause;


%% ================ Part 3: Predict for One-Vs-All ================

[fullPredictions max] = predictOneVsAll(all_theta, X);

y(1:10,:)

fprintf('\nTraining Set Accuracy: %f\n', mean(double(max == y)) * 100);

%% ================ Part 4: Predict for test set ================

testX = testSet(:, 1:end-4);
testOdds = testSet(:, end-3:end-1);
testY = testSet(:, end:end);

%testX = featureNormalizeWithVals(testX, mu, sigma); %normalising

[testFullPredictions testMax] = predictOneVsAll(all_theta, testX);

fprintf('\nTest Set Accuracy: %f\n', mean(double(testMax == testY)) * 100);


%% ================ Part 4: Predict for test set ================

fprintf('Program paused. Press enter to continue.\n');
pause;

gamma = 0.15; %has to be this amount better than betters probabilities
delta = 0.3; %has to be this much more likely than second highest outcome.


trainProbs = convertLogitsToProbability(fullPredictions);
[moneyMade, numbBets] = calcMoneyMade(odds, trainProbs, y, gamma); %money made for training data.
calcMoneyMadeBestProb(odds, trainProbs, y, delta, gamma);

testProbs = convertLogitsToProbability(testFullPredictions);
[moneyMadeTraining, numbBetsTraining] = calcMoneyMade(testOdds, testProbs, testY, gamma); %money made for test data.
calcMoneyMadeBestProb(testOdds, testProbs, testY, delta, gamma);