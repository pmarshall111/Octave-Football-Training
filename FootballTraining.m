lambda = 40; %hard coded lambda. We don't want function as that hides all the variables we create within it's scope.
fprintf("Training for lambda value of %f. Reading in data.", lambda)

M = csvread("octaveWeighted.csv");

size(M)

numbRows = size(M,1);

%shuffledData = M(randperm(numbRows),:);
%trainingSet = shuffledData(1:numbRows*0.7,:);
%testSet = shuffledData(numbRows*0.7 + 1:end,:);

T = csvread("octaveWeightedTest.csv");
trainingSet = M;
testSet = T;


X = trainingSet(:, 1:end-4);
odds = trainingSet(:, end-3:end-1);
y = trainingSet(:, end:end);

num_labels = 3;

fprintf('\nTraining One-vs-All Logistic Regression...')
[all_theta] = oneVsAll(X, y, num_labels, lambda);



%% ================ Part 3: Predict for One-Vs-All ================

[fullPredictions max] = predictOneVsAll(all_theta, X);

fprintf('\nTraining Set Accuracy: %f\n', mean(double(max == y)) * 100);

%% ================ Part 4: Predict for test set ================

testX = testSet(:, 1:end-4);
testOdds = testSet(:, end-3:end-1);
testY = testSet(:, end:end);

[testFullPredictions testMax] = predictOneVsAll(all_theta, testX);

fprintf('\nTest Set Accuracy: %f\n', mean(double(testMax == testY)) * 100);


%% ================ Part 4: Predict for test set ================

highestBy = 0.15; %has to be this much more likely than second highest outcome.
betterThanBookies = 0.15; %has to be this amount better than betters probabilities
winLossBetterThan = 4; %our win/loss ratio has to be this much more than bookies win/loss ratio.
winPlusLossBetterThan = 0.25;

%DONT REALLY NEED TO KNOW HOW IT PERFORMS ON TRAINING SET
%trainProbs = convertLogitsToProbability(fullPredictions);
%[moneyMade, numbBets] = calcMoneyMade(odds, trainProbs, y, gamma); %money made for training data.
%calcMoneyMadeBestProb(odds, trainProbs, y, delta, gamma, sigma);

testProbs = convertLogitsToProbability(testFullPredictions);
%[moneyMadeTraining, numbBetsTraining] = calcMoneyMade(testOdds, testProbs, testY, gamma);
[betterThanBetters, betterThanBettersVariableStake, ratio, ratioWinPlusLoss, ratioVariableStake, ratioWinPlusLossVariableStake] = calcMoneyMadeNewAlt(testOdds, testProbs, testY, highestBy, betterThanBookies, winLossBetterThan, winPlusLossBetterThan)
