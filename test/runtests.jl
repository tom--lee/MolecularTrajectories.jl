
path = string(dirname(@__FILE__), "/../..")
insert!(LOAD_PATH, 1, path)
insert!(Base.LOAD_CACHE_PATH, 1, path)

module RunTests

import FixedSizeArrays
using SimulationBoxes
using AtomTrajectories
using Base.Test

typealias Vec FixedSizeArrays.Vec{3,Float64}

time = 99.9
numatoms = 8
box = Box(Vec(1.0,2.0,3.0))
frame = Frame{Vec,Box}(time, box, numatoms)

@test getnumatoms(frame) == numatoms

testv = [Vec(i,i+1,i-1) for i in 1:numatoms]

for i in 1:numatoms
    frame[i] = testv[i]
end

for i in 1:numatoms
    @test frame[i] == testv[i]
end

@test gettime(frame) == time
time2 = -12.1
settime!(frame, time2)
@test gettime(frame) == time2

@test getbox(frame) == box
box2 = Box(Vec(10.0,20.0,30.0))
setbox!(frame, box2)
@test getbox(frame) == box2

#define a dummy trajectory type

type Traj <: Trajectory{Frame{Vec,Box}}
    frameno::Int
    Traj() = new(0)
end 

const NUMITER = 2

AtomTrajectories.getframe!(traj::Traj) = begin
    traj.frameno += 1
    Frame{Vec,Box}(traj.frameno, box, 10+traj.frameno)
end

AtomTrajectories.hasframe(traj::Traj) = traj.frameno < NUMITER

Base.eltype(::Type{Traj}) = Frame{Vec,Box}

@test eltype(Traj) == Frame{Vec,Box}

@testset "Test Trajectory Iteration" begin
    traj = Traj()
    
    for (i,frame) in enumerate(traj)
        @test traj.frameno == i
        @test getnumatoms(frame) == 10+traj.frameno
        @test isa(frame, Frame{Vec,Box})
    end
    @test traj.frameno == NUMITER
end


end #module
