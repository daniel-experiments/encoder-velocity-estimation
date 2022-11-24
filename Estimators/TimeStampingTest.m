dt = 0.001; % timestep
N = 3;      % Number of samples

A = zeros(N,3,1);
for r=1:N
    A(r,:) = [((r-1)*dt)^2 (r-1)*dt 1];
end
Aprime = ((A'*A)^-1)*A';

ti = (N-1)*dt;
const_t_weights_x = [ti*ti ti 1]*Aprime;  
const_t_weights_v = [2*ti 1 0]*Aprime;
const_t_weights_a = [2 0 0]*Aprime;
% dot product the samples with their weights to get an estimate
% xi = dot(x(1:5), const_t_weights_x);


% Alternate method for different time at each sample
A1=sym('t',[N,1],'real');
A2=A1;
A3=ones(N,1);
A=[A1.*A1, A2, A3];
Aprime=inv(transpose(A)*A)*transpose(A);
Aprime=simplify(Aprime);

syms ti real
variable_t_weights_x = simplify([ti*ti ti 1]*Aprime);  
variable_t_weights_v = simplify([2*ti 1 0]*Aprime);
variable_t_weights_a = simplify([2 0 0]*Aprime);

B = sym('x',[1,N],'real');  % x1 is oldest sample, xN is newest sample
% dot product the samples with their weights to get an estimate
x = dot(B, variable_t_weights_x);
v = dot(B, variable_t_weights_v);
a = dot(B, variable_t_weights_a);

