function [Xoptima,FitnessOptimum] = EDA(dimensionSize,landscape,boundary,lambda,miu,simulationLimit)
%estimation of distribution algorithms
%lambda is the population size 
if miu > lambda,
	miu = lambda;
end

population = [];
parents = [];
offsprings = [];
fitnesspoul = [];

%initialize the population
for i = 1:lambda,
	individual = [];
	for j=1:dimensionSize,
		individual = [individual,boundary(1)+(boundary(2) - boundary(1))*rand()];
	end
	population = [population;individual];
end

simulationCounts = 0;
while simulationCounts < simulationLimit, 
	simulationCounts = simulationCounts+1;
    %fprintf('simulation circle %d\n',simulationCounts);
    offsprings = [];
    fitnesspoul = [];
	%evaluate the population
	for i = 1:lambda,
		fitnesspoul = [fitnesspoul;landscape(population(i,:))];
	end

	%select about miu individuals in population as the parents
	[tempSorted,tempindex] = sort(fitnesspoul(:),'descend');
	topMiuInedices = tempindex(1:miu);
	parents = population(topMiuInedices(:),:);

	%generate the probability distribution
	MeanOfParent = mean(parents);
	VarOfParent = power(var(parents)*(miu-1)/miu,0.5);%the var normalize parents by miu-1	
	for i = 1:lambda,
        %tempIndividual = normrnd(MeanOfParent,VarOfParent);
        %while min(tempIndividual)<boundary(1) | max(tempIndividual) > boundary(2),
            %tempIndividual = normrnd(MeanOfParent,VarOfParent);
            tempIndividual = randn(1,dimensionSize).*VarOfParent + MeanOfParent;
        %end
		offsprings = [offsprings;tempIndividual];
	end

	population = offsprings;
end
fitnesspoul = [];
for i = 1:lambda,
	fitnesspoul = [fitnesspoul;landscape(population(i,:))];
end

%fprintf('The Results:\n');
%bestIndex = find(fitnesspoul == max(fitnesspoul));
%fprintf('fitness:\n')
%disp(fitnesspoul(bestIndex(1)));
%fprintf('individual:\n')
%disp(population(bestIndex(1),:));
bestIndex = find(fitnesspoul == max(fitnesspoul));
FitnessOptimum = fitnesspoul(bestIndex(1));
Xoptima = population(bestIndex(1),:);