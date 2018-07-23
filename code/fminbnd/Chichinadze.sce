//Reference: Ernesto P. Adorio and U.P. Diliman,"MVF - Multivariate Test Functions
//Library in C for Unconstrained Global Optimization",2005,
//http://www.geocities.ws/eadorio/mvf.pdf, Last accessed, 11th June 2018
//Example: The 2-dimensional function mvfChichinadze computes
//f = x1^2 - 12*x1 + 11 + 10*cos(%pi/2*x1)) + 8*sin(5*%pi*x1)) - 1/sqrt(5)*exp(-(x2)-0.5)^2/2)
//with domain −30 ≤ x0 ≤ 30, −10 ≤ x1 ≤ 10. The global minimum is 43.3159 at (5.90133, 0.5).
//

clc;
//Objective Function 
function f = Chichinadze(x)
    f = x(1)^2 - 12*x(1) + 11 + 10*cos(%pi/2*x(1)) + 8*sin(5*%pi*x(1)) - 1/sqrt(5)*exp(-(x(2)-0.5)^2/2)
endfunction

//Lower bound on the variables
x1 = [-30 -10];
//Upper bound on the variables
x2 = [30 10];

Maxit = 1500;
CPU = 100;
Tolx = 1e-6;

mprintf('The termination criteria is as follows: Maximum Iterations = %d, Maximum CPU time = %d, Tolerance on solution  = %f',Maxit,CPU,Tolx);

//Options structure 
options=list("MaxIter",Maxit,"CpuTime", CPU,"TolX",Tolx)

[xopt,fopt,exitflag,output,lambda]=fminbnd(Chichinadze,x1,x2,options)

// Result representation
clc; 
select exitflag
case 0 
    disp("Optimal Solution Found")
    disp(xopt',"The optimum solution obtained is")
    disp(fopt,"The objective function value is")
case 1 
    disp("Maximum Number of Iterations Exceeded. Output may not be optimal")
    disp(xopt,"The solution obtained")
    f = Chichinadze(xopt)
    disp(f,"The objective function value is")
case 2
    disp("Maximum CPU Time exceeded. Output may not be optimal")
    disp(xopt,"The solution obtained")
    f = Chichinadze(xopt)
    disp(f,"The objective function value is")
case 3 
    disp("Stop at Tiny Step")
    disp(xopt,"The solution obtained")
    f = Chichinadze(xopt)
    disp(f,"The objective function value is")
case 4 
    disp("Solved To Acceptable Level")
    disp(xopt,"The solution obtained")
    f = Chichinadze(xopt)
    disp(f,"The objective function value is")
case 5
    disp("Converged to a point of local infeasibility")
    disp(xopt,"The solution obtained")
    f = Chichinadze(xopt)
    disp(f,"The objective function value is")
end
disp(output)
