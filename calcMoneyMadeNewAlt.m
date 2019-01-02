function [betterThanBetters, betterThanBettersVariableStake, ratio, ratioWinPlusLoss, ratioVariableStake, ratioWinPlusLossVariableStake] = calcMoneyMadeNewAlt(betProbs, ourProbs, y, delta, gamma, sigma, tau)
  %lambda is used to calculate how much higher the betters odds have to be than our predictions.
  
  % we want to just bet on the outcome that is more than delta higher than the second most likely outcome, irrespective of
  % the betters odds. Afterwards, we should then try also comparing to betters odds and only bet on those that are gamma
  % higher than our probabilities.
 
  
  stake = 5;
  
  goodProbabilitiesBetterThanBetters = zeros(size(ourProbs)); % x% higher than 2nd highest probability and also y% higher than betters probability
  goodProbabilitiesBetterThanBettersVariableStake = zeros(size(ourProbs));
  
  numbBetsBetterThanBettersVariableStake = 0;
  moneyOutBetterThanBettersVariableStake = 0;
  
  for row = 1:size(ourProbs,1)
    highestProb = 0;
    highestIndex = -1;
    secondHighest = 0;
    secondHighestIndex = -1;
    
    for col = 1:size(ourProbs,2)
      currProb = ourProbs(row,col);
      if currProb > highestProb
        secondHighest = highestProb;
        secondHighestIndex = highestIndex;
        highestProb = currProb;
        highestIndex = col;
      elseif currProb > secondHighest
        secondHighest = currProb;
        secondHighestIndex = col;
        endif
      endfor
      
      if highestProb - delta > secondHighest % just checking whether a probability is x% higher than the second highest probability
        
        if highestProb - gamma > betProbs(row, highestIndex) % only adding if a bet is also more likely than second highest probability as well as being higher than betters odds.
            goodProbabilitiesBetterThanBetters(row,highestIndex) = 1;
          endif
          
          
          if highestProb - gamma > betProbs(row, highestIndex)
            numbBetsBetterThanBettersVariableStake += 1;
          
            if highestProb - gamma - 0.2 > betProbs(row, highestIndex) % only adding if a bet is also more likely than second highest probability as well as being higher than betters odds.
              currMult = 1;
            elseif highestProb - gamma - 0.15 > betProbs(row, highestIndex)
              currMult = 2;
            elseif highestProb - gamma - 0.1 > betProbs(row, highestIndex)
              currMult = 3;
            elseif highestProb - gamma - 0.05 > betProbs(row, highestIndex)
              currMult = 4;
            elseif highestProb - gamma - 0 > betProbs(row, highestIndex)
              currMult = 5;
            endif
            
            goodProbabilitiesBetterThanBettersVariableStake(row,highestIndex) = currMult;
              moneyOutBetterThanBettersVariableStake += stake*currMult;
          endif
        endif
      
        
    endfor
    %CALCULATING A RATIO OF W/L
    ourWinRatio = ourProbs(:,1)./ourProbs(:,3);
    bookieWinRatio = betProbs(:,1)./betProbs(:,3);
    ourLossRatio = ourProbs(:,3)./ourProbs(:,1);
    bookieLossRatio = betProbs(:,3)./betProbs(:,1);
    
    goodWinRatioBets = (ourWinRatio - bookieWinRatio) >= sigma;
    goodLossRatioBets = (ourLossRatio - bookieLossRatio) >= sigma;
    
    %goodWinRatioBets = (ourWinRatio - bookieWinRatio*sigma) >= 0;
    %goodLossRatioBets = (ourLossRatio- bookieLossRatio*sigma) >= 0;
    
    goodRatioBets = [goodWinRatioBets, zeros(size(goodWinRatioBets,1),1), goodLossRatioBets];

    
    %CALCULATING A RATIO OF W/W+L
    ourWinPlusLossRatio = ourProbs(:,1)./(ourProbs(:,1)+ourProbs(:,3));
    bookieWinPlusLossRatio = betProbs(:,1)./(betProbs(:,1)+betProbs(:,3));
    ourLossPlusWinRatio = ourProbs(:,3)./(ourProbs(:,1)+ourProbs(:,3));
    bookieLossPlusWinRatio = betProbs(:,3)./(betProbs(:,1)+betProbs(:,3));
    
    goodWinPlusLossRatioBets = (ourWinRatio - bookieWinRatio) >= tau;
    goodLossPlusWinRatioBets = (ourLossRatio - bookieLossRatio) >= tau;
    
    goodWinLossRatioBets = [goodWinPlusLossRatioBets, zeros(size(goodWinPlusLossRatioBets,1),1), goodLossPlusWinRatioBets];
  
  
  
  %another for loop to go through and assign variable values to ratio bets
  goodWinRatioBetsVariableStake = zeros(size(goodWinRatioBets));
  goodLossRatioBetsVariableStake = zeros(size(goodLossRatioBets));
  goodWinPlusLossRatioBetsVariableStake = zeros(size(goodWinPlusLossRatioBets));
  goodLossPlusWinRatioBetsVariableStake = zeros(size(goodLossPlusWinRatioBets));
  
  moneyOutGoodRatioVariableStake = 0;
  numbBetsGoodRatioVariableStake = 0;
  moneyOutGoodPlusWinRatioVariableStake = 0;
  numbBetsGoodPlusWinRatioVariableStake = 0;
 
  for row=1:size(goodWinRatioBetsVariableStake,1) %probably problem in here.
    %col will always be 1. only 1 col in each vector.
    
    %W/L
    currRowWinRatio = ourWinRatio(row,1) - bookieWinRatio(row,1);
    if currRowWinRatio >= sigma
      numbBetsGoodRatioVariableStake += 1;
      
      if currRowWinRatio - 4 >= sigma
        currMult = 1;
      elseif currRowWinRatio - 3 >= sigma
        currMult = 2;
      elseif currRowWinRatio - 2 >= sigma
        currMult = 3;
      elseif currRowWinRatio - 1 >= sigma
        currMult = 4;        
      elseif currRowWinRatio - 0 >= sigma
        currMult = 5;
      endif
      
        goodWinRatioBetsVariableStake(row,1) = currMult;
        moneyOutGoodRatioVariableStake += currMult * stake;
    endif
    
    
    
    currRowLossRatio = ourLossRatio(row,1) - bookieLossRatio(row,1);
    if currRowLossRatio >= sigma
      numbBetsGoodRatioVariableStake += 1;
      
      if currRowLossRatio - 4 >= sigma
        currMult = 1;
      elseif currRowLossRatio - 3 >= sigma
        currMult = 2;
      elseif currRowLossRatio - 2 >= sigma
        currMult = 3;
      elseif currRowLossRatio - 1 >= sigma
        currMult = 4;
      elseif currRowLossRatio - 0 >= sigma
        currMult = 5;
      endif
      
        goodLossRatioBetsVariableStake(row,1) = currMult;
        moneyOutGoodRatioVariableStake += currMult * stake;
    endif
    
    
    
    %W/W+L
    currRowWinPlusLossRatio = ourWinPlusLossRatio(row,1) - bookieWinPlusLossRatio(row,1);
    if currRowWinPlusLossRatio >= tau
      numbBetsGoodPlusWinRatioVariableStake += 1;
    
      if currRowWinPlusLossRatio - 0.4 >= tau
        currMult = 1;
      elseif currRowWinPlusLossRatio - 0.3 >= tau
        currMult = 2;
      elseif currRowWinPlusLossRatio - 0.2 >= tau
        currMult = 3;
      elseif currRowWinPlusLossRatio - 0.1 >= tau
        currMult = 4;
      elseif currRowWinPlusLossRatio - 0 >= tau
        currMult = 5;
        
      endif
      
        goodWinPlusLossRatioBetsVariableStake(row,1) = currMult;
        moneyOutGoodPlusWinRatioVariableStake += currMult * stake;
    endif
    
    
    currRowLossPlusWinRatio = ourLossPlusWinRatio(row,1) - bookieLossPlusWinRatio(row,1);
    if currRowLossPlusWinRatio >= tau
      numbBetsGoodPlusWinRatioVariableStake += 1;
      
      if currRowLossPlusWinRatio - 0.4 >= tau
        currMult = 1;
      elseif currRowLossPlusWinRatio - 0.3 >= tau
        currMult = 2;
      elseif currRowLossPlusWinRatio - 0.2 >= tau
        currMult = 3;
      elseif currRowLossPlusWinRatio - 0.1 >= tau
        currMult = 4;
      elseif currRowLossPlusWinRatio - 0 >= tau
        currMult = 5;        
      endif
      
        goodLossPlusWinRatioBetsVariableStake(row,1) = currMult;
        moneyOutGoodPlusWinRatioVariableStake += currMult * stake;
      
    endif
    
  endfor
  
  goodRatioBetsVariableStake = [goodWinRatioBetsVariableStake, zeros(size(goodWinRatioBetsVariableStake,1),1), goodLossRatioBetsVariableStake];
  goodPlusLossRatioBetsVariableStake = [goodWinPlusLossRatioBetsVariableStake, zeros(size(goodWinPlusLossRatioBetsVariableStake,1),1), goodLossPlusWinRatioBetsVariableStake];
  
  
  
  
  
  betOdds = turnProbabilityToOdds(betProbs);
  
  
  
  betsPlacedBetterThanBetters = betOdds .* goodProbabilitiesBetterThanBetters .* stake;
  numbBetsBetterThanBetters = sum(sum(goodProbabilitiesBetterThanBetters));
  moneyOutBetterThanBetters = numbBetsBetterThanBetters * stake;
  
  betsPlacedBetterThanBettersVariableStake = betOdds .* goodProbabilitiesBetterThanBettersVariableStake .* stake; %variable stake because we've set multiply values other than 1.
  %have calculated other variables further up.
  
  betsPlacedGoodRatio = betOdds .* goodRatioBets .* stake;
  numbBetsGoodRatio = sum(sum(goodRatioBets));
  moneyOutGoodRatio = numbBetsGoodRatio * stake;
  
  betsPlacedGoodRatioWinLoss = betOdds .* goodWinLossRatioBets .* stake;
  numbBetsGoodRatioWinLoss = sum(sum(goodWinLossRatioBets));
  moneyOutGoodRatioWinLoss = numbBetsGoodRatioWinLoss * stake;
  
  
  betsPlacedGoodRatioVariableStake = betOdds .* goodRatioBetsVariableStake .* stake;
  %already calculated other variables
  
  
  betsPlacedGoodPlusLossRatioVariableStake = betOdds .* goodPlusLossRatioBetsVariableStake .* stake;
  
  
  
  
  moneyInBetterThanBetters = 0;
  moneyInBetterThanBettersVariableStake = 0;
  moneyInGoodRatio = 0;
  moneyInGoodPlusLossRatio = 0;
  moneyInGoodRatioVariableStake = 0;
  moneyInGoodPlusLossRatioVariableStake = 0;
  
  
  for row = 1:size(betsPlacedBetterThanBetters,1)
    moneyInBetterThanBetters += betsPlacedBetterThanBetters(row, y(row));
    moneyInBetterThanBettersVariableStake += betsPlacedBetterThanBettersVariableStake(row,y(row));
    moneyInGoodRatio += betsPlacedGoodRatio(row, y(row));
    moneyInGoodPlusLossRatio += betsPlacedGoodRatioWinLoss(row, y(row));
    moneyInGoodRatioVariableStake += betsPlacedGoodRatioVariableStake(row, y(row));
    moneyInGoodPlusLossRatioVariableStake += betsPlacedGoodPlusLossRatioVariableStake(row, y(row));
    endfor
  
 
 moneyMadeBetterThanBetters = moneyInBetterThanBetters - moneyOutBetterThanBetters;
 if moneyOutBetterThanBetters == 0
    profitBetterThanBetters = 0;
   else
     profitBetterThanBetters = moneyMadeBetterThanBetters / moneyOutBetterThanBetters * 100;
   endif
   
   
 moneyMadeBetterThanBettersVariableStake = moneyInBetterThanBettersVariableStake - moneyOutBetterThanBettersVariableStake;
  if moneyOutBetterThanBettersVariableStake == 0
    profitBetterThanBettersVariableStake = 0;
   else
     profitBetterThanBettersVariableStake = moneyMadeBetterThanBettersVariableStake / moneyOutBetterThanBettersVariableStake * 100;
   endif
   
   
