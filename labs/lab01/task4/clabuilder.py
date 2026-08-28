# with open("cla64_assigns.v", "w") as f:
#     for i in range(1, 65):
#         terms = [f"g[{i-1}]"]
        
#         # Intermediate Generate/Propagate terms
#         for j in range(1, i):
#             p_str = " & ".join([f"p[{k}]" for k in range(i-1, i-1-j, -1)])
#             terms.append(f"({p_str} & g[{i-1-j}])")
        
#         # Final Carry-in term
#         p_cin_str = " & ".join([f"p[{k}]" for k in range(i-1, -1, -1)])
#         terms.append(f"({p_cin_str} & cin)")
        
#         equation = f"assign #(2) c[{i}] = " + " | ".join(terms) + ";"
#         f.write(equation + "\n")

with open("cla64_sum_assigns.v", "w") as f:
    f.write("assign #(2) sum[0] = p[0] ^ cin;\n")
    for i in range(1, 64):
        f.write(f"assign #(2) sum[{i}] = p[{i}] ^ c[{i}];\n")