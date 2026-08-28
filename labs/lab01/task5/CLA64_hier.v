// cla64_hier.v
// BONUS -- open-ended. No detailed scaffold is provided; this is meant to
// be a genuine design exercise. Not required for lab submission.
//
// You will likely need to modify cla4.v (or add signals alongside it) so
// that block-generate/block-propagate summaries of its own Gi, Pi signals
// are exposed as outputs, since the second-level lookahead unit below
// needs them. As with every module in this lab from Task 2 onward, every
// gate/assign you add should carry an explicit delay.
//
// Starting point (from Tutorial 3, Q4(d)):
//   - Reuse 16 four-bit CLA blocks (your cla4.v) -- their internal logic
//     doesn't change.
//   - For each block k, define:
//       Gblk_k = "this block produces a carry regardless of its incoming
//                 carry" -- a Boolean function of that block's own 4
//                 bit-level Gi, Pi signals.
//       Pblk_k = "an incoming carry sails straight through this whole
//                 block" -- likewise a function of its own Gi, Pi.
//   - Build a second-level lookahead unit -- structurally identical to
//     cla4.v, just one level up -- that computes each block's carry-in
//     directly from Gblk_0..Gblk_15, Pblk_0..Pblk_15, and cin, instead of
//     rippling block to block.
//
// To test this, wire it into dut.v as a fourth option (copy the pattern
// used for the other three) and run it through the same tb.v. Compare
// your final delay to cla64_blocked.v from Task 4.

