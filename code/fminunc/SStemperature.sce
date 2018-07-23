//Reference: S.S. Rao,Engineering Optimization Theory and Practice, 3rd enlarged edition, New age international publishers,2011,chapter 6
// The steady state temperature (t1 and t2) at two points (mid point and the free end) of the one dimensional fin correspond to the minimum of the function. 
//   f(t1,t2) = 0.6382*t(1)^2 + 0.3191*t(2)^2 - 0.2809*t(1)*t(2) - 67.906*t(1) - 14.29*t(2)
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
function f  = ObjectiveFunction(t)
    f = 0.6382*t(1)^2 + 0.3191*t(2)^2 - 0.2809*t(1)*t(2) - 67.906*t(1) - 14.29*t(2);
endfunction
// Initial guess
x0 = [100 200];
disp(x0, "Initial guess given to the solver is ")
input("Press enter to proceed: ")
[xopt,fopt,exitflag,output,gradient,hessian] = fminunc(ObjectiveFunction,x0)
// Result representation
clc
select exitflag
case 0 
    disp("Optimal Solution Found")
    disp(xopt', "The steady state temperature at the points are")
    disp(fopt, "The optimum objective function value is")
case 1
    disp("Maximum Number of Iterations Exceeded. Output may not be optimal.")
    disp(xopt', "The temperature at the points are")
    disp(fopt, "The objective function value is")
case 2
    disp("Maximum CPU Time exceeded. Output may not be optimal.")
    disp(xopt', "The temperature at the points are")
    disp(fopt, "The objective function value is")
case 3
    disp("Stop at Tiny Step.")
    disp(xopt', "The temperature at the points are")
    disp(fopt, "The objective function value is")
case 4
    disp("Solved To Acceptable Level.")
    disp(xopt', "The temperature at the points are")
    disp(fopt, "The objective function value is")
case 5 
    disp("Converged to a point of local infeasibility.")
end

disp(output)
