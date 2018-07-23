// Reference: E. Sandgren,Nonlinear Integer and Discrete Programming in Mechanical I Design Optimization,Journal of Mechanical Design,JUNE 1990, Vol. 112/223

//A cylindrical pressure vessel is capped at both ends by hemispherical heads.The total cost,
//including the cost of material, cost of forming and welding,is to be minimized. The design variables are Ts and Th are the thicknesses of the shell and head, and R and L, the inner radius and length of the cylindrical section.These variables are denoted by X1 x2 , x3, and x4, respectively, and units for each are inches. The variables are such that R and L are continuous while Ts and Th are integer multiples of 0.0625 inch, the available thicknesses of rolled steel plates.
//   Min  f = 0.6224*X(1)*X(3)*X(4) + 1.7781*X(2)*X(3)^2 + 3.1661*X(1)^2*X(4) + 19.84*X(1)^2*X(3)
//    subject to 
//    g1(X)  - X1 + 0.0193 X3 < = 0
//    g2(X)  - x2 + 0.00954X3 <= 0
//    g3(X)  -%pi*X3^2*X4 - (4/3)*%pi*X3^3 + 1296000 <= 0
//    g4(X)  X4 - 240 <= 0

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

// Onjective fucntion
function f = ObjectiveFunction (X)
    X(1:2) = X(1:2)*0.0625;
    f = 0.6224*X(1)*X(3)*X(4) + 1.7781*X(2)*X(3)^2 + 3.1661*X(1)^2*X(4) + 19.84*X(1)^2*X(3);
endfunction
// Non linear equality and inequality constraints
function [C,Ceq] = NLconstraints(X)
    X(1:2) = (X(1:2))*0.0625;
    C = -%pi*X(3)^2*X(4) - (4/3)*%pi*X(3)^3 + 1296000;
    Ceq = [];
endfunction
// Linear inequality constraints
A = [-0.0625 0 0.0193 0;0 -0.0625 0.00954 0;0 0 0 1];
b = [0 0 240]';
// Bounds of the variables
lb = [1 1 10 10];
ub = [99 99 200 200];
nVar = length(lb);
// Initial guess given to the solver
x0 = [20 10 58.291 43.69];
// indices of the integer decision variables
int = [1 2];
// Calling the solver
[xopt,fopt,exitflag,output,lambda] = intfmincon(ObjectiveFunction,x0,int,A,b,[],[],lb,ub,NLconstraints)

// Result representation
// Converting the integer variables to the discrete variable
x0(1:2) = x0(1:2)*0.0625;
clc; 
disp(x0,"Initial guess given to the solver")
select exitflag
case 0
    disp("Optimal Solution Found")
    disp(xopt',"The optimum solution obtained")
    disp(fopt,"The optimum value of the objective function")
case 1
    disp("Converged to a point of local infeasibility")
case 2
    disp("Objective Function is Continuous Unbounded")
case 3
    disp("Limit Exceeded")
case 4
    disp("User Interupt")
case 5
    disp("MINLP Errors")
end
