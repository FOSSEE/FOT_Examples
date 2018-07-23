// M.F. Cardoso,R.L.Salcedo,S.F.D. Azevedo,D. Barbosa, A simulated anealing approach to the solution of MINLP problems, Computer and Chemical Engineering,21(12),1349-1364,1997
//
// max f = r1*r2*r3;
//     r1 = 1 - 0.1^y1*0.2^y2*0.15^y3
//     r2 = 1 - 0.05^y4*0.2^y5*0.15^y6;
//     r3 = 1 - 0.02^y7*0.06^y8;
// subject to
//     y1 + y2 + y3 >= 1;
//     y4 + y5 + y6 >= 1;
//     y7 + y8 >= 1;
//     3y1 + y2 + 2y3 + 3y4 + 2y5 + y6 + 3y7 + 2y8 <= 10;
//     0 <= y <= 1
//     All the variables (y) are integers 
// Global optima: y* = [0 1 1 1 0 1 1 0]; f* = 0.94347;

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
function f = ObjectiveFunction(y)
    r(1) = 1 - 0.1^y(1)*0.2^y(2)*0.15^y(3);
    r(2) = 1 - 0.05^y(4)*0.2^y(5)*0.15^y(6);
    r(3) = 1 - 0.02^y(7)*0.06^y(8);
    f = -1*prod(r);
endfunction
// Linear inequality constraints
A = [-1 -1 -1 0 0 0 0 0; 0 0 0 -1 -1 -1 0 0; 0 0 0 0 0 0 -1 -1;3 1 2 3 2 1 3 2];
b = [-1 -1 -1 10]';

// Dimension of the problem
nVar = 8;
// Bounds of the problems
lb = zeros(1,8);
ub = ones(1,8);

// Initial guess given to the solver
x0 = lb;
// indices of the integer decision variables
int = 1:nVar;
// Calling the solver
[xopt,fopt,exitflag,output,lambda] = intfmincon(ObjectiveFunction,x0,int,A,b,[],[],lb,ub)

// Result representation
clc; 
disp(x0,"Initial guess given to the solver")
select exitflag
case 0
    disp("Optimal Solution Found")
    disp(xopt',"The optimum solution obtained")
    disp(fopt,"The optimum value of the objective function")
case 1
    disp("Infeasible solution")
case 2
    disp("Objective Function is Continuous Unbounded")
case 3
    disp("Limit Exceeded")
case 4
    disp("User Interupt")
case 5
    disp("MINLP Errors")
end
