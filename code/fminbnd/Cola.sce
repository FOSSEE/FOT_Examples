//Reference: Ernesto P. Adorio and U.P. Diliman,"MVF - Multivariate Test Functions
//Library in C for Unconstrained Global Optimization",2005,
//http://www.geocities.ws/eadorio/mvf.pdf, Last accessed, 11th June 2018
//Example: The 17-dimensional function mvfCola computes indirectly the formula f(n,u)
//by setting x0 = y0, x1 = u0, x(i) = u(2(i−2)), y(i) = u(2(i−2)+1)
//f(n,u) = h(x,y) =sum((r(i,j) − d(i,j))^2) for all j<i
//r(i,j) = [(x(i) − x(j) )^2 + (y(i) − y(j))^2]^1/2
//This function has bounds 0 ≤ x0 ≤ 4 and −4 ≤ xi ≤ 4 for i = 1 . . . n − 1. It
//has a global minimum of 11.7464.
//u = [0.651906,1.30194,0.099242,-0.883791,-0.8796,0.204651,-3.28414,0.851188,-3.46245,2.53245,-0.895246,1.40992,-3.07367,1.96257,-2.97872,-0.807849,-1.68978];
//

clc;
//Objective Function
function summation = Cola(u)

    d = [   0    0    0    0    0    0    0    0    0   0
            1.27 0    0    0    0    0    0    0    0.  0 
            1.69 1.43 0    0    0    0    0    0    0   0
            2.04 2.35 2.43 0    0    0    0    0    0   0
            3.09 3.18 3.26 2.85 0    0    0    0    0   0
            3.20 3.22 3.27 2.88 1.55 0    0    0    0   0
            2.86 2.56 2.58 2.59 3.12 3.06 0    0    0   0
            3.17 3.18 3.18 3.12 1.31 1.64 3.00 0    0   0
            3.21 3.18 3.18 3.17 1.70 1.36 2.95 1.32 0   0
            2.38 2.31 2.42 1.94 2.85 2.81 2.56 2.91 2.97 0];
    summation = 0;

    for i = 1:10
        for j = 1:9    
            if j<i
                x(1) = 0; y(1) = 0;y(2) = 0; x(2)= u(1);
                if i>2
                    x(i) = u(2*(i-2));y(i) = u(2*(i-2)+1);
                end
                r(i,j) = ((x(i) - x(j))^2 + (y(i)-y(j))^2)^0.5;               
                summation = summation + (( r(i,j) - d(i,j) )^2)
            end    
        end
    end

endfunction


//Lower bound
x1 = [0 -4*ones(1,16)];
//Upper bound
x2 = 4*ones(1,17);

//Options structure
options=list("MaxIter",[1500],"CpuTime", [100],"TolX",[1e-6])

[xopt,fopt,exitflag,output,lambda]=fminbnd(Cola,x1,x2,options)

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
    f = Cola(xopt)
    disp(f,"The objective function value is")
case 2
    disp("Maximum CPU Time exceeded. Output may not be optimal")
    disp(xopt',"The solution obtained")
    f = Cola(xopt)
    disp(f,"The objective function value is")
case 3 
    disp("Stop at Tiny Step")
    disp(xopt',"The solution obtained")
    f = Cola(xopt)
    disp(f,"The objective function value is")
case 4 
    disp("Solved To Acceptable Level")
    disp(xopt',"The solution obtained")
    f = Cola(xopt)
    disp(f,"The objective function value is")
case 5
    disp("Converged to a point of local infeasibility")
    disp(xopt',"The solution obtained")
    f = Cola(xopt)
    disp(f,"The objective function value is")
end
disp(output)

