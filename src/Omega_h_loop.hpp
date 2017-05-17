#ifndef OMEGA_H_LOOP_HPP
#define OMEGA_H_LOOP_HPP

#include <Omega_h_defines.hpp>
#include <Omega_h_kokkos.hpp>

namespace Omega_h {

#ifdef OMEGA_H_USE_KOKKOSCORE
using ExecSpace = Kokkos::DefaultExecutionSpace;
using StaticSched = Kokkos::Schedule<Kokkos::Static>;
using Policy = Kokkos::RangePolicy<ExecSpace, StaticSched>;

inline Policy policy(LO n) { return Policy(0, static_cast<std::size_t>(n)); }
#endif

template <typename T>
void parallel_for(LO n, T const& f) {
#ifdef OMEGA_H_USE_KOKKOSCORE
  if (n > 0) Kokkos::parallel_for(policy(n), f);
#else
  for (LO i = 0; i < n; ++i) f(i);
#endif
}

template <typename T>
typename T::value_type parallel_reduce(LO n, T f) {
  typedef typename T::value_type VT;
  VT result;
  f.init(result);
#ifdef OMEGA_H_USE_KOKKOSCORE
  if (n > 0) Kokkos::parallel_reduce(policy(n), f, result);
#else
  for (LO i = 0; i < n; ++i) f(i, result);
#endif
  return result;
}

template <typename T>
void parallel_scan(LO n, T f) {
  typedef typename T::value_type VT;
#ifdef OMEGA_H_USE_KOKKOSCORE
  if (n > 0) Kokkos::parallel_scan(policy(n), f);
#else
  VT update;
  f.init(update);
  for (LO i = 0; i < n; ++i) f(i, update, true);
#endif
}

}  // end namespace Omega_h

#endif
