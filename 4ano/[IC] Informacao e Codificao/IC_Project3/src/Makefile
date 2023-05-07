all:
	@(if [ ! -d build ]; then mkdir build; fi; cd build;\
	  if [ ! -d bin ]; then bin; fi; cmake ..; make)
clean:
	rm -rf build ../bin
