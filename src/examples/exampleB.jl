include("../main.jl")

n=3
k=1
T = tropical_semiring()
R, (x1, x2, x3) = T["x1", "x2", "x3"]

# hypersurface set u
# mod out lineality
f_start = x1*x2*x3 + T(3)*T(0)
f_target = x1*x2*x3 + T(-3)*T(0)

# create the DualCell for f contributing to mixed cell
f_start_dual = DualCell{DualCellHypersurface, typeof(min)}(generate_support(f_start), [1,2])
# create the dual path
f_path = DualPath{DualPathHypersurface, typeof(min)}([T.([0, 3]), T.([0, -3])])


# tropical linear space set up

M_mod = [1 1 0; 1 0 1; 1 0 0; 0 1 1; 0 1 0; 0 0 1]
p_start_dual = DualCell{DualCellLinear, typeof(min)}(M_mod, [1,2,3])
p_path = DualPath{DualPathLinear, typeof(min)}([T.([0, 0, 0, 0, 0, 0])])

# mixed cell set up
s = mixed_cell([f_start_dual, p_start_dual])

# mixed path set up
h = mixed_path_in_series([f_path, p_path])

# verify that the mixed cell is correct
println("Tropical transverse intersection point = $(stable_intersection_point(s, h, 1, QQFieldElem.(0)))")

# compute the drift
println("Tropical drift = $(compute_drift(s, h, 1))")

# get mixed cell cone working with new types 
C_s = mixed_cell_cone(s)
# compute next breaking point