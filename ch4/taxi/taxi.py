import numpy as np
import queue

class TimePoint:
    taxi_id: int
    name: str
    time: float

    def __init__(self, taxi_id, name, time):
        self.taxi_id = taxi_id
        self.name = name 
        self.time = time

    def __lt__(self, other):
        return self.time < other.time

    def __str__(self):
        return f"id: {self.taxi_id} name: {self.name[:12].rjust(12)} time: {self.time}"

def taxi_id_number(num_taxis):
    arr = np.arange(num_taxis)
    np.random.shuffle(arr)
    for i in range(num_taxis):
        yield arr[i]

def shift_info():
    start_times_and_freqs = [(0, 8), (8, 30), (16, 15)]
    indices = np.arange(len(start_times_and_freqs))
    while True:
        idx = np.random.choice(indices, p = [.25, .5, .25])
        start = start_times_and_freqs[idx]
        yield (start[0], start[0] + 7.5, start[1])

def taxi_process(taxi_id_generator, shift_info_generator):
    taxi_id = next(taxi_id_generator)
    shift_start, shift_end, shift_mean_trips = next(shift_info_generator)

    actual_trips = round(np.random.normal(loc=shift_mean_trips, scale=2))

    average_trip_time = 6.5 / shift_mean_trips * 60
    between_events_time = 1.0 / (shift_mean_trips - 1) * 60
    
    time = shift_start
    yield TimePoint(taxi_id, 'start shift', time)
    deltaT = np.random.poisson(between_events_time)/ 60
    time += deltaT

    for i in range(actual_trips):
        yield TimePoint(taxi_id, 'pick up', time)
        deltaT = np.random.poisson(average_trip_time) / 60
        time += deltaT

        yield TimePoint(taxi_id, 'drop off', time)
        deltaT = np.random.poisson(between_events_time) / 60
        time += deltaT
    deltaT = np.random.poisson(between_events_time) / 60
    time += deltaT
    yield TimePoint(taxi_id, 'end shift', time)

class Simulator:
    def __init__(self, num_taxis):
        self._time_points = queue.PriorityQueue()
        taxi_id_generator = taxi_id_number(num_taxis)
        shift_info_generator = shift_info()
        self._taxis = [taxi_process(taxi_id_generator, shift_info_generator) for i in range(num_taxis)]
        self._prepare_run()

    def _prepare_run(self):
        for t in self._taxis:
            for e in t:
                self._time_points.put(e)

    def run(self):
        sim_time = 0
        while sim_time < 24:
            if self._time_points.empty():
                break
            p = self._time_points.get()
            sim_time = p.time
            print(p)

sim = Simulator(1000)
sim.run()