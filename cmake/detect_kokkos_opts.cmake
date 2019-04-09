if(DETECT_KOKKOS_OPTS)
  return()
endif()
set(DETECT_KOKKOS_OPTS true)

function(detect_kokkos_opts)
  if (Kokkos_FOUND)
    set(FILE_FOUND FALSE)
    foreach(INC_DIR IN LISTS Kokkos_INCLUDE_DIRS)
      if (EXISTS "${INC_DIR}/KokkosCore_config.h")
        set(FILE_FOUND TRUE)
        message(STATUS "Found ${INC_DIR}/KokkosCore_config.h")
        file(READ "${INC_DIR}/KokkosCore_config.h" CONTENTS)
        if ("${CONTENTS}" MATCHES "\n\#define KOKKOS_ENABLE_CUDA")
          message(STATUS "Kokkos has CUDA")
          set(Kokkos_HAS_CUDA TRUE PARENT_SCOPE)
        endif()
        if ("${CONTENTS}" MATCHES "\n\#define KOKKOS_ENABLE_OPENMP")
          message(STATUS "Kokkos has OpenMP")
          set(Kokkos_HAS_OpenMP TRUE PARENT_SCOPE)
        endif()
        if ("${CONTENTS}" MATCHES "\n\#define KOKKOS_ENABLE_CUDA_LAMBDA")
          message(STATUS "Kokkos has CUDA lambdas")
          set(Kokkos_HAS_CUDA_LAMBDA TRUE PARENT_SCOPE)
        endif()
        if ("${CONTENTS}" MATCHES "\n\#define KOKKOS_ENABLE_PROFILING_INTERNAL")
          message(STATUS "Kokkos has profiling")
          set(Kokkos_HAS_PROFILING TRUE PARENT_SCOPE)
        endif()
        if ("${CONTENTS}" MATCHES "\n\#define KOKKOS_ENABLE_PROFILING")
          message(STATUS "Kokkos has profiling")
          set(Kokkos_HAS_PROFILING TRUE PARENT_SCOPE)
        endif()
      endif()
    endforeach()
    if (NOT FILE_FOUND)
      message(FATAL_ERROR "Couldn't find KokkosCore_config.h")
    endif()
  endif()
endfunction(detect_kokkos_opts)
