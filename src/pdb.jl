
# Experimental PDB output

#export PDBTrajectory

struct PDBTrajectory{V} <: AbstractTrajectory{Frame{V}}
    filenames::Vector{String};
    dt::Float64
    function PDBTrajectory{V}(
        filenames
        ;
        dt=0.0
    ) where V
        new{V}(collect(filenames), dt)
    end
end

function write_frame(output, format::Type{PDBTrajectory}, frame, topology, comment="")
    header = "HEADER    xxxxxxxxxxxx                            xxxxxxxxx"
    title = "TITLE     ALL ATOM STRUCTURE FOR MOLECULE 0                                     "
    #leading = "HETATM    1   H6 _I0L    0"
    leading = "ATOM      1  XXX RES A   1"
    trailing = "  1.00  0.00           "
    println(output, header)
    println(output, title)
    pos = frame.positions
    vel = if size(frame.velocities) == size(pos)
        frame.velocities
    else
        zeros(eltype(pos), size(pos))
    end
    t = topology
    #println(output, length(pos))
    Lx,Ly,Lz = frame.box.lengths
    Printf.@printf output "CRYST1%9.3f%9.3f%9.3f%7.2f%7.2f%7.2f P 1        1   \n" Lx*10 Ly*10 Lz*10 90.0 90.0 90.0
    for i in eachindex(pos)
        ii = i%100000
        print(output, leading)
        Printf.@printf(
            output,
            "%12.3f%8.3f%8.3f",
            pos[i][1]*10,
            pos[i][2]*10,
            pos[i][3]*10,
        )
        element = t.atom_names[i][1]
        print(output, trailing)
        println(output, element)
    end
    println(output, "END")
end