module cla64_hier(
  input  [63:0] a,
  input  [63:0] b,
  input         cin,
  output [63:0] sum,
  output        cout
);

  // TODO: your hierarchical design goes here.

  wire [63:0] p, g;
  wire [15:0] BP, BG;
  wire [16:0] c_blk; 
  
  assign c_blk[0] = cin;

  genvar i;
  generate
    for (i = 0; i < 64; i = i + 1) begin : gen_pg
      assign #(2) p[i] = a[i] ^ b[i];
      assign #(2) g[i] = a[i] & b[i];
    end
  endgenerate

  
  genvar j;
  generate
    for (j = 0; j < 16; j = j + 1) begin : gen_BP_BG
      assign #(2) BP[j] = p[4*j+3] & p[4*j+2] & p[4*j+1] & p[4*j];
      assign #(2) BG[j] = g[4*j+3] | 
                          (p[4*j+3] & g[4*j+2]) | 
                          (p[4*j+3] & p[4*j+2] & g[4*j+1]) | 
                          (p[4*j+3] & p[4*j+2] & p[4*j+1] & g[4*j]);
    end
  endgenerate

  assign #(2) c_blk[1] = BG[0] | (BP[0] & c_blk[0]);
  assign #(2) c_blk[2] = BG[1] | (BP[1] & BG[0]) | (BP[1] & BP[0] & c_blk[0]);
  assign #(2) c_blk[3] = BG[2] | (BP[2] & BG[1]) | (BP[2] & BP[1] & BG[0]) | (BP[2] & BP[1] & BP[0] & c_blk[0]);
  assign #(2) c_blk[4] = BG[3] | (BP[3] & BG[2]) | (BP[3] & BP[2] & BG[1]) | (BP[3] & BP[2] & BP[1] & BG[0]) | (BP[3] & BP[2] & BP[1] & BP[0] & c_blk[0]);
  assign #(2) c_blk[5] = BG[4] | (BP[4] & BG[3]) | (BP[4] & BP[3] & BG[2]) | (BP[4] & BP[3] & BP[2] & BG[1]) | (BP[4] & BP[3] & BP[2] & BP[1] & BG[0]) | (BP[4] & BP[3] & BP[2] & BP[1] & BP[0] & c_blk[0]);
  assign #(2) c_blk[6] = BG[5] | (BP[5] & BG[4]) | (BP[5] & BP[4] & BG[3]) | (BP[5] & BP[4] & BP[3] & BG[2]) | (BP[5] & BP[4] & BP[3] & BP[2] & BG[1]) | (BP[5] & BP[4] & BP[3] & BP[2] & BP[1] & BG[0]) | (BP[5] & BP[4] & BP[3] & BP[2] & BP[1] & BP[0] & c_blk[0]);
  assign #(2) c_blk[7] = BG[6] | (BP[6] & BG[5]) | (BP[6] & BP[5] & BG[4]) | (BP[6] & BP[5] & BP[4] & BG[3]) | (BP[6] & BP[5] & BP[4] & BP[3] & BG[2]) | (BP[6] & BP[5] & BP[4] & BP[3] & BP[2] & BG[1]) | (BP[6] & BP[5] & BP[4] & BP[3] & BP[2] & BP[1] & BG[0]) | (BP[6] & BP[5] & BP[4] & BP[3] & BP[2] & BP[1] & BP[0] & c_blk[0]);
  assign #(2) c_blk[8] = BG[7] | (BP[7] & BG[6]) | (BP[7] & BP[6] & BG[5]) | (BP[7] & BP[6] & BP[5] & BG[4]) | (BP[7] & BP[6] & BP[5] & BP[4] & BG[3]) | (BP[7] & BP[6] & BP[5] & BP[4] & BP[3] & BG[2]) | (BP[7] & BP[6] & BP[5] & BP[4] & BP[3] & BP[2] & BG[1]) | (BP[7] & BP[6] & BP[5] & BP[4] & BP[3] & BP[2] & BP[1] & BG[0]) | (BP[7] & BP[6] & BP[5] & BP[4] & BP[3] & BP[2] & BP[1] & BP[0] & c_blk[0]);
  assign #(2) c_blk[9] = BG[8] | (BP[8] & BG[7]) | (BP[8] & BP[7] & BG[6]) | (BP[8] & BP[7] & BP[6] & BG[5]) | (BP[8] & BP[7] & BP[6] & BP[5] & BG[4]) | (BP[8] & BP[7] & BP[6] & BP[5] & BP[4] & BG[3]) | (BP[8] & BP[7] & BP[6] & BP[5] & BP[4] & BP[3] & BG[2]) | (BP[8] & BP[7] & BP[6] & BP[5] & BP[4] & BP[3] & BP[2] & BG[1]) | (BP[8] & BP[7] & BP[6] & BP[5] & BP[4] & BP[3] & BP[2] & BP[1] & BG[0]) | (BP[8] & BP[7] & BP[6] & BP[5] & BP[4] & BP[3] & BP[2] & BP[1] & BP[0] & c_blk[0]);
  assign #(2) c_blk[10] = BG[9] | (BP[9] & BG[8]) | (BP[9] & BP[8] & BG[7]) | (BP[9] & BP[8] & BP[7] & BG[6]) | (BP[9] & BP[8] & BP[7] & BP[6] & BG[5]) | (BP[9] & BP[8] & BP[7] & BP[6] & BP[5] & BG[4]) | (BP[9] & BP[8] & BP[7] & BP[6] & BP[5] & BP[4] & BG[3]) | (BP[9] & BP[8] & BP[7] & BP[6] & BP[5] & BP[4] & BP[3] & BG[2]) | (BP[9] & BP[8] & BP[7] & BP[6] & BP[5] & BP[4] & BP[3] & BP[2] & BG[1]) | (BP[9] & BP[8] & BP[7] & BP[6] & BP[5] & BP[4] & BP[3] & BP[2] & BP[1] & BG[0]) | (BP[9] & BP[8] & BP[7] & BP[6] & BP[5] & BP[4] & BP[3] & BP[2] & BP[1] & BP[0] & c_blk[0]);
  assign #(2) c_blk[11] = BG[10] | (BP[10] & BG[9]) | (BP[10] & BP[9] & BG[8]) | (BP[10] & BP[9] & BP[8] & BG[7]) | (BP[10] & BP[9] & BP[8] & BP[7] & BG[6]) | (BP[10] & BP[9] & BP[8] & BP[7] & BP[6] & BG[5]) | (BP[10] & BP[9] & BP[8] & BP[7] & BP[6] & BP[5] & BG[4]) | (BP[10] & BP[9] & BP[8] & BP[7] & BP[6] & BP[5] & BP[4] & BG[3]) | (BP[10] & BP[9] & BP[8] & BP[7] & BP[6] & BP[5] & BP[4] & BP[3] & BG[2]) | (BP[10] & BP[9] & BP[8] & BP[7] & BP[6] & BP[5] & BP[4] & BP[3] & BP[2] & BG[1]) | (BP[10] & BP[9] & BP[8] & BP[7] & BP[6] & BP[5] & BP[4] & BP[3] & BP[2] & BP[1] & BG[0]) | (BP[10] & BP[9] & BP[8] & BP[7] & BP[6] & BP[5] & BP[4] & BP[3] & BP[2] & BP[1] & BP[0] & c_blk[0]);
  assign #(2) c_blk[12] = BG[11] | (BP[11] & BG[10]) | (BP[11] & BP[10] & BG[9]) | (BP[11] & BP[10] & BP[9] & BG[8]) | (BP[11] & BP[10] & BP[9] & BP[8] & BG[7]) | (BP[11] & BP[10] & BP[9] & BP[8] & BP[7] & BG[6]) | (BP[11] & BP[10] & BP[9] & BP[8] & BP[7] & BP[6] & BG[5]) | (BP[11] & BP[10] & BP[9] & BP[8] & BP[7] & BP[6] & BP[5] & BG[4]) | (BP[11] & BP[10] & BP[9] & BP[8] & BP[7] & BP[6] & BP[5] & BP[4] & BG[3]) | (BP[11] & BP[10] & BP[9] & BP[8] & BP[7] & BP[6] & BP[5] & BP[4] & BP[3] & BG[2]) | (BP[11] & BP[10] & BP[9] & BP[8] & BP[7] & BP[6] & BP[5] & BP[4] & BP[3] & BP[2] & BG[1]) | (BP[11] & BP[10] & BP[9] & BP[8] & BP[7] & BP[6] & BP[5] & BP[4] & BP[3] & BP[2] & BP[1] & BG[0]) | (BP[11] & BP[10] & BP[9] & BP[8] & BP[7] & BP[6] & BP[5] & BP[4] & BP[3] & BP[2] & BP[1] & BP[0] & c_blk[0]);
  assign #(2) c_blk[13] = BG[12] | (BP[12] & BG[11]) | (BP[12] & BP[11] & BG[10]) | (BP[12] & BP[11] & BP[10] & BG[9]) | (BP[12] & BP[11] & BP[10] & BP[9] & BG[8]) | (BP[12] & BP[11] & BP[10] & BP[9] & BP[8] & BG[7]) | (BP[12] & BP[11] & BP[10] & BP[9] & BP[8] & BP[7] & BG[6]) | (BP[12] & BP[11] & BP[10] & BP[9] & BP[8] & BP[7] & BP[6] & BG[5]) | (BP[12] & BP[11] & BP[10] & BP[9] & BP[8] & BP[7] & BP[6] & BP[5] & BG[4]) | (BP[12] & BP[11] & BP[10] & BP[9] & BP[8] & BP[7] & BP[6] & BP[5] & BP[4] & BG[3]) | (BP[12] & BP[11] & BP[10] & BP[9] & BP[8] & BP[7] & BP[6] & BP[5] & BP[4] & BP[3] & BG[2]) | (BP[12] & BP[11] & BP[10] & BP[9] & BP[8] & BP[7] & BP[6] & BP[5] & BP[4] & BP[3] & BP[2] & BG[1]) | (BP[12] & BP[11] & BP[10] & BP[9] & BP[8] & BP[7] & BP[6] & BP[5] & BP[4] & BP[3] & BP[2] & BP[1] & BG[0]) | (BP[12] & BP[11] & BP[10] & BP[9] & BP[8] & BP[7] & BP[6] & BP[5] & BP[4] & BP[3] & BP[2] & BP[1] & BP[0] & c_blk[0]);
  assign #(2) c_blk[14] = BG[13] | (BP[13] & BG[12]) | (BP[13] & BP[12] & BG[11]) | (BP[13] & BP[12] & BP[11] & BG[10]) | (BP[13] & BP[12] & BP[11] & BP[10] & BG[9]) | (BP[13] & BP[12] & BP[11] & BP[10] & BP[9] & BG[8]) | (BP[13] & BP[12] & BP[11] & BP[10] & BP[9] & BP[8] & BG[7]) | (BP[13] & BP[12] & BP[11] & BP[10] & BP[9] & BP[8] & BP[7] & BG[6]) | (BP[13] & BP[12] & BP[11] & BP[10] & BP[9] & BP[8] & BP[7] & BP[6] & BG[5]) | (BP[13] & BP[12] & BP[11] & BP[10] & BP[9] & BP[8] & BP[7] & BP[6] & BP[5] & BG[4]) | (BP[13] & BP[12] & BP[11] & BP[10] & BP[9] & BP[8] & BP[7] & BP[6] & BP[5] & BP[4] & BG[3]) | (BP[13] & BP[12] & BP[11] & BP[10] & BP[9] & BP[8] & BP[7] & BP[6] & BP[5] & BP[4] & BP[3] & BG[2]) | (BP[13] & BP[12] & BP[11] & BP[10] & BP[9] & BP[8] & BP[7] & BP[6] & BP[5] & BP[4] & BP[3] & BP[2] & BG[1]) | (BP[13] & BP[12] & BP[11] & BP[10] & BP[9] & BP[8] & BP[7] & BP[6] & BP[5] & BP[4] & BP[3] & BP[2] & BP[1] & BG[0]) | (BP[13] & BP[12] & BP[11] & BP[10] & BP[9] & BP[8] & BP[7] & BP[6] & BP[5] & BP[4] & BP[3] & BP[2] & BP[1] & BP[0] & c_blk[0]);
  assign #(2) c_blk[15] = BG[14] | (BP[14] & BG[13]) | (BP[14] & BP[13] & BG[12]) | (BP[14] & BP[13] & BP[12] & BG[11]) | (BP[14] & BP[13] & BP[12] & BP[11] & BG[10]) | (BP[14] & BP[13] & BP[12] & BP[11] & BP[10] & BG[9]) | (BP[14] & BP[13] & BP[12] & BP[11] & BP[10] & BP[9] & BG[8]) | (BP[14] & BP[13] & BP[12] & BP[11] & BP[10] & BP[9] & BP[8] & BG[7]) | (BP[14] & BP[13] & BP[12] & BP[11] & BP[10] & BP[9] & BP[8] & BP[7] & BG[6]) | (BP[14] & BP[13] & BP[12] & BP[11] & BP[10] & BP[9] & BP[8] & BP[7] & BP[6] & BG[5]) | (BP[14] & BP[13] & BP[12] & BP[11] & BP[10] & BP[9] & BP[8] & BP[7] & BP[6] & BP[5] & BG[4]) | (BP[14] & BP[13] & BP[12] & BP[11] & BP[10] & BP[9] & BP[8] & BP[7] & BP[6] & BP[5] & BP[4] & BG[3]) | (BP[14] & BP[13] & BP[12] & BP[11] & BP[10] & BP[9] & BP[8] & BP[7] & BP[6] & BP[5] & BP[4] & BP[3] & BG[2]) | (BP[14] & BP[13] & BP[12] & BP[11] & BP[10] & BP[9] & BP[8] & BP[7] & BP[6] & BP[5] & BP[4] & BP[3] & BP[2] & BG[1]) | (BP[14] & BP[13] & BP[12] & BP[11] & BP[10] & BP[9] & BP[8] & BP[7] & BP[6] & BP[5] & BP[4] & BP[3] & BP[2] & BP[1] & BG[0]) | (BP[14] & BP[13] & BP[12] & BP[11] & BP[10] & BP[9] & BP[8] & BP[7] & BP[6] & BP[5] & BP[4] & BP[3] & BP[2] & BP[1] & BP[0] & c_blk[0]);
  assign #(2) c_blk[16] = BG[15] | (BP[15] & BG[14]) | (BP[15] & BP[14] & BG[13]) | (BP[15] & BP[14] & BP[13] & BG[12]) | (BP[15] & BP[14] & BP[13] & BP[12] & BG[11]) | (BP[15] & BP[14] & BP[13] & BP[12] & BP[11] & BG[10]) | (BP[15] & BP[14] & BP[13] & BP[12] & BP[11] & BP[10] & BG[9]) | (BP[15] & BP[14] & BP[13] & BP[12] & BP[11] & BP[10] & BP[9] & BG[8]) | (BP[15] & BP[14] & BP[13] & BP[12] & BP[11] & BP[10] & BP[9] & BP[8] & BG[7]) | (BP[15] & BP[14] & BP[13] & BP[12] & BP[11] & BP[10] & BP[9] & BP[8] & BP[7] & BG[6]) | (BP[15] & BP[14] & BP[13] & BP[12] & BP[11] & BP[10] & BP[9] & BP[8] & BP[7] & BP[6] & BG[5]) | (BP[15] & BP[14] & BP[13] & BP[12] & BP[11] & BP[10] & BP[9] & BP[8] & BP[7] & BP[6] & BP[5] & BG[4]) | (BP[15] & BP[14] & BP[13] & BP[12] & BP[11] & BP[10] & BP[9] & BP[8] & BP[7] & BP[6] & BP[5] & BP[4] & BG[3]) | (BP[15] & BP[14] & BP[13] & BP[12] & BP[11] & BP[10] & BP[9] & BP[8] & BP[7] & BP[6] & BP[5] & BP[4] & BP[3] & BG[2]) | (BP[15] & BP[14] & BP[13] & BP[12] & BP[11] & BP[10] & BP[9] & BP[8] & BP[7] & BP[6] & BP[5] & BP[4] & BP[3] & BP[2] & BG[1]) | (BP[15] & BP[14] & BP[13] & BP[12] & BP[11] & BP[10] & BP[9] & BP[8] & BP[7] & BP[6] & BP[5] & BP[4] & BP[3] & BP[2] & BP[1] & BG[0]) | (BP[15] & BP[14] & BP[13] & BP[12] & BP[11] & BP[10] & BP[9] & BP[8] & BP[7] & BP[6] & BP[5] & BP[4] & BP[3] & BP[2] & BP[1] & BP[0] & c_blk[0]);

 
  assign cout = c_blk[16];

  cla4 block0  (.a(a[3:0]),   .b(b[3:0]),   .cin(c_blk[0]),  .sum(sum[3:0]));
  cla4 block1  (.a(a[7:4]),   .b(b[7:4]),   .cin(c_blk[1]),  .sum(sum[7:4]));
  cla4 block2  (.a(a[11:8]),  .b(b[11:8]),  .cin(c_blk[2]),  .sum(sum[11:8]));
  cla4 block3  (.a(a[15:12]), .b(b[15:12]), .cin(c_blk[3]),  .sum(sum[15:12]));
  cla4 block4  (.a(a[19:16]), .b(b[19:16]), .cin(c_blk[4]),  .sum(sum[19:16]));
  cla4 block5  (.a(a[23:20]), .b(b[23:20]), .cin(c_blk[5]),  .sum(sum[23:20]));
  cla4 block6  (.a(a[27:24]), .b(b[27:24]), .cin(c_blk[6]),  .sum(sum[27:24]));
  cla4 block7  (.a(a[31:28]), .b(b[31:28]), .cin(c_blk[7]),  .sum(sum[31:28]));
  cla4 block8  (.a(a[35:32]), .b(b[35:32]), .cin(c_blk[8]),  .sum(sum[35:32]));
  cla4 block9  (.a(a[39:36]), .b(b[39:36]), .cin(c_blk[9]),  .sum(sum[39:36]));
  cla4 block10 (.a(a[43:40]), .b(b[43:40]), .cin(c_blk[10]), .sum(sum[43:40]));
  cla4 block11 (.a(a[47:44]), .b(b[47:44]), .cin(c_blk[11]), .sum(sum[47:44]));
  cla4 block12 (.a(a[51:48]), .b(b[51:48]), .cin(c_blk[12]), .sum(sum[51:48]));
  cla4 block13 (.a(a[55:52]), .b(b[55:52]), .cin(c_blk[13]), .sum(sum[55:52]));
  cla4 block14 (.a(a[59:56]), .b(b[59:56]), .cin(c_blk[14]), .sum(sum[59:56]));
  cla4 block15 (.a(a[63:60]), .b(b[63:60]), .cin(c_blk[15]), .sum(sum[63:60]));

endmodule


