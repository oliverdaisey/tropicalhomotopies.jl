# TropicalHomotopies.jl
🚀 A Julia package implementing the framework for tropical homotopy continuation on a wide range of tropical spaces, built on the foundations of [OSCAR](https://github.com/oscar-system/Oscar.jl).
## Usage
Our package will compute intersections of balanced polyhedral complexes of complementary dimension with a suitable dual picture. We implemented the following tropical spaces:
- Hypersurfaces
- Linear spaces
- Inverted linear spaces
### Introduction
As an illustrative example of performing homotopy continuations with our package, we will compute all intersection points of the parametric tropical hypersurface $x_1x_2x_3 + wx_0^3$ in $\mathbb{R}^4$ with the inverted tropical linear space arising from the Pluecker vector in $\mathbb{T}^{\binom{4}{2}}$ with all zeroes. The homotopy we follow initialises the system at $w=-3$ and moves to $w=3$, where along the way (at $w = 0$) the number of intersection points changes.
### Setup Dual Supports
All homotopy routines begin by specifying the dual supports of the balanced polyheral complexes whose intersection you want to track. For a hypersurface, one can specify a tropical polynomial directly:
```julia
TT = tropical_semiring()
R, (x0, x1, x2, x3) = TT["x0", "x1", "x2", "x3"]
f = x1 * x2 * x3 + TT(-3)*x0^3
fSupport = DualSupport{Hypersurface}(f)
```
For an intersection involving a tropical linear space or an inversion thereof, either specify the vertices of the matroid polytope directly, or use the helper function:
```julia
matroidVertices = [1 1 0 0; 1 0 1 0; 1 0 0 1; 0 1 1 0; 0 1 0 1; 0 0 1 1]
invertedLinearSupport = DualSupport{InvertedLinear}(matroidVertices)
linearSupport = DualSupport{Linear}((-1)*matroid_polytope_vertices(4, 2))
```
### Define Paths
Once all supports have been initialised, you can define the path data for the homotopy. Begin by specifying the initial and target weights for the supports, and optionally add intermediate weights (this is necessary when dealing with a tropical linear space, to avoid leaving the Dressian):
```julia
fNodes = [TT.([0, -3]), TT.([0, 3])] # fNodes[1] is the initial dual weight vector
fPath = dual_path(fNodes, fSupport)
```
For a tropical linear space or inversion thereof, it is important to ensure that the order of the weights matches the order of the supports. in our example, we will consider the uniform matroid polytope (so all weights are 0):
```julia
pNodes = [TT.([0, 0, 0, 0, 0, 0])]
pPath = dual_path(pNodes, invertedLinearSupport)
```
Once all paths of constitutent dual cells have been defined, you can specify the mixed path that will be used in the homotopy. Here we wish to visit each node in series (i.e. first all nodes of the hypersurface, then all nodes of the inverted linear space):
```julia
h = mixed_path_in_series([fPath, pPath])
```
### Specify Dual Cells and Trackers
With the path data defined, specify the dual cells that support the initial mixed cells. Here it is important to know your mixed cells for the initial weights in advance:
```julia
fStartDual = dual_cell(fSupport, [1, 2], fNodes[1]) # [1, 2] are indices of fSupport that make up this dual cell
linearStartDual = dual_cell(invertedLinearSupport, [1, 2, 3], pNodes[1]) # [1, 2, 3] are indices that make up a loopless facet
s = mixed_cell([fStartDual, linearStartDual])
```
Finally, create a mixed cell tracker from the path data and mixed cell:
```julia
tracker = mixed_cell_tracker(h, s)
```
### Run Homotopy Continuation
Finally, run the homotopy continuation on the tracker:
```julia
result = tropical_homotopy_continuation(tracker)
```
That's it! Everything is automatic and noninteractive.

The result will be a vector of mixed cells dual to those intersection points of the target tropical hypersurface and (inverted) tropical linear space, obtainable by continuing the initial tracker's mixed cell through the homotopy. To interrogate the corresponding tropical intersection points, run the following:
```julia
for mixedCell in result
    println(stable_intersection_point(mixedCell))
end
```
By running `tropical_homotopy_continuation(T)` for every initial mixed cell tracker T, all intersection points are obtained.