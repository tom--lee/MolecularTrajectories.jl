# MolecularTrajectories.jl

A Julia package for reading molecular dynamics simulation trajectories.

Currently supports iteration over a series of GROMACS-format `.gro` files.

GROMACS-format `.xtc` files will be supported in a future release.

## Usage

```julia
julia> using MolecularTrajectories

julia> gro_path = joinpath(dirname(pathof(MolecularTopologies)), "../test/test.gro")

julia> gro_paths = [gro_path, gro_path]

julia> trajectory = GroTrajectory(gro_paths, dt=1.0)

julia> for frame in trajectory
    @show frame.time
    @show frame.box
    @show frame.positions
end
```

Note that trajectory objects are iterable but not indexable.
They do not support the `AbstractArray` interface.
