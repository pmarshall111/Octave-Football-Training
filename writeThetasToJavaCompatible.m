function writeThetasToJavaCompatible(thetas)
  
  dlmwrite("testThetas.csv", thetas, "delimiter", " ", "newline", "\n");
  
endfunction
