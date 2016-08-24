%% Parameters %%
num_pop = 45; % Population Number
factor = 0.1; % Scaling Factor
cross_rate = 0.2; % Crossover Rate
max_iter = 1000; % Maximum Number of Iterations

Pop = zeros(num_pop, 4);

%% Initialization phase %%

for i = 1 : num_pop
    Pop(i, 1) = 10 + 70 * rand();
    Pop(i, 2) = 10 + 40 * rand();
    Pop(i, 3) = 0.9 + 4.1 * rand();
    Pop(i, 4) = 0.9 + 4.1 * rand();
end

%% Differential Evolution Algorithm %%
iterations = 0;
while iterations < max_iter
    NewPop = Pop;

    % For every member of the population
    for j = 1 : num_pop
        Parent = Pop(j,:);
        
        % We choose three random members
        X1 = randi([1, num_pop]);
        while (X1 == j)
            X1 = randi([1, num_pop]);
        end
        X2 = randi([1, num_pop]);
        while (X2 == X1 || X2 == j)
            X2 = randi([1, num_pop]);
        end
        X3 = randi([1, num_pop]);
        while (X3 == X1 || X3 == X2 || X3 == j)
            X3 = randi([1, num_pop]);
        end    
        
        Xr1 = Pop(X1,:);
        Xr2 = Pop(X2,:);
        Xr3 = Pop(X3,:);
        
        % Compute the mutant member
        Vi = Xr1 + factor * (Xr2 - Xr3);
        Ui = zeros(1,4);
        
        % Replicate from parent
        for k = 1 : 4
            if rand() <= cross_rate
                if k == 1 || k == 2 && Vi(k) < 10
                    Vi(k) = 10;
                end
                if k == 1 && Vi(k) > 80
                    Vi(k) = 80;
                end
                if k == 2 && Vi(k) > 50
                    Vi(k) = 50;
                end
                if k == 3 || k == 4 && Vi(k) < 0.9
                    Vi(k) = 0.9;
                end
                if k == 3 || k == 4 && Vi(k) > 5
                    Vi(k) = 5;
                end
                Ui(k) = Vi(k);
            else
                Ui(k) = Parent(k);
            end
        end
        
        % Select parent or child for the new population
        if I_BEAM(Ui) < I_BEAM(Parent)
            Yi = Ui;
        else
            Yi = Parent;
        end
        
        NewPop(j,:) = Yi;
    end
    
    iterations = iterations + 1;
    Pop = NewPop;
end

%% Find Best Candidate %%
best = 1;
for i = 2 : num_pop
    if I_BEAM(Pop(best,:)) > I_BEAM(Pop(i,:))
        best = i;
    end
end

Best_Solution = Pop(best,:)
Best_Value = I_BEAM(Pop(best,:))