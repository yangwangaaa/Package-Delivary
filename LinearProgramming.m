function [ J_opt, u_opt_ind ] = LinearProgramming(P, G)
%LINEARPROGRAMMING Linear Programming
%   Solve a stochastic shortest path problem by Linear Programming.
%
%   [J_opt, u_opt_ind] = LinearProgramming(P, G) computes the optimal cost
%   and the optimal control input for each state of the state space.
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

global K HOVER EAST WEST NORTH SOUTH L

%% Handle terminal state
% Do yo need to do something with the teminal state before starting policy
% iteration ?
global TERMINAL_STATE_INDEX 
% IMPORTANT: You can use the global variable TERMINAL_STATE_INDEX computed
% in the ComputeTerminalStateIndex.m file (see main.m)

c = -1*ones(K-1,1);
L = 5;
Q = zeros(L,1);
u_opt_ind = -1*ones(K,1);
G(isinf(G)) = 100000;
b = [ ];
A = [ ];
I = eye(K-1);
row_col_idx = [1:TERMINAL_STATE_INDEX-1,TERMINAL_STATE_INDEX+1:K];
for action = [HOVER, EAST, NORTH, WEST, SOUTH]
    A = [A;
         I - P(row_col_idx,row_col_idx,action)];
    b = [b;
         G(row_col_idx,action)];
end
[J_opt, ~, ~] = linprog(c,A,b);
J_opt = [J_opt(1:TERMINAL_STATE_INDEX-1,:);0;J_opt(TERMINAL_STATE_INDEX:end,:)];
for i = 1:K
    for action = [HOVER, EAST, NORTH, WEST, SOUTH]
        Q(action) = G(i, action) + P(i, :, action)*J_opt;
    end
    [~, idx] = min(Q);
    u_opt_ind(i) = idx;
end
u_opt_ind(TERMINAL_STATE_INDEX) = HOVER;

