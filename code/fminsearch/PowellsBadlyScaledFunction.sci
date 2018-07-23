// This is an example for unconstrained multivariable problem
// Name of the function : Powell's Badly Scaled function
// f(x1,x2) = (10000 x1.x2 - 1)^2 + [exp(-x1) + exp(-x2) - 1.0001]^2

// Reference: M.J.D Powell, A hybrid method for non-linear equations, pp.87-114 in numerical methods for non-linear algebraic equations,P.Rabinowitz,Ed.,Gorden and Breach,Newyork,1970
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

function f = PowellsBadlyScaled(X)
    f = (10000*X(1)*X(2) -1)^2 + (exp(-X(1)) + exp(-X(2)) - 1.0001)^2;
endfunction

X0 = [0 0];
Parameter.X_Tol = 1.e-16;
Parameter.F_Tol = 1.e-16;
Parameter.maxFE = 1000;
Parameter.maxIt = 400;
mprintf("The values set for the configurable options are as below")
disp(Parameter);
input("Press enter to proceed ")

opt = optimset ("TolX",Parameter.X_Tol,"TolFun",Parameter.F_Tol,"MaxFunEvals",Parameter.maxFE,"MaxIter",Parameter.maxIt,"PlotFcns" , optimplotfval);

[x,fval,exitflag,output] = fminsearch(PowellsBadlyScaled,X0,opt)

clc
select exitflag
case -1
    mprintf('The maximum number of iterations has been reached \n')   
case 0
    mprintf('The maximum number of function evaluations has been reached \n') 
case 1
    mprintf('The tolerance on the simplex size and function value delta has been reached \n')
end

disp(x,"The optimal solution is")
disp(fval,"The optimum value of the objective function is")
disp(output)