moneyMadeGoodRatio = moneyInGoodRatio - moneyOutGoodRatio;
if moneyOutGoodRatio == 0
  profitGoodRatio = 0;
else
  profitGoodRatio = moneyMadeGoodRatio/moneyOutGoodRatio * 100;
endif


 moneyMadeGoodPlusLossRatio = moneyInGoodPlusLossRatio - moneyOutGoodRatioWinLoss;
 if moneyOutGoodRatioWinLoss == 0
  profitGoodRatioWinLoss = 0;
else
  profitGoodRatioWinLoss = moneyMadeGoodPlusLossRatio/moneyOutGoodRatioWinLoss * 100;
endif

moneyMadeGoodRatioVariableStake = moneyInGoodRatioVariableStake - moneyOutGoodRatioVariableStake;
  if moneyOutGoodRatioVariableStake == 0
  profitGoodRatioVariableStake = 0;
else
  profitGoodRatioVariableStake = moneyMadeGoodRatioVariableStake/moneyOutGoodRatioVariableStake * 100;
endif

moneyMadeGoodPlusLossRatioVariableStake = moneyInGoodPlusLossRatioVariableStake - moneyOutGoodPlusWinRatioVariableStake;
  if moneyOutGoodPlusWinRatioVariableStake == 0
  profitGoodPlusLossRatioVariableStake = 0;
else
  profitGoodPlusLossRatioVariableStake = moneyMadeGoodPlusLossRatioVariableStake/moneyOutGoodPlusWinRatioVariableStake * 100;
endif
 
betterThanBetters = [moneyMadeBetterThanBetters, profitBetterThanBetters];
betterThanBettersVariableStake = [moneyMadeBetterThanBettersVariableStake, profitBetterThanBettersVariableStake];
ratio = [moneyMadeGoodRatio, profitGoodRatio];
ratioWinPlusLoss = [moneyMadeGoodPlusLossRatio, profitGoodRatioWinLoss];
ratioVariableStake = [moneyMadeGoodRatioVariableStake, profitGoodRatioVariableStake];
ratioWinPlusLossVariableStake = [moneyMadeGoodPlusLossRatioVariableStake, profitGoodPlusLossRatioVariableStake];
  
endfunction
