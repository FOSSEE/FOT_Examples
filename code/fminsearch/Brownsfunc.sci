// This is an example for unconstraint nonlinear problems.
//Ref:J. J. More, B. S. Garbow, and K. E. Hillstrom, Testing unconstrained optimization software, ACM Transactions on Mathematical Software, Vol. 7, No. 1, pp. 17–41, 1981.
//Example:
//f(x1,x2) = (x1 - 10^6)^2 + (x2 - 2*10^-6)^2 + (x1*x2 - 2)^2;
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
clc;close

function y = Brownsfunc(x)
    y = (x(1)-1d6)^2 + (x(2)-2*1D-6)^2 + (x(1)*x(2)-2)^2
endfunction

function stop=outfun(x, optimValues, state)
  subplot(1,2,1)
  plot(optimValues.funccount,optimValues.fval,'r.');
  xlabel('function count');ylabel('Objective value')
  
  subplot(1,2,2)
  plot(optimValues.funccount,x(1),'r.');
  plot(optimValues.funccount,x(2),'b.');
  legend(['X1','X2'])
  set(gca(),"auto_clear","off")
  xlabel('function count');ylabel('variable values')
   
  stop = %f
endfunction

X0 = [1 1];
MFes = 500;
Miter = 200;
TF = 1D-6;
TX = 1D-6;
mprintf('The following settings are used\n Maximum iterations %d \n maximum functional exaluations %d\n Function tolerance %s \n variable tolerance %s ',Miter,MFes,string(TF),string(TX));
mprintf('\nThe initial guess is x1 = %f and x2 = %f',X0(1),X0(2))
input('Press enter to proceed ')
clc;
mprintf('Scilab is solving the problem...')

options = optimset ("MaxFunEvals",MFes,"MaxIter",Miter,"TolFun",TF,"TolX",TX, "OutputFcn" , outfun);

[x,fval,exitflag,output] = fminsearch(Brownsfunc,X0,options)

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
