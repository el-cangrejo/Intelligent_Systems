%% ----- Initialization Phase ----- %%

% Parameters:

w = 0.2;
c1 = 0.1;
c2 = 0.9;
num_pop = 25;
max_iter = 1000;

% Initialize:

swarm = zeros(num_pop, 4);
velocity = zeros(num_pop, 4);

for i = 1 : num_pop
    swarm(i, 1) = 10 + 70 * rand();
    swarm(i, 2) = 10 + 40 * rand();
    swarm(i, 3) = 0.9 + 4.1 * rand();
    swarm(i, 4) = 0.9 + 4.1 * rand();
    
    velocity(i, 1) = 0.2 * (10 + 70 * rand());
    velocity(i, 2) = 0.2 * (10 + 40 * rand());
    velocity(i, 3) = 0.2 * (0.9 + 4.1 * rand());
    velocity(i, 4) = 0.2 * (0.9 + 4.1 * rand());
end

% Find Best Position:

particle_best_pos = swarm;
swarm_best_pos = swarm(1,:);

for i = 2 : num_pop
    if I_BEAM(swarm(i,:)) < I_BEAM(swarm_best_pos) 
        swarm_best_pos = swarm(i,:);
    end
end

%% ----- Search Phase ----- %%

iter = 0;

while iter < max_iter 
    for i = 1 : num_pop
        % Calculate Velocity
        velocity(i, 1) = w * velocity(i, 1) + ...
                c1 * rand() * (particle_best_pos(i, 1) - swarm(i,1)) + ...
                c2 * rand() * (swarm_best_pos(1, 1) - swarm(i, 1));
        velocity(i, 2) = w * velocity(i, 2) + ...
                c1 * rand() * (particle_best_pos(i, 2) - swarm(i,2)) + ...
                c2 * rand() * (swarm_best_pos(1, 2) - swarm(i, 2));
        velocity(i, 3) = w * velocity(i, 3) + ...
                c1 * rand() * (particle_best_pos(i, 3) - swarm(i,3)) + ...
                c2 * rand() * (swarm_best_pos(1,3) - swarm(i, 3));
        velocity(i, 4) = w * velocity(i, 4) + ...
                c1 * rand() * (particle_best_pos(i, 4) - swarm(i,4)) + ...
                c2 * rand() * (swarm_best_pos(1, 4) - swarm(i, 4));

        % Calculate Position
        new_pos = swarm(i, :) + velocity(i, :);

        % Check Contraints
        if new_pos(1, 1) < 10 
            new_pos(1, 1) = 10;
        end
        if new_pos(1, 1) > 80 
            new_pos(1, 1) = 80;
        end
        if new_pos(1, 2) < 10 
            new_pos(1, 2) = 10;
        end
        if new_pos(1, 2) > 50 
            new_pos(1, 2) = 50;
        end
        if new_pos(1, 3) < 0.9 
            new_pos(1, 3) = 0.9;
        end
        if new_pos(1, 3) > 5 
            new_pos(1, 3) = 5;
        end
        if new_pos(1, 4) < 0.9 
            new_pos(1, 4) = 0.9;
        end
        if new_pos(1, 4) > 5 
            new_pos(1, 4) = 5;
        end
        
        % Calculate Performance and Update Position
        if I_BEAM(new_pos) < I_BEAM(particle_best_pos(i, :))
            particle_best_pos(i, :) = new_pos;
        end
        
        swarm(i, :) = new_pos;
        
    end
    
    for i = 1 : num_pop
        if I_BEAM(swarm(i,:)) < I_BEAM(swarm_best_pos) 
            swarm_best_pos = swarm(i,:);
        end
    end
        
    iter = iter + 1;
end

best_solution = swarm_best_pos
best_value = I_BEAM(swarm_best_pos)
