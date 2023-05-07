function word = discrete_rnd(states, probVector,N)
    word = '';
    for k=1:N
        U=rand();
        i = 1 + sum(U > cumsum(probVector));
        state= states(i);
        word = [word  state];
    end
end