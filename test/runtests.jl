
using StaticArrays
using SimulationBoxes
using MolecularTrajectories
using Test

const Vec = SVector{3,Float64}

time = 99.9
numatoms = 8
box = Box(Vec(1.0,2.0,3.0))
test_pos = [Vec(i,i+1,i-1) for i in 1:numatoms]
frame = Frame{Vec}(time, box, test_pos)

@test get_num_atoms(frame) == numatoms

for i in 1:numatoms
    @test frame.positions[i] == test_pos[i]
end

@test frame.time == time
time2 = -12.1

@test frame.box == box

#define a dummy trajectory type

@warn "Tests only check that XTC trajectory can be read without runs without crashing"

testfile = "test.xtc"

xtc = XTC{Vec}(testfile, testfile)
for a_frame in xtc
    @test a_frame.time > -1 #dummy test
end

grofile = "test.gro"
gro = GroTrajectory{Vec}(grofile, grofile, grofile, dt = 10)

for (i,a_frame) in enumerate(gro)
    @test a_frame.time == i*10
    @test a_frame.positions[1] == Vec(0.071, 8.301, 0.000)
end

