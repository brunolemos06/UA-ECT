cmake_minimum_required(VERSION 3.16)
project(opencv_example)

find_package(OpenCV REQUIRED)

SET(CMAKE_BUILD_TYPE "Release")
#SET(CMAKE_BUILD_TYPE "Debug")

SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -std=c++17 -pthread")
SET(CMAKE_CXX_FLAGS_RELEASE "-O3")
SET(CMAKE_CXX_FLAGS_DEBUG "-g3 -fsanitize=address")

SET(BASE_DIR ${CMAKE_SOURCE_DIR})
SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${BASE_DIR}/../bin)


#EXERCISE 1
add_executable(ex1 ex1.cpp)
target_link_libraries(ex1 ${OpenCV_LIBS})

#EXERCISE 2
add_executable(ex2 ex2.cpp)
target_link_libraries(ex2 ${OpenCV_LIBS})


#EXERCICE encoder_image
add_executable(encoder_image encoder_image.cpp)
target_link_libraries(encoder_image ${OpenCV_LIBS})

#EXERCICE decoder_image
add_executable(decoder_image decoder_image.cpp)
target_link_libraries(decoder_image ${OpenCV_LIBS})

#TESTS OF SECGOLOMB CLASS
add_executable(secgolomb secgolomb.cpp)
target_link_libraries(secgolomb ${OpenCV_LIBS})

#TESTS OF GOLOMB CLASS
add_executable(golomb_code_tests golomb_code_tests.cpp)
target_link_libraries(golomb_code_tests ${OpenCV_LIBS})

#TESTS OF GOLOMB_CODEC CLASS
add_executable(golomb_codec_tests golomb_codec_tests.cpp)
target_link_libraries(golomb_codec_tests ${OpenCV_LIBS})
target_link_libraries(golomb_codec_tests sndfile)
