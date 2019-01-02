%Function converts probability of each result into the decimal odds
function odds = turnProbabilityToOdds(matrix) 
  
  odds = 1 ./ matrix;
  
endfunction
