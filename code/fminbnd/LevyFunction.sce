//Reference: Ernesto P. Adorio and U.P. Diliman,"MVF - Multivariate Test Functions
//Library in C for Unconstrained Global Optimization",2005,
//http://www.geocities.ws/eadorio/mvf.pdf, Last accessed, 11th June 2018

// n-dimensional Levy Function
// Dimension,D = [4 5 10 50 100];
// Domain = |Xi| <= 10 where i = 1,2,...,D
// Global minimum is zero at Xi = 1.
//======================================================================
// Copyright (C) 2018 - IIT Bombay - FOSSEE
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt
// Author: Remya Kommadath
// Organization: FOSSEE, IIT Bombay
// Email: toolbox@scilab.in
//======================================================================
clc; 
// Objective function
function f = LevyFunction(X)
    d = length(X);
    w1 = 1 + (X(1)-1)/4;
    wi = 1 + (X(1:d-1)-1)./4;
    wd = 1 + (X(d)-1)/4;
    Term1 = (sin(%pi.*w1)).^2;
    Term2 = sum(((wi-1).^2).*(1+10*(sin(%pi.*wi + 1)).^2));
    Term3 = ((wd-1).^2)*(1+(sin(2*%pi*X(d))).^2);
    f = Term1 + Term2 + Term3;
endfunction
// Dimension of the problem
D = 5;
// Bounds of the problem
LB = -10*ones(1,D);
UB = 10*ones(1,D);
// Calling the solver
options=list("TolX",0)
[xopt,fopt,exitflag,output,lambda] = fminbnd(LevyFunction,LB,UB,options);

// Result representation
clc; 
select exitflag
case 0 
    disp("Optimal Solution Found")
    disp(xopt',"The optimum solution obtained is")
    disp(fopt,"The objective function value is")
case 1 
    disp("Maximum Number of Iterations Exceeded. Output may not be optimal")
    disp(xopt,"The solution obtained")
    disp(fopt,"The objective function value is")
case 2
    disp("Maximum CPU Time exceeded. Output may not be optimal")
    disp(xopt,"The solution obtained")
    disp(fopt,"The objective function value is")
case 3 
    disp("Stop at Tiny Step")
    disp(xopt,"The solution obtained")
    disp(fopt,"The objective function value is")
case 4 
    disp("Solved To Acceptable Level")
    disp(xopt,"The solution obtained")
    disp(fopt,"The objective function value is")
case 5
    disp("Converged to a point of local infeasibility")
    disp(xopt,"The solution obtained")
    disp(fopt,"The objective function value is")
end
disp(output)
