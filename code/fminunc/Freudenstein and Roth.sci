// This is an example of unconstrained optimization problem using fminunc function. The problem has global optima at x* = [5 4] and f* = 0;
//An alternate optima to the problem is x = [11.41.. -0.8968..] and f = 48.9842..
//Ref:F. Freudenstein and B. Roth, Numerical solution of systems of nonlinear equations, Journal of ACM , Vol. 10, No. 4, pp. 550–556, 1963.
//Ref:S.S. Rao, “Engineering optimization: Theory and Practice”, John Wiley & Sons Inc., New York (NY), 3rd edition edition, 1996. Chapter 6
//======================================================================                
// Copyright (C) 2018 - IIT Bombay - FOSSEE
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt
// Author:Debasis Maharana
// Organization: FOSSEE, IIT Bombay
// Email: toolbox@scilab.in
//======================================================================
clc;

function y = Freud_Roth(x)
    y  = (-13 + x(1) + ( (5-x(2)) *x(2) -2 )*x(2) )^2 + ( -29 + x(1) + (( x(2)+1 )*x(2) -14 )*x(2) )^2;
endfunction

mprintf('Freudenstein and Roth function: This function has 2 variables')
//Initial point
x0 = input('Enter initial point in vector form ' )
if length(x0)~=2
    mprintf('Incorrect initial point. Taking initial point as [0.5 -2]');
    x0 = [0.5 -2];
end

//Gradient of objective function using numderivative function 
function y=Grad(x)
y = numderivative(Freud_Roth,x);
endfunction

//Hessian of Objective Function using numderivative function 
function y=Hess(x)
[G,H] = numderivative(Freud_Roth,x);
Nvar = length(x);
for i = 1:Nvar
    y(i,:) = H((i-1)*Nvar+1:i*Nvar);
end
endfunction

//Options structure
options=list("MaxIter", [1500], "CpuTime", [500], "gradobj", Grad, "hessian", Hess);
//Calling Ipopt
[xopt,fopt,exitflag,output,gradient,hessian]=fminunc(Freud_Roth,x0,options)
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


