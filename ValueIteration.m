function [ J_opt, u_opt_ind ] = ValueIteration(P, G)
%VALUEITERATION Value iteration
%   Solve a stochastic shortest path problem by Value Iteration.
%
%   [J_opt, u_opt_ind] = ValueIteration(P, G) computes the optimal cost and
%   the optimal control input for each state of the state space.
%
%   Input arguments:
%
%       P:
%           A (K x K x L)-matrix containing the transition probabilities
%           between all states in the state space for all control inputs.
%           The entry P(i, j, l) represents the transition probability
%           from state i to state j if control input l is applied.
%
%       G:
%           A (K x L)-matrix containing the stage costs of all states in
%           the state space for all control inputs. The entry G(i, l)
%           represents the cost if we are in state i and apply control
%           input l.
%
%   Output arguments:
%
%       J_opt:
%       	A (K x 1)-matrix containing the optimal cost-to-go for each
%       	element of the state space.
%
%       u_opt_ind:
%       	A (K x 1)-matrix containing the index of the optimal control
%       	input for each element of the state space. Mapping of the
%       	terminal state is arbitrary (for example: HOVER).
global K HOVER NORTH WEST EAST SOUTH
global TERMINAL_STATE_INDEX
%% INITIALIZATION
L = 5;
J_opt = zeros(K,1);
Q = zeros(L,1);
u_opt_ind = -1 * ones(K,1);

%% NAIVE VALUE ITERATION
J_opt_old = J_opt;
ite = 0;
while 1
    ite = ite + 1;
    for i = 1:1:K
        for action = [NORTH, WEST, EAST, SOUTH, HOVER]
            Q(action) = G(i, action) + P(i, :, action)*J_opt_old;
        end
        [J_opt(i), u_opt_ind(i)] = min(Q);
    end
    % TERMINATION CONDITION
    if max(abs(J_opt - J_opt_old)) < 1e-5
        disp('Number of Iteration of VI');
        disp(ite);
        break;
    end
    J_opt_old = J_opt;
end

u_opt_ind(TERMINAL_STATE_INDEX) = HOVER;


%% Gauss-Seidal VALUE ITERATION
% ite = 0;
% while 1
%     ite = ite + 1;
%     maxdif = 0;
%     for i = 1:1:K
%         for action = [NORTH, WEST, EAST, SOUTH, HOVER]
%             Q(action) = G(i,action) + P(i, :, action)*J_opt;
%         end
%         [min_Q, idx] = min(Q);
%         % UPDATE POLICY
%         u_opt_ind(i) = idx;
%         maxdif = max(maxdif, abs(J_opt(i) - min_Q));
%         % UPDATE COST TO GO
%         J_opt(i) = min_Q;
%     end
%     % TERMINATION CONDITION
%     if maxdif < 1e-5
%         disp('Number of Iteration of Gauss-Seidal Method');
%         disp(ite);
%         break;
%     end
% end
% u_opt_ind(TERMINAL_STATE_INDEX) = HOVER;

end