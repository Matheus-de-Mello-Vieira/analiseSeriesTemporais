import fisica

### CONFIGURAÇÂO
## Layout de fisíca
N = 5 # width of lattice
M = 5 # height of lattice
## Definições de temperatura
temperature = 0.5
BETA = 1 / temperature

init_state = fisica.initRandState(N, M)
dir(fisica)
