//Reference: K. Deep et al.,"A real coded genetic algorithm for solving integer and mixed integer optimization problems", Applied Mathematics and Computation, 212, p 505-518,2009
// min f(x) = x1^2 + x2^2 +x3^2 +x4^2 +x5^2 -8x1 - 2x2 - 3x3 - x4 -2x5
// Subject to
//       x1 + x2 + x3 + x4 + x5 <= 400;
//       x1 + 2x2 + 2x3 + x4 + 6x5 <= 800
//       2x1 + x2 + 6x3 <= 200
//       x3 + x4 + 5x5 <= 200
//       x1 + x2 + x3 + x4 + x5  >= 55
//       x1 + x2 + x3 + x4 >= 48
//       x2 + x4 + x5 >= 34
//       6x1 + 7x5 >= 104
// The known optimal solution is f*(x) = 807 at x* = [16. 22. 5. 5. 7.]
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
nCon = 8;
//integer constraints
intcon = 1:5;
//coefficients of the linear term
f = [-8 -2 -3 -1 -2];
// Hessian matrix
H = [2 0 0 0 0;
0 2 0 0 0
0 0 6 0 0
0 0 0 8 0
0 0 0 0 4];
// Bounds of the problem 
lb = zeros(1,nVar);
ub = 99*ones(1,nVar);
// Constraint matrix
A = [1 1 1 1 1;
1 2 2 1 6; 
2 1 6 0 0;
0 0 1 1 5;
-1 -1 -1 -1 -1
-1 -1 -1 -1 0;
0 -1 0 -1 -1;
-6 0 0 0 -7];
b = [400 800 200 200 -55 -48 -34 -104]';
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
