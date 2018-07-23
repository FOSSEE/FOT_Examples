//This problem solves sustem of nonlinear equations using fsolve
//Reference: A. Golbabai, M. Javidi,Newton-like iterative methods for solving system of non-linear equations,Applied Mathematics and Computation,Volume 192, Issue 2,2007,Pages 546-551,ISSN 0096-3003,https://doi.org/10.1016/j.amc.2007.03.035.(http://www.sciencedirect.com/science/article/pii/S0096300307003578)
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
clc
//Function representing system of nonlinear equaltions 
function f = SLEs(p)

    x = p(1);y = p(2);
    f(1) = (x+10)/x^4 + x^2 + 3*x*y + y^2-16;
    f(2) =  1/(x+y)^7 + x*y - 1 - 1/2^7;   

endfunction

//Tolarence of solution 
tol = 1D-15;

//Initial guess
x0 = [10 10];

disp(x0,'Initial guess value is');

//Obtaining solution using fsolve
[x ,v ,info] = fsolve(x0,SLEs,tol)
clc
select info
case 0
    mprintf('\n improper input parameters\n');
case 1
    mprintf('\n algorithm estimates that the relative error between x and the solution is at most tol\n');
case 2
    mprintf('\n number of calls to fcn reached\n');
case 3
    mprintf('\n tol is too small. No further improvement in the approximate solution x is possible\n');
else
    mprintf('\n iteration is not making good progress\n');
end
disp(x,'The solution is ')
disp(v,'the function value at solution')


