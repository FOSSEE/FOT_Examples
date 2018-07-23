//Reference: Edgar, Himmelblau and Lasdon,"Optimization of Chemical Processes",2nd Ed,McGraw-Hill Chemical Engineering Series,chapter 6

//The cost of refined oil when shipped via the Malacca Straits to Japan in dollars per kiloliter was given as the linear sum of the crude oil cost, the insurance, customs, freight cost for the oil, loading and unloading cost, sea berth cost, submarine pipe cost, storage cost, tank areacost, refining cost, and freight cost of products. Compute the minimum cost of oil and the optimum tanker size t and refinery size.

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

function f = ObjectiveFunction(X)
    t = X(1); q = X(2);
    Cc = 12.5; // Crude oil price ($/kL)
    Ci = 0.5; // insurance cost ($/kL)
    Cx = 0.9; // customs cost ($/kL)
    a = 0.2; // anual fixed charges,fraction
    p = 7000; // land prices ($/square meter)
    n = 2; // number of ports
    i = 0.1; // interest rate
    Term1 = (52.47*q*360);
    Term2 = (n*t+1.2*q);
    f = Cc + Ci + Cx + (2.09 *10^4*t^-0.3017)/360 +...
    (1.064*10^6*a*t^0.4925)/Term1+...
    (4.242*10^4*a*t^0.7952 + 1.813*i*p*Term2^0.861)/Term1...
    +(4.25*10^3*a*Term2)/Term1 + (5.042*10^3*q^-0.1899)/360 +... 
    (0.1049*q^0.671)/360;
endfunction 


function stop=outfun(x, optimValues, state)
    subplot(1,2,1)
    plot(optimValues.iteration,optimValues.fval,'rp');
    xlabel('Iteration');ylabel('fval')

    subplot(1,2,2)
    plot(optimValues.iteration,x(1),'b*');
    plot(optimValues.iteration,x(2),'g*');
    legend(['Tanker size','Refinery size'])
    set(gca(),"auto_clear","off")
    xlabel('Iteration');ylabel('variable values')

    stop = %f
endfunction
designParameters = {"Tanker size","Refinery size"}
X0 = [15000 20000];
designParameter = {'Tanker size(kL)','Refinery capacity(bbl/day)'};
intGuess = [designParameter;string(X0)];
disp(intGuess,"Initial guess given to the solver")
input('Press enter to proceed: ')
Parameter.X_Tol = 0;
Parameter.F_Tol = 0;
Parameter.maxFE = 1000;
Parameter.maxIt = 100;
opt = optimset ("TolX",Parameter.X_Tol,"TolFun",Parameter.F_Tol,"MaxFunEvals",Parameter.maxFE,"MaxIter",Parameter.maxIt,"OutputFcn",outfun);

[x,fval,exitflag,output] = fminsearch(ObjectiveFunction,X0,opt)

clc;
select exitflag
case -1
    mprintf('The maximum number of iterations has been reached \n')
    mprintf('Function Count: %d ',output.funcCount)
case 0
    mprintf('The maximum number of function evaluations has been reached \n')    
    mprintf(' Iteration Count: %d ',output.iterations)

case 1
    mprintf('The tolerance on the simplex size and function value delta has been reached \n')
    mprintf('Function Count: %d ',output.funcCount)       
    mprintf('Iteration Count: %d ',output.iterations)
end
optSol = [designParameter;string(x)];
disp(optSol,"The optimum solution obtained")
disp(fval,"The minimum cost of the oil is")
