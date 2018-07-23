//Reference: Edger, Hemmelblau and Lasdon,"OPtimization of chemical process", McGraw Hill, Chemical Engineering Series, 2nd edition, 2001, Appendix A

//Solve the two non-linear equations
//   X(1)^2 + X(2)^2 = 8
//   X(1)*X(2) = 4
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
// Set of non-linear equations
function f = NLEquations(X)
    f(1) = X(1)^2 + X(2)^2 - 8
    f(2) = X(1)*X(2) - 4
endfunction
// Multiple initial guesses. User can give their choice of values here
Xinitials = [-5 0; 5 3]
Ninitial = size(Xinitials,1);
// Precision tolerance value
Tol = 0;

// Solving the equations with different initial guesses
for n = 1:Ninitial
    Xi = Xinitials(n,:);
    mprintf('Initial guess No. %d \n',n)
    disp(Xi)
    [X,v,info] = fsolve(Xi,NLEquations,[],Tol);
    // Result representation
    select info
    case 0
        disp("improper input parameters.")
    case 1
        disp("algorithm estimates that the relative error between x and the solution is at most tol.")
        disp(X,"solution reported")
        disp(v, "Value of the function at the solution")
    case 2
        disp("number of calls to fcn reached")
        disp(X,"solution reported")
        disp(v, "Value of the function at the solution")
    case 3
        disp("tol is too small. No further improvement in the approximate solution x is possible.")
        disp(X,"solution obtained")
        disp(v, "Value of the function at the solution")
    case 4
        disp("iteration is not making good progress.")
        disp(X,"solution obtained")
        disp(v, "Value of the function at the solution")
    end
end
