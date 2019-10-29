# Output format for the SimDiffraction program used to calculate
# X-ray diffraction patterns
# https://doi.org/10.1107/S0021889808001064
#
#
# Experimental

#export SimDiffractionTrajectory

struct SimDiffractionTrajectory{V} <: AbstractTrajectory{Frame{V}}
    filenames::Vector{String};
    dt::Float64
    function SimDiffractionTrajectory{V}(
        filenames
        ;
        dt=0.0
    ) where V
        new{V}(collect(filenames), dt)
    end
end

function write_frame(output, format::Type{SimDiffractionTrajectory}, frame, topology, comment="")
    t = topology
    pos = frame.positions
    Lx,Ly,Lz = frame.box.lengths
    nums = Dict{Char, Int}(
        'H'=>1,
        'O'=>8,
        'N'=>7,
        'C'=>6,
        'S'=>16,
    )
    atomnum = map(topology.atom_names) do a
        nums[first(a)]
    end
    for i in eachindex(pos)
        Printf.@printf(
            output,
            "%16.7e\t%16.7e\t%16.7e\t%16.7e\t\n",
            pos[i][1]/Lx,
            pos[i][2]/Ly,
            pos[i][3]/Lz,
            atomnum[i],
        )
    end
end

