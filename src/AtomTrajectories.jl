module AtomTrajectories

export Trajectory, Frame
export gettime, settime!, getbox, setbox!, getnumatoms, getpositions
export getframe, advance!

using SimulationBoxes

abstract Trajectory

"""
Holds one frame of a trajectory, including atom positions, 
box dimensions, and time.
"""
type Frame{V,B<:SimulationBox}
    time::Float64
    box::B
    positions::Vector{V}
    function Frame(time::Real, box::B, numatoms::Integer)
        new(time, box, zeros(V, numatoms))
    end
end

function getframe(::Trajectory); end
function advance!(::Trajectory); end

getnumatoms(f::Frame) = size(f.positions,1)

Base.getindex(f::Frame, atomid::Integer) = f.positions[atomid]
Base.setindex!{V}(f::Frame{V}, pos, atomid::Integer) = f.positions[atomid] = pos

getpositions(f::Frame) = f.positions

gettime(f::Frame) = f.time
settime!(f::Frame, value) = f.time = value

getbox(f::Frame) = f.box
setbox!(f::Frame, box) = f.box = box


end
