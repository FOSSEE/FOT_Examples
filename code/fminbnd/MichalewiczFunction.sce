//Reference: Michalewicz, Z.: Genetic Algorithms + Data Structures = Evolution Programs. Berlin, Heidelberg, New York: Springer-Verlag, 1992

// MICHALEWICZ FUNCTION
clc; 
function f = ObjectiveFunction(X)
    m = 10;
    nVar = length(X);
    d = length(X);
    f = 0;
    for n = 1:nVar
        f = f - sin(X(n))*((sin((n*X(n)^2)/%pi))^(2*m));
    end

    f = -f;
endfunction

nVar = 2;
lb = zeros(1,nVar);
ub = %pi*ones(1,nVar);
[xopt,fopt,exitflag,output,lambda] = fminbnd(ObjectiveFunction,lb,ub)

disp (nVar)
disp(fopt)
disp(xopt')





