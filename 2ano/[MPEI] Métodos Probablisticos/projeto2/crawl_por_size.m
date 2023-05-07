function state = crawl_por_size(H, first, last,N)
% the sequence of states will be saved in the vector "state"
% initially, the vector contains only the initial state:
state = [first]; %#ok<*NBRAK>
% keep moving from state to state until state "last" is reached:
while (1)
if(N == 1)
break;
end
state(end+1) = nextState(H, state(end)); %#ok<*AGROW>
if ((state(end) == last) || (length(state) == N) )
break;
end
end
end
% Returning the next state
% Inputs:
% H - state transition matrix
% currentState - current state
function state = nextState(H, currentState)
% find the probabilities of reaching all states starting at the current one:
probVector = H(:,currentState)'; % probVector is a row vector
n = length(probVector); %n is the number of states
% generate the next state randomly according to probabilities probVector:
state = discrete_rnd(1:n, probVector);
end
% Generate randomly the next state.
% Inputs:
% states = vector with state values
% probVector = probability vector
function state = discrete_rnd(states, probVector)
U=rand();
i = 1 + sum(U > cumsum(probVector));
state= states(i);
end