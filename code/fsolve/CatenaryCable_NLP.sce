// This is an example problem for solving a non linear equation

//Reference: Steven C. Chapra. 2006. Applied Numerical Methods with MATLAB for Engineers and Scientists. McGraw-Hill Science/Engineering/Math,Chapter 6

//A catenary cable is one which is hung between two points not in the same vertical line. As depicted in Fig. P6.17a, it is subject to no loads other than its own weight. Thus, its weight acts as a uniformload per unit length along the cable w (N/m). A free-body diagram of a section AB is depicted in Fig. P6.17b, where TA and TB are the tension forces at the end. Based on horizontal and vertical force balances, the following differential equation model of the cable can be derived in which calculus can be employed to solve the equation for the height of the cable y as a function of distance x:
//y = (Ta/w)*cosh((w*x)/Ta) - y0 + (Ta/w)
//(a) Use a numerical method to calculate a value for the parameter TA given values for the parameters w = 10 and y0 = 5, such that the cable has a height of y = 15 at x = 50.
//(b) Develop a plot of y versus x for x = −50 to 100.

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

function F = CatenaryCableEqn(Ta,x,w,y0,y)
F = y - (Ta/w)*cosh((w.*x)/Ta) - y0 + (Ta/w);
endfunction

function df = deriv_CatenaryCableEqn(Ta)
    df = numderivative(CatenaryCableEqn,Ta)
endfunction

w = 10;
y0 = 5;
y = 15;
x = 50;
Ta = 300;
Tol = 1.e-16;
[Ta_sol,v,info] = fsolve(Ta,list(CatenaryCableEqn,x,w,y0,y),deriv_CatenaryCableEqn,Tol);

select info
case 0
    mprintf('improper input parameters');
case 1
    mprintf('Algorithm estimates that the relative error between x and the solution is at most tol');
case 2
    mprintf('Number of calls to fcn reached');
case 3
    mprintf('tol is too small. No further improvement in the approximate solution x is possible');
else
    mprintf('Iteration is not making good progress');
end

disp(Ta_sol,'Obtained solution is ')

input('Press enter to identify the effect of initial guess values on the optimal solution ')
Ta = -200:60:400;
nTa = length(Ta);

for i = 1:nTa
    [CurrentTa_sol(i),v,info] = fsolve(Ta(i),list(CatenaryCableEqn,x,w,y0,y),deriv_CatenaryCableEqn,Tol);

end
disp([Ta' CurrentTa_sol],'The solution corresponding to different initial guess values')


input("Press enter to proceed ")
mprintf('The variation of y as the the values of x varies from -50 to 100 is plotted \n')
x = 10:10:100;
y = (Ta_sol/w)*cosh((w.*x)/Ta_sol) + y0 - (Ta_sol/w)
plot(x,y,'r*')
xlabel("x", "fontsize", 5);
ylabel("y", "fontsize", 5)


