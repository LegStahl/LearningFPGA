// full_adder.v ? ?????? ???????? (1 ??????)
module full_adder(
input wire a,
input wire b,
input wire cin,
output wire sum,
output wire cout
);
wire axb; // a XOR b
wire g; // generate = a & b
wire p_cin; // propagate = cin & (a ^ b)
xor u_xor0(axb, a, b); // axb = a ^ b
xor u_xor1(sum, axb, cin); // sum = axb ^ cin
and u_and0(g, a, b); // g = a & b
and u_and1(p_cin, cin, axb); // p_cin = cin & axb
or u_or0(cout, g, p_cin); // cout = g | p_cin
endmodule
