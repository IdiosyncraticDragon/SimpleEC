function [Xoptima,FitnessOptimum] = DE(dimensionSize,landscape,boundary,populationSize,simulationLimit)
%Differentiable evolution
%dimensionSize is the dimension size of each individual; landscape is the cost function
%boundary is the limitation of value space;populationSize is the size of population
%simulationLimit is the times of simulation
%this algorithm is different from the PSO and GA on the landscape, since in the GA and PSO we search for
%better fitness so we select the high fitness to survive(although it's easy to change it to oppsite);And
%in DE, we thought we need low cost in default.

%global variable definitions
parentVectors = [];
mutationVectors = [];
offspringVectors = [];
cost = [];
trail = [];
F = 1;% 0<=F<=2
CR = 0.5;
 
%initial the population
	for i = 1:populationSize,
		individual = [];
		for j = 1:dimensionSize,
			individual = [individual,(boundary(2)-boundary(1))*rand()];
		end
		parentVectors = [parentVectors;individual];
		cost = [cost;landscape(individual)];
	end
%initialize mutation vectors and offspring vectors
offspringVectors = parentVectors;
mutationVectors = offspringVectors;
%start simulation
	for k = 1:simulationLimit,
        if populationSize < 3,
            break;%we need three different vectors to run this algorithm!
        end
		for i = 1:populationSize,
			%mutation
			%choose three different individuals also different from i
			r1 = getDifferentRandomIndex([i],[1,populationSize]);
			r2 = getDifferentRandomIndex([i,r1],[1,populationSize]);
			r3 = getDifferentRandomIndex([i,r1,r2],[1,populationSize]);

			mutationVectors(i,:) = parentVectors(r1,:) + F*(parentVectors(r2,:) - parentVectors(r3,:));
			%crossover
			for j = 1:dimensionSize,
				if rand() <= CR,%crossover happen
					offspringVectors(i,j) = mutationVectors(i,j);
				else
					offspringVectors(i,j) = parentVectors(i,j);
				end
			end
			%selection
			score = landscape(offspringVectors(i,:));
			if score < cost(i),
				cost(i) = score;
				parentVectors(i,:) = offspringVectors(i,:);
			end
		end
	end

minimumIndices = find(cost == min(cost));
miniIndex = minimumIndices(1);
%fprintf('Result:\n');
%fprintf('\tbest individuals:\n');
%disp(parentVectors(miniIndex,:));
%fprintf('\tbest cost:\n');
%disp(cost(miniIndex));
FitnessOptimum = cost(miniIndex);
Xoptima = parentVectors(miniIndex,:);
end

function randomIndex = getDifferentRandomIndex(existIndices,boundary)
	randomIndex = existIndices(1);
	while any(existIndices == randomIndex),
		randomIndex =(boundary(2)-boundary(1))*rand();
		randomIndex = ceil(randomIndex)+boundary(1);
	end
end