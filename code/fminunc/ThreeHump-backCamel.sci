// Reference: Urmila Diwekar, "Introduction to Aplied Optimization", 2nd Ed, Springer Science + Business Media,2008, Chapter 3

// Three hump-back camel function : An unconstrained problem
// F(X) = 2*X(1)^2 - 1.05*X(1)^4 + (1/6)*X(1)^6 + X(1)*X(2) + X(2)^2
// Dimension of the problem:  2
// The global optima for the function: F*(X) = 0 and X* = [0 0];
//=====================================================================
// Copyright (C) 2018 - IIT Bombay - FOSSEE
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt
// Author: Remya Kommadath
// Organization: FOSSEE, IIT Bombay
// Email: toolbox@scilab.in
//=====================================================================

clc; 
// Objective function 
function f = ObjectiveFunction(X)
    f = 2*X(1)^2 - 1.05*X(1)^4 + (1/6)*X(1)^6 + X(1)*X(2) + X(2)^2;
endfunction
// Gradient of the function
function gf = GradientFunction(X)
    gf = [4*X(1) - 4.2*X(1)^3 + X(1)^5 + X(2), X(1) + 2*X(2)];
endfunction
// Hessian matrix of the function
function hf = HessianFunction(X)
    hf = [4 - 12.6*X(1)^2 + 5*X(1)^4, 1; 1 2]
endfunction

// Initial guess
x0 = [0,-1];
disp(x0, "The initial guess given to the solver is")
input("Press enter to proceed: ")
// User specified parameter values
options=list("gradobj", GradientFunction,"hessian",HessianFunction);
// Calling the solver
[xopt,fopt,exitflag,output,gradient,hessian] = fminunc(ObjectiveFunction,x0,options)

// Result representation
clc
select exitflag
case 0 
    disp("Optimal Solution Found")
    disp(xopt', "The optimum solution obtained is")
    disp(fopt, "The optimum objective function value is")
case 1
    disp("Maximum Number of Iterations Exceeded. Output may not be optimal.")
    disp(xopt', "The solution obtained is")
    disp(fopt, "The objective function value is")
case 2
    disp("Maximum CPU Time exceeded. Output may not be optimal.")
    disp(xopt', "The solution obtained is")
    disp(fopt, "The objective function value is")
case 3
    disp("Stop at Tiny Step.")
    disp(xopt', "The solution obtained is")
    disp(fopt, "The objective function value is")
case 4
    disp("Solved To Acceptable Level.")
    disp(xopt', "The solution obtained is")
    disp(fopt, "The objective function value is")
case 5 
    disp("Converged to a point of local infeasibility.")
end

disp(output)
