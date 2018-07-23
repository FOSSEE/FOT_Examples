// J.Hald, K Madsen, Reference:Combined LP and quasi-Newton methos for minimax optimization, Mathematical Programming, Springer, 1981
//    Min F = max|fi(x)|
//    fi(X) = (X1 + X2*ti - exp(ti))^2 + (X3 + X4*sin(ti) - cos(ti))^2 where i varies from 1 to 20
//    ti = 0.2i
//    Global optima: X* = [-12.24368 14.02180 -0.45151 -0.01052]; F* = 115.70644;
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
function f = ObjectiveFunction(X)
    m = 20;
    for i = 1:m
        t(i) = 0.2*i;
        f(i) = abs((X(1) + X(2)*t(i) - exp(t(i)))^2 + (X(3) + X(4)*sin(t(i)) - cos(t(i)))^2);
    end
endfunction
// Initial guess to the solver
x0 = [-10 5 1 -2]

// Run fminimax
options= list("MaxIter", 10000);
[x,fval,maxfval,exitflag,output,lambda] = fminimax(ObjectiveFunction,x0,[],[],[],[],[],[],[],options);

// Result representation
clc;
select exitflag
case 0 
    disp("Optimal Solution Found")
    disp(x0,"The initial guess given to the solver")
    disp(x',"The optimal solution determined by the solver")
    disp(maxfval,"The optimum value of the objective function")
case 1
    disp("Maximum Number of Iterations Exceeded. Output may not be optimal")
case 2
    disp("Maximum amount of CPU Time exceeded. Output may not be optimal")
case 3
    disp("Stop at Tiny Step")
case 4
    disp("Solved To Acceptable Level")
case 5
    disp("Converged to a point of local infeasibility")
end

