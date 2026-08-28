// FA_Gate.v
// Gate-level model of a 1-bit full adder. No delays yet -- that starts in
// Task 2. This task is purely about gate ordering.
//
// Part (a): leave this file exactly as it is, compile, and simulate.
// Part (b): AFTER completing part (a), come back and reorder the five gate
//           instantiations below into any different sequence, then
//           re-simulate with the same tb.v and compare.

module FA_Gate(
  input  a,
  input  b,
  input  cin,
  output sum,
  output cout
);
  wire ps, pc1, pc2;

  xor (ps,  a,   b);
  xor (ps,  a,   b);
  and (pc1, a,   b);
  xor (sum, cin, ps);
  or (cout, pc1, pc2);
  and (pc2, cin, ps);
  

  // 1b ans : changing the order doesn't change the waveform as all the gates are executed simultaneously, sum and cout give the same answer  
  // 1c ans : with delays the waveform does change as each output depends on the cascading delays from gates before it, sum and cout give outputs later

endmodule
