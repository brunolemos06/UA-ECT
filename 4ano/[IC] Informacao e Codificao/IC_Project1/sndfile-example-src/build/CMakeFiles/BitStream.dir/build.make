# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.22

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/bruno/Projects/UA-ECT/4ano/IC/IC_Project1/sndfile-example-src

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/bruno/Projects/UA-ECT/4ano/IC/IC_Project1/sndfile-example-src/build

# Include any dependencies generated for this target.
include CMakeFiles/BitStream.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include CMakeFiles/BitStream.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/BitStream.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/BitStream.dir/flags.make

CMakeFiles/BitStream.dir/BitStream.cpp.o: CMakeFiles/BitStream.dir/flags.make
CMakeFiles/BitStream.dir/BitStream.cpp.o: ../BitStream.cpp
CMakeFiles/BitStream.dir/BitStream.cpp.o: CMakeFiles/BitStream.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/bruno/Projects/UA-ECT/4ano/IC/IC_Project1/sndfile-example-src/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/BitStream.dir/BitStream.cpp.o"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/BitStream.dir/BitStream.cpp.o -MF CMakeFiles/BitStream.dir/BitStream.cpp.o.d -o CMakeFiles/BitStream.dir/BitStream.cpp.o -c /home/bruno/Projects/UA-ECT/4ano/IC/IC_Project1/sndfile-example-src/BitStream.cpp

CMakeFiles/BitStream.dir/BitStream.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/BitStream.dir/BitStream.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/bruno/Projects/UA-ECT/4ano/IC/IC_Project1/sndfile-example-src/BitStream.cpp > CMakeFiles/BitStream.dir/BitStream.cpp.i

CMakeFiles/BitStream.dir/BitStream.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/BitStream.dir/BitStream.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/bruno/Projects/UA-ECT/4ano/IC/IC_Project1/sndfile-example-src/BitStream.cpp -o CMakeFiles/BitStream.dir/BitStream.cpp.s

# Object files for target BitStream
BitStream_OBJECTS = \
"CMakeFiles/BitStream.dir/BitStream.cpp.o"

# External object files for target BitStream
BitStream_EXTERNAL_OBJECTS =

/home/bruno/Projects/UA-ECT/4ano/IC/IC_Project1/sndfile-example-bin/BitStream: CMakeFiles/BitStream.dir/BitStream.cpp.o
/home/bruno/Projects/UA-ECT/4ano/IC/IC_Project1/sndfile-example-bin/BitStream: CMakeFiles/BitStream.dir/build.make
/home/bruno/Projects/UA-ECT/4ano/IC/IC_Project1/sndfile-example-bin/BitStream: CMakeFiles/BitStream.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/bruno/Projects/UA-ECT/4ano/IC/IC_Project1/sndfile-example-src/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable /home/bruno/Projects/UA-ECT/4ano/IC/IC_Project1/sndfile-example-bin/BitStream"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/BitStream.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/BitStream.dir/build: /home/bruno/Projects/UA-ECT/4ano/IC/IC_Project1/sndfile-example-bin/BitStream
.PHONY : CMakeFiles/BitStream.dir/build

CMakeFiles/BitStream.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/BitStream.dir/cmake_clean.cmake
.PHONY : CMakeFiles/BitStream.dir/clean

CMakeFiles/BitStream.dir/depend:
	cd /home/bruno/Projects/UA-ECT/4ano/IC/IC_Project1/sndfile-example-src/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/bruno/Projects/UA-ECT/4ano/IC/IC_Project1/sndfile-example-src /home/bruno/Projects/UA-ECT/4ano/IC/IC_Project1/sndfile-example-src /home/bruno/Projects/UA-ECT/4ano/IC/IC_Project1/sndfile-example-src/build /home/bruno/Projects/UA-ECT/4ano/IC/IC_Project1/sndfile-example-src/build /home/bruno/Projects/UA-ECT/4ano/IC/IC_Project1/sndfile-example-src/build/CMakeFiles/BitStream.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/BitStream.dir/depend

