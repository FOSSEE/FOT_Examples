//Reference: Rein Luus and Taina . I. Jaakola, Optimization of Nonlinear Functions Subject to Equality Constraints. Judicious Use of Elementary Calculus and Random Numbers,Ind. Eng. Chem. Process Des. Develop., Vol. 12, No. 3, 1973

// Optimization of a continuous through circulation dyer
// Maximize the production rate by considering the fluid velocity (X1) and bed length (X2) as the design parameters subjected to power constraint and the moisture content distribution constraint

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
    f = -(0.0064*X(1)*(1 - exp(-0.184*(X(1)^0.3)*X(2))));
endfunction
// Non linear equality constraints
function [C,Ceq] = NLConstraints(X)
    Ceq(1,1) = (3000 + X(1))*(X(1)^2)*X(2) - 1.2D13;
    Ceq(1,2) = exp(0.184*X(1)^0.3*X(2)) - ln(4.1);
    C = [];
endfunction
// Bounds of the problem
lb = [0 0];
ub = [];
// Initial guess
x0 = [1000 20];
// Calling the solver
[xopt,fopt,exitflag,output,lambda] = fmincon(ObjectiveFunction,x0,[],[],[],[],lb,[],NLConstraints)

// Result representation
select exitflag
case 0
    disp("Optimal Solution Found")
    disp(x0,"Initial guess given to the solver")
    disp(xopt',"The optimum solution obtained")
    disp(fopt,"The optimum value of the objective function")
case 1
    disp(" Maximum Number of Iterations Exceeded. Output may not be optimal")
    disp(x0,"Initial guess given to the solver")
    disp(xopt',"The solution obtained")
    disp(fopt,"The value of the objective function")
case 2
    disp("Maximum amount of CPU Time exceeded. Output may not be optimal")
    disp(x0,"Initial guess given to the solver")
    disp(xopt',"The solution obtained")
    disp(fopt,"The value of the objective function")
case 3
    disp("Stop at Tiny Step")
    disp(x0,"Initial guess given to the solver")
    disp(xopt',"The solution obtained")
    disp(fopt,"The value of the objective function")
case 4
    disp("Solved To Acceptable Level")
    disp(x0,"Initial guess given to the solver")
    disp(xopt',"The solution obtained")
    disp(fopt,"The value of the objective function")
case 5
    disp("Converged to a point of local infeasibility")
end

