//Reference :H.A. Eiselt and C.-L.SAndblom,"Linear Programming and its Applications",Springer-Verlag Berlin Heidelberg 2007,chapter 2.9

//The public works department of a region has issued contracts for five new projects. Each of the three contractors who have shown interest in the projects has submitted bids for those projects. The bids given by contactors are as given below
// =====================================================================
//             Project1    Project2    Project3    Project4    Project5
// ---------------------------------------------------------------------
// Contractor1   20           -           10           9           15
// Contractor2   18           12          13           8           16
// Contractor3   -            11          12           7          17
// =====================================================================
//The resource requirement of the contractors for each projects and the total resources available with them are as given
// =============================================================================
//             Project1 Project2 Project3 Project4 Project5 Available Resources
// -----------------------------------------------------------------------------
// Contractor1   70        -        40        30       50           120
// Contractor2   65        45       40        35       55           100
// Contractor3   -         45       35        40       50            70
// ============================================================================
//The objective of the contractors is to minimize the total cost
clc; 
nProjects = 5; 
nContractors = 3; 
bids = [20 10000 10 9 15;18 12 13 8 16; 10000 11 12 7 17]; 
reqResource = [70 10000 40 30 50;65 40 40 35 55; 10000 45 35 40 50]; 
availResource = [120; 100; 70];

nVar = nProjects*nContractors; // Calculated the dimension of the problem
IntCon = 1:nVar; // Indicating the integer variables
lb = zeros(1,nVar);
ub = ones(1,nVar);

// Linear constraints
// Linear equality constraints

beq = ones(nProjects,1);
for i = 1:nProjects
    Aeq(i,i:nProjects:nVar) = 1;
end

// Linear inequality constraints
b = availResource;
for j = 1:nContractors
    index = (j-1)*nProjects+1:j*nProjects;
    A(j,index) = reqResource(j,:);    
end

// Objective function
for j = 1:nContractors
    index = (j-1)*nProjects+1:j*nProjects;
    Cost(index,1) = bids(j,:)';
end

options = list("time_limit", 2500);
[xopt,fopt,status,output] = symphonymat(Cost,IntCon,A,b,Aeq,beq,lb,ub,options);

// Result representation
select status
case 227     
    disp(" Optimal Solution Found")
case 228
    disp("Maximum CPU Time exceeded")
case 229
    disp("Maximum Number of Node Limit Exceeded")
case 230
    disp("Maximum Number of Iterations Limit Exceeded.")
end

for j = 1:nContractors
    index = (j-1)*nProjects+1:j*nProjects;
    Contractor(j).Project = string(find(xopt(index)==1));
end
ResolurceUtilized = ((A*xopt)./b)*100;

for j = 1:nContractors
    disp(strcat(["Projects assigned to contractor",string(j)," : ", Contractor(j).Project],' '));
    disp(strcat(["Resource utilized by contractor ",string(j)," : ",string(ResolurceUtilized(j)),"%"]));
end
disp(strcat(["Total cost : ",string(fopt)]))

