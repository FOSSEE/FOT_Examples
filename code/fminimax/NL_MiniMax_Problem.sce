//C. Charalambous and A.R. Conn, "An efficient method to solve the minimax problem directly",SIAM Journal on Numerical Analysis 15 (1978) 162-187

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
clc
// Objective function
function f = ObjectiveFunction(X)
    g(1) = 0;
    g(2) = -2*X(1)^2 - 3*X(2)^4 - X(3) - 4*X(4)^2 - 5*X(5) + 127;
    g(3) = -7*X(1) - 3*X(2) - 10*X(3)^2 - X(4) + X(5) + 282;
    g(4) = -23*X(1) - X(2)^2 - 6*X(6)^2 + 8*X(7) + 196;
    g(5) = -4*X(1)^2 - X(2)^2 + 3*X(1)*X(2) - 2*X(3)^2 - 5*X(6) + 11*X(7);
    f(1) = (X(1) - 10)^2 + 5*(X(2) - 12)^2 + X(3)^4 + 3*(X(4) - 11)^2 + 10*X(5)^6 + 7*X(6)^2 + X(7)^4 - 4*X(6)*X(7) - 10*X(6) - 8*X(7);
    for i = 2:5
        f(i) = f(1) - 10*g(i);
    end
    f1(2:5) = f(1) + 10*g(2:5);
endfunction

A =[]; b = []; Aeq = []; beq = [];lb = [];ub = [];
// Initial guess given to the solver
x0 = [2, 1, 0, 4, 0, 1, 1];
// Solving the solvers
options = list("maxiter", 4000, "cputime", [6000]);
[x,fval,maxfval,exitflag,output,lambda] = fminimax(ObjectiveFunction,x0,A,b,Aeq,beq,lb,ub,[],options);

// Result representation
clc
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
