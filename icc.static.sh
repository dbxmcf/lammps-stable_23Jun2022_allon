#!/bin/bash
module purge
#module load gcc/8.4.0
module load cuda/11.6.0
module load intel-mpi/2021.5.1
module load cmake
export BLDDIR=bdsharedicc
echo $CUDA_HOME
#exit
export CUDA_TOOLKIT_ROOT_DIR=$CUDA_HOME
export CMAKE_C_COMPILER=$(which mpiicc) \
export CMAKE_CXX_COMPILER=$(which mpiicpc) \
export CMAKE_Fortran_COMPILER=$(which mpiifort) \
export MPI_C_COMPILER=$(which mpiicc) \
export MPI_CXX_COMPILER=$(which mpiicpc) \
export PROJECT_MPICC=$(which mpiicpc)
mkdir -p $BLDDIR
rm -rf $BLDDIR/*
cd $BLDDIR
cmake \
-C ../cmake/presets/all_on.cmake \
-D CUDA_TOOLKIT_ROOT_DIR=$CUDA_HOME \
-D CMAKE_C_COMPILER=$(which mpiicc) \
-D CMAKE_CXX_COMPILER=$(which mpiicpc) \
-D CMAKE_Fortran_COMPILER=$(which mpiifort) \
-D MPI_C_COMPILER=$(which mpiicc) \
-D MPI_CXX_COMPILER=$(which mpiicpc) \
-D PROJECT_MPICC=$(which mpiicpc) \
-D MPIEXEC_EXECUTABLE=$(which mpirun) \
-D CMAKE_BUILD_TYPE=Release \
-D BUILD_MPI=ON \
-D BUILD_OMP=ON \
-D GPU_API=cuda \
-D GPU_ARCH=sm_80 \
-D BUILD_SHARED_LIBS=no \
-D CMAKE_INSTALL_PREFIX=$PWD/../install \
../cmake
make -j64
make install
#cp $PWD/build-yaml-cpp/libyaml-cpp-pace.so* $PWD/../install/lib64
find . -name "*.so*" -exec cp "{}" $PWD/../install/lib64/ \;

