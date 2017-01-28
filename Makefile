JULIA:=julia

.PHONY : test
test : 
	$(JULIA) --color=yes test/runtests.jl
