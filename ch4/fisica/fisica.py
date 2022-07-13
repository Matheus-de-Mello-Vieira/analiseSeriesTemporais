import numpy as np

### CONFIGURAÇÂO
## Layout de fisíca
N = 5 # width of lattice
M = 5 # height of lattice
## Definições de temperatura
temperature = 0.5
BETA = 1 / temperature

def initRandState(N, M):
    block = np.random.choice([-1, 1], size=(N, M))
    return block

def costForCenterState(state, i, j, n, m):
    centerS = state[i, j]
    neighbors = [((i + 1) % n, j), ((i - 1) % n, j),
                 (i, (j + 1) % m), (i, (j - 1) % m)]
    interationE = [state[x, y] * centerS for (x, y) in neighbors]
    return np.sum(interationE)

def magnetizationForState(state):
    return np.sum(state)

def mcmcAdjust(state):
    n, m = state.shape
    x, y = np.random.randint(0, n), np.random.randint(0, m)
    centerS = state[x, y]
    cost = costForCenterState(state, x, y, n, m)
    if cost < 0:
        centerS *= -1
    elif np.random.random() < np.exp(-cost * BETA):
        centerS *= -1
    state[x, y] = centerS
    return state

def runState(state, n_steps, snapsteps = None):
    if snapsteps is None:
        snapsteps = np.linspace(0, n_steps, num=round(n_steps / (M * N * 1000)))
    saved_states = []
    sp = 0
    magnet_hist = []
    for i in range(n_steps):
        state = mcmcAdjust(state)
        magnet_hist.append(magnetizationForState(state))
        if sp < len(snapsteps) and i == snapsteps[sp]:
            saved_states.append(np.copy(state))
            sp += 1
    return state, saved_states, magnet_hist

#%% Uso

init_state = initRandState(N, M)
print(init_state)
final_state = runState(np.copy(init_state), 1000)

final_state