library(latex2exp)

non_innov_simulate_ar = function (coefs, n = 100) {
  arima.sim(list(ar = coefs), n, innov =  rep(0, n))
}

## AR(1) =======================================================================
simulated_ar_.8 <- non_innov_simulate_ar(c(.8))
simulated_ar_minus_.8 <- non_innov_simulate_ar(c(-.8))

par(mfrow = c(1, 2))
acf(simulated_ar_.8, main = TeX("$\\phi_1 = 0.8$"))
acf(simulated_ar_minus_.8, main = TeX("$\\phi_1 = -0.8$"))

## AR(2) =======================================================================

get_ar_2_coeficients_by_inverse_characteristic_roots = function (omega_1, omega_2) {
  phi_1 = (omega_1 + omega_2) / (omega_1 * omega_2)
  phi_2 = -1 / (omega_1 * omega_2)
  
  c(phi_1, phi_2)
}

par(mfrow = c(1, 2))
acf(non_innov_simulate_ar(c(0.8)),
    main = TeX("$\\phi_1 = 0.8"),
    lag.max = 20)
acf(
  non_innov_simulate_ar(
    get_ar_2_coeficients_by_inverse_characteristic_roots(1 / 0.8, 1 / 0.8)
  ),
  main = TeX("$\\omega_1 = 0.8$ and $\\omega_2 = 0.8$"),
  lag.max = 20
)

acf(non_innov_simulate_ar(c(0.8)),
    main = TeX("$\\phi_1 = 0.8"),
    lag.max = 20,
    plot = FALSE)

acf(
  non_innov_simulate_ar(
    get_ar_2_coeficients_by_inverse_characteristic_roots(1 / 0.8, 1 / 0.8)
  ),
  main = TeX("$\\omega_1 = 0.8$ and $\\omega_2 = 0.8$"),
  lag.max = 20,
  plot = FALSE
)