module AtomTrajectories

export Trajectory, Frame
export gettime, settime!, getbox, setbox!, setorigin!
export getnumatoms, getpositions, shiftpositions!
export getframe!, hasframe

using SimulationBoxes

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

abstract Trajectory{F<:Frame}

function getframe! end
function hasframe end

Base.start(tr::Trajectory) = nothing
Base.next(tr::Trajectory, state) = (getframe!(tr), nothing)
Base.done(tr::Trajectory, state) = !hasframe(tr)
Base.iteratorsize(::Trajectory) = Base.SizeUnknown()
Base.iteratoreltype{T<:Trajectory}(::Type{T}) = Base.HasEltype()
Base.eltype{T<:Trajectory}(::Type{T}) = error("Must define method eltype(::Type{$T})")
# in Julia 0.6:
# Base.eltype{F, T<:Trajectory{F}}(::Type{T{F}}) = F # or something similar

getnumatoms(f::Frame) = size(f.positions,1)

Base.getindex(f::Frame, atomid::Integer) = f.positions[atomid]
Base.setindex!{V}(f::Frame{V}, pos, atomid::Integer) = f.positions[atomid] = pos

getpositions(frame::Frame) = frame.positions

function shiftpositions!(frame::Frame, displacement)
    pos = getpositions(frame)
    for i in eachindex(pos)
        pos[i] += displacement
    end
    frame
end

gettime(f::Frame) = f.time
settime!(f::Frame, value) = f.time = value

getbox(f::Frame) = f.box
setbox!(f::Frame, box) = f.box = box

function SimulationBoxes.wrap!(frame::Frame)
    wrap!(getpositions(frame), getbox(frame))
end

setorigin!(frame::Frame, origin) = setbox!(frame, setorigin(getbox(frame), origin))


end
