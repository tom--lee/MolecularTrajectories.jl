#AtomTrajectories.jl

Extendable interface for handling molecular simulation trajectories.

Provides an abstract `Trajectory` type and concrete `Frame` type.

When implementing a `Trajectory` subtype, one should implement a method
`getframe!(::MyTrajectoryType)::Frame` to get the `Frame` at the timestep the
trajectory is pointing to, and `advance!(::MyTrajectoryType)` to move point to
the next `Frame`.
