//Ref:Steven C. Chapra. 2006. Applied Numerical Methods with MATLAB for Engineers and Scientists. McGraw-Hill Science/Engineering/Math,Chapter 6
//Example:
//The Redlich-Kwong equation of state is given by
//p = ((R*T)/(v-b) - a/(v*(v+b)*sqrt(T)))
//where R = the universal gas constant [= 0.518 kJ/(kg K)], T = absolute temperature (K), p = absolute pressure (kPa),and v = the volume of a kg of gas (m3/kg). The parameters a and b are calculated by
// a = 0.427*(R^2*Tc^2.5)/pc; b = 0.0866*R*(Tc/pc);
//where pc = 4600 kPa and Tc = 191 K. As a chemical engineer, you are asked to determine the amount of methane fuel that can be held in a 3 m3 tank at a temperature of −40 ◦C with a pressure of 65,000 kPa. Use a root-locating method of your choice to calculate v and then determine the mass of methane contained in the tank.
//Note: The initial guess has to be assumed by the user. An improper initial guess will result in deviation from the root. 
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

function y = Redlich_Kwong(v)

    R = 0.518;T = 273+(-40);p = 65000;Tc = 191;pc = 4600;
    a = 0.427*(R^2*Tc^2.5)/pc; b = 0.0866*R*(Tc/pc);

    y = p - ( (R*T)/(v-b) - a/(v*(v+b)*sqrt(T)) );

endfunction

function dy =  dv_Redlich_Kwong(x)

    dy = numderivative(Redlich_Kwong, x);

endfunction

// Set of initial values to check 
x0 = [1 0.01 -1.0 -0.01] ;

tol = 1D-10;

for i =1:length(x0)

    disp(x0(i),'Initial guess value is')

    [x ,v ,info]=fsolve(x0(i),Redlich_Kwong ,dv_Redlich_Kwong ,tol)

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

    mprintf('\n volume of metheane is %f m3/kg and Mass of methane is %f kg\n',x,3/x);

    if i<length(x0)
        input('press enter to check the next initial guess value')
        clc
    end

end
