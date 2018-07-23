//Reference: K. Deep et al.,"A real coded genetic algorithm for solving integer and mixed integer optimization problems", Applied Mathematics and Computation, 212, p 505-518,2009
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
// Number of decision variables
nVar = 5;
// Num\ber of constraints
nCon = 6;
//integer constraints
intcon = 1:5;
//coefficients of the linear term
f = zeros(1,nVar);
// Hessian matrix
H = [2 0 0 0 0;
0 2 0 0 0
0 0 2 0 0
0 0 0 2 0
0 0 0 0 2];
// Bounds of the problem 
lb = zeros(1,nVar);
ub = 3*ones(1,nVar);
// Constraint matrix
A = [-1 -2 0 -1 0;
0 -1 -2 0 0;
-1 0 0 0 -2;
1 2 2 0 0;
2 0 1 0 0;
1 0 0 0 4];
b = [-4 -3 -5 6 4 13]';
// Initial guess to the solver
x0 = lb;
// Calling the solver
[xopt,fopt,exitflag,output] = intqpipopt(H,f,intcon,A,b,[],[],lb,ub,x0)

// Result representation
disp(x0, "The initial guess given to the solver")

select exitflag
case 0
    disp("Optimal Solution Found")
    disp(xopt',"The optimal solution determined by the solver")
    disp(fopt,"The optimal objective function")
case 1
    disp("InFeasible Solution")
case 2
    disp("Objective Function is Continuous Unbounded")
case 3
    disp("Limit Exceeded")
case 4
    disp("User Interrupt")
case 5
    disp("MINLP Error")
end
