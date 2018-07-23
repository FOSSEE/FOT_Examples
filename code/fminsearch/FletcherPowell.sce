// This is an example for unconstraint nonlinear problems.
// Ref:R.fletcher and M.J.D Powell, A Rapidly Convergent Descent Method for Minimization Algorithms, Computer journal, Vol. 6, pp. 163-168, 1963
//Example: 
//f(x1,x2,x3) = 100*((x3 - 10*theta(x1,x2))^2 + (sqrt(x1^2 + x1^2) - 1)^2) + x3^2
//theta(x1,x2) = (atan(x(2)/x(1)))/(2*%pi)  if x(1)>0 
//             = %pi + atan(x(2)/x(1))      if x(1)<0
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

clc;clear;close

function y  = FletcherPowell(x)
    if  (x(1)>0) 
        theta_x1x2 = (atan(x(2)/x(1)))/(2*%pi);
    elseif  (x(1)<0)
        theta_x1x2 = %pi + atan(x(2)/x(1));
    end
    y = 100*( (x(3) - 10*theta_x1x2 ).^2 + (sqrt(x(1)^2 + x(2)^2) - 1)^2) + x(3)^2;
endfunction

X0 = [-1 0 0];
MFes = 500;
Miter = 200;
TF = 1D-10;
TX = 1D-10;
mprintf('The following settings are used\n Maximum iterations %d \n maximum functional exaluations %d\n Function tolerance %s \n variable tolerance %s ',Miter,MFes,string(TF),string(TX));
input('Press enter to proceed ')
clc;
mprintf('Scilab is solving the problem...')

options = optimset ("MaxFunEvals",MFes,"MaxIter",Miter,"PlotFcns",optimplotfval,"TolFun",TF,"TolX",TX);

[x,fval,exitflag,output] = fminsearch(FletcherPowell,X0,options)
clc
select exitflag
case -1
    disp(output.algorithm, 'Algorithm used')
    mprintf('\n The maximum number of iterations has been reached \n')
    mprintf('\n The number of iterations %d ',output.iterations)
    mprintf('\n The number of function evaluations %d',output.funcCount)
case 0
    disp(output.algorithm, 'Algorithm used ')
    mprintf('\n The maximum number of function evaluations has been reached \n') 
    mprintf('\n The number of function evaluations %d',output.funcCount)
    mprintf('\n The number of iterations %d ',output.iterations)

case 1
    disp(output.algorithm, 'Algorithm used ')
    mprintf('\n The tolerance on the simplex size and function value delta has been reached\n')
    mprintf('\n The number of function evaluations %d',output.funcCount)
    mprintf('\n The number of iterations %d ',output.iterations)
end

disp(x,"The optimal solution is")
mprintf("\n The optimum value of the function is %s",string(fval))
