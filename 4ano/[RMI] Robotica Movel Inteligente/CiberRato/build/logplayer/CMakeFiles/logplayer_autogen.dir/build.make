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
CMAKE_SOURCE_DIR = /home/bruno/Projects/UA-ECT/4ano/RMI/CibeRato

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/bruno/Projects/UA-ECT/4ano/RMI/CibeRato/build

# Utility rule file for logplayer_autogen.

# Include any custom commands dependencies for this target.
include logplayer/CMakeFiles/logplayer_autogen.dir/compiler_depend.make

# Include the progress variables for this target.
include logplayer/CMakeFiles/logplayer_autogen.dir/progress.make

logplayer/CMakeFiles/logplayer_autogen:
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold --progress-dir=/home/bruno/Projects/UA-ECT/4ano/RMI/CibeRato/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Automatic MOC and UIC for target logplayer"
	cd /home/bruno/Projects/UA-ECT/4ano/RMI/CibeRato/build/logplayer && /usr/bin/cmake -E cmake_autogen /home/bruno/Projects/UA-ECT/4ano/RMI/CibeRato/build/logplayer/CMakeFiles/logplayer_autogen.dir/AutogenInfo.json Release

logplayer_autogen: logplayer/CMakeFiles/logplayer_autogen
logplayer_autogen: logplayer/CMakeFiles/logplayer_autogen.dir/build.make
.PHONY : logplayer_autogen

# Rule to build all files generated by this target.
logplayer/CMakeFiles/logplayer_autogen.dir/build: logplayer_autogen
.PHONY : logplayer/CMakeFiles/logplayer_autogen.dir/build

logplayer/CMakeFiles/logplayer_autogen.dir/clean:
	cd /home/bruno/Projects/UA-ECT/4ano/RMI/CibeRato/build/logplayer && $(CMAKE_COMMAND) -P CMakeFiles/logplayer_autogen.dir/cmake_clean.cmake
.PHONY : logplayer/CMakeFiles/logplayer_autogen.dir/clean

logplayer/CMakeFiles/logplayer_autogen.dir/depend:
	cd /home/bruno/Projects/UA-ECT/4ano/RMI/CibeRato/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/bruno/Projects/UA-ECT/4ano/RMI/CibeRato /home/bruno/Projects/UA-ECT/4ano/RMI/CibeRato/logplayer /home/bruno/Projects/UA-ECT/4ano/RMI/CibeRato/build /home/bruno/Projects/UA-ECT/4ano/RMI/CibeRato/build/logplayer /home/bruno/Projects/UA-ECT/4ano/RMI/CibeRato/build/logplayer/CMakeFiles/logplayer_autogen.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : logplayer/CMakeFiles/logplayer_autogen.dir/depend

