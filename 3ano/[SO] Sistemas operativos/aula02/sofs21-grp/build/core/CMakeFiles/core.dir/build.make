# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.16

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
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
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/bruno/Desktop/UA-LECI/3ano/1semestre/Sistemas_operativos/aula02/sofs21-grp/src

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/bruno/Desktop/UA-LECI/3ano/1semestre/Sistemas_operativos/aula02/sofs21-grp/build

# Include any dependencies generated for this target.
include core/CMakeFiles/core.dir/depend.make

# Include the progress variables for this target.
include core/CMakeFiles/core.dir/progress.make

# Include the compile flags for this target's objects.
include core/CMakeFiles/core.dir/flags.make

core/CMakeFiles/core.dir/exception.cpp.o: core/CMakeFiles/core.dir/flags.make
core/CMakeFiles/core.dir/exception.cpp.o: /home/bruno/Desktop/UA-LECI/3ano/1semestre/Sistemas_operativos/aula02/sofs21-grp/src/core/exception.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/bruno/Desktop/UA-LECI/3ano/1semestre/Sistemas_operativos/aula02/sofs21-grp/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object core/CMakeFiles/core.dir/exception.cpp.o"
	cd /home/bruno/Desktop/UA-LECI/3ano/1semestre/Sistemas_operativos/aula02/sofs21-grp/build/core && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/core.dir/exception.cpp.o -c /home/bruno/Desktop/UA-LECI/3ano/1semestre/Sistemas_operativos/aula02/sofs21-grp/src/core/exception.cpp

core/CMakeFiles/core.dir/exception.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/core.dir/exception.cpp.i"
	cd /home/bruno/Desktop/UA-LECI/3ano/1semestre/Sistemas_operativos/aula02/sofs21-grp/build/core && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/bruno/Desktop/UA-LECI/3ano/1semestre/Sistemas_operativos/aula02/sofs21-grp/src/core/exception.cpp > CMakeFiles/core.dir/exception.cpp.i

core/CMakeFiles/core.dir/exception.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/core.dir/exception.cpp.s"
	cd /home/bruno/Desktop/UA-LECI/3ano/1semestre/Sistemas_operativos/aula02/sofs21-grp/build/core && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/bruno/Desktop/UA-LECI/3ano/1semestre/Sistemas_operativos/aula02/sofs21-grp/src/core/exception.cpp -o CMakeFiles/core.dir/exception.cpp.s

core/CMakeFiles/core.dir/rawdisk.cpp.o: core/CMakeFiles/core.dir/flags.make
core/CMakeFiles/core.dir/rawdisk.cpp.o: /home/bruno/Desktop/UA-LECI/3ano/1semestre/Sistemas_operativos/aula02/sofs21-grp/src/core/rawdisk.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/bruno/Desktop/UA-LECI/3ano/1semestre/Sistemas_operativos/aula02/sofs21-grp/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object core/CMakeFiles/core.dir/rawdisk.cpp.o"
	cd /home/bruno/Desktop/UA-LECI/3ano/1semestre/Sistemas_operativos/aula02/sofs21-grp/build/core && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/core.dir/rawdisk.cpp.o -c /home/bruno/Desktop/UA-LECI/3ano/1semestre/Sistemas_operativos/aula02/sofs21-grp/src/core/rawdisk.cpp

core/CMakeFiles/core.dir/rawdisk.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/core.dir/rawdisk.cpp.i"
	cd /home/bruno/Desktop/UA-LECI/3ano/1semestre/Sistemas_operativos/aula02/sofs21-grp/build/core && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/bruno/Desktop/UA-LECI/3ano/1semestre/Sistemas_operativos/aula02/sofs21-grp/src/core/rawdisk.cpp > CMakeFiles/core.dir/rawdisk.cpp.i

core/CMakeFiles/core.dir/rawdisk.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/core.dir/rawdisk.cpp.s"
	cd /home/bruno/Desktop/UA-LECI/3ano/1semestre/Sistemas_operativos/aula02/sofs21-grp/build/core && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/bruno/Desktop/UA-LECI/3ano/1semestre/Sistemas_operativos/aula02/sofs21-grp/src/core/rawdisk.cpp -o CMakeFiles/core.dir/rawdisk.cpp.s

# Object files for target core
core_OBJECTS = \
"CMakeFiles/core.dir/exception.cpp.o" \
"CMakeFiles/core.dir/rawdisk.cpp.o"

# External object files for target core
core_EXTERNAL_OBJECTS =

/home/bruno/Desktop/UA-LECI/3ano/1semestre/Sistemas_operativos/aula02/sofs21-grp/lib/libcore.a: core/CMakeFiles/core.dir/exception.cpp.o
/home/bruno/Desktop/UA-LECI/3ano/1semestre/Sistemas_operativos/aula02/sofs21-grp/lib/libcore.a: core/CMakeFiles/core.dir/rawdisk.cpp.o
/home/bruno/Desktop/UA-LECI/3ano/1semestre/Sistemas_operativos/aula02/sofs21-grp/lib/libcore.a: core/CMakeFiles/core.dir/build.make
/home/bruno/Desktop/UA-LECI/3ano/1semestre/Sistemas_operativos/aula02/sofs21-grp/lib/libcore.a: core/CMakeFiles/core.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/bruno/Desktop/UA-LECI/3ano/1semestre/Sistemas_operativos/aula02/sofs21-grp/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Linking CXX static library /home/bruno/Desktop/UA-LECI/3ano/1semestre/Sistemas_operativos/aula02/sofs21-grp/lib/libcore.a"
	cd /home/bruno/Desktop/UA-LECI/3ano/1semestre/Sistemas_operativos/aula02/sofs21-grp/build/core && $(CMAKE_COMMAND) -P CMakeFiles/core.dir/cmake_clean_target.cmake
	cd /home/bruno/Desktop/UA-LECI/3ano/1semestre/Sistemas_operativos/aula02/sofs21-grp/build/core && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/core.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
core/CMakeFiles/core.dir/build: /home/bruno/Desktop/UA-LECI/3ano/1semestre/Sistemas_operativos/aula02/sofs21-grp/lib/libcore.a

.PHONY : core/CMakeFiles/core.dir/build

core/CMakeFiles/core.dir/clean:
	cd /home/bruno/Desktop/UA-LECI/3ano/1semestre/Sistemas_operativos/aula02/sofs21-grp/build/core && $(CMAKE_COMMAND) -P CMakeFiles/core.dir/cmake_clean.cmake
.PHONY : core/CMakeFiles/core.dir/clean

core/CMakeFiles/core.dir/depend:
	cd /home/bruno/Desktop/UA-LECI/3ano/1semestre/Sistemas_operativos/aula02/sofs21-grp/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/bruno/Desktop/UA-LECI/3ano/1semestre/Sistemas_operativos/aula02/sofs21-grp/src /home/bruno/Desktop/UA-LECI/3ano/1semestre/Sistemas_operativos/aula02/sofs21-grp/src/core /home/bruno/Desktop/UA-LECI/3ano/1semestre/Sistemas_operativos/aula02/sofs21-grp/build /home/bruno/Desktop/UA-LECI/3ano/1semestre/Sistemas_operativos/aula02/sofs21-grp/build/core /home/bruno/Desktop/UA-LECI/3ano/1semestre/Sistemas_operativos/aula02/sofs21-grp/build/core/CMakeFiles/core.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : core/CMakeFiles/core.dir/depend

