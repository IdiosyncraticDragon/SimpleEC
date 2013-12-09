function [Xoptima,FitnessOptimum] = PSO(dimensionSize,landscape,boundary,populationSize,simulationLimit)
%Particle Swarm Optimization
%dimensionSize --- is the size of each individual;  landscape -- is the fitness function
%boundary --- is the value area of the individual;
%velocity adjustment: v = w*v + c1*rand()*(pbest - present) + c2*rand()*(pbest[gbest] - present)
%position adjustment: x = x+v;

w = 1;
c1 = 2;
c2 = 2;
resolution = 100;
Vmax = (boundary(2)-boundary(1))/resolution;

pbest = [];
present = [];
fitnessPoul = [];
v = [];
gbest = 1;% the subscript of pbest to specify the best in pbest;
%initialize the population,and it's speed
    for i = 1 : populationSize,
    	individual = [];
    	soloSpeed = [];
         for j = 1 : dimensionSize,
         	individual = [individual,boundary(1)+(boundary(2)-boundary(1))*rand()];
         	soloSpeed = [soloSpeed,Vmax*rand()];
         end
         present = [present;individual];
         v = [v;soloSpeed];
    end
%initialize the pbest and present
pbest = present;
%intialize the gbest
    for i = 1 : populationSize,
    	fitnessPoul = [fitnessPoul;landscape(pbest(i,:))];
    end
tempGbest = find(fitnessPoul == max(fitnessPoul));
gbest = tempGbest(1);

%evoluation
for i = 1 : simulationLimit,%per simulation
	for j = 1 : populationSize,%per individual
		for k = 1 : dimensionSize,%per character
			present(j,k) = present(j,k) + v(j,k); % update the postion of the specific dimension of the individual
			v(j,k) = w*v(j,k) + c1*rand()*(pbest(j,k) - present(j,k)) + c2*rand()*(pbest(gbest,k) - present(j,k));%update the speed in the specific dimension of the individual
		end
		%calculate the fitness ot the updated individual
		fitness = landscape(present(j,:));
		%update the pbest if this individual perform better then before
		if fitness > fitnessPoul(j),
			fitnessPoul(j) = fitness;
			%pbest(k,:) = present(k,:);
            pbest(j,:) = present(j,:);
		end
	end
	%update the global optimum
	tempGbest = find(fitnessPoul == max(fitnessPoul));
	if fitnessPoul(gbest) < fitnessPoul(tempGbest(1)),
		gbest = tempGbest(1);
	end
end
% fprintf('Result:\n\tpopulation:\n');
% disp(present);
% fprintf('\tGlobal best fitness:\n');
% disp(gbest);
% disp(fitnessPoul(gbest));
FitnessOptimum = fitnessPoul(gbest);
Xoptima = pbest(gbest,:);
end