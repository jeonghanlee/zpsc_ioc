import numpy as np
from matplotlib import pyplot as pl
import argparse

pi = 3.14159265

def generate_ramp(i1: float, i2: float, R: float, fs: float = 10000.0):
    """
    Generate a smooth current ramp with a sinusoidal derivative.

    Parameters:
        i1 (float): Start setpoint.
        i2 (float): End setpoint.
        R (float): Ramp rate (A/s).
        fs (float): DAC update rate (samples/s). Default is 10 kHz.

    Returns:
        Y (np.ndarray): Generated current setpoints.
    """
    D = np.abs(i2 - i1) / R  # ramp duration (s)
    N = int(D * fs)          # number of points

    Y = np.zeros(N)

    print("i1 = %3.5f" % i1)
    print("i2 = %3.5f" % i2)
    print("ramp rate = %3.2f A/s" % R)
    print("ramp duration = %3.2f s" % D)
    print("number of points = %d" % N)

    sp0 = i1
    A = (i2 - i1) / N * pi / 2
    A = 1

    for i in range(N):
        #Y[i] = i1 + ((i2-i1) * 0.5 * (1 - np.cos(pi * i / N)));
        Y[i] =  0.5 * (1 - np.cos(pi * i / N))
        #Y[i] = np.cos(pi * i / N);
        #dI = A * np.sin(pi * i / N)
        #sp1 = sp0 + dI
        #sp0 = sp1
        #Y[i] = sp1

    return Y

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Generate a smooth current ramp.")
    parser.add_argument("i1", type=float, help="Start setpoint (A).")
    parser.add_argument("i2", type=float, help="End setpoint (A).")
    parser.add_argument("R", type=float, help="Ramp rate (A/s).")

    args = parser.parse_args()

    # Generate ramp
    Y = generate_ramp(args.i1, args.i2, args.R)

    # Plot
    pl.figure(figsize=(10, 4))
    pl.plot(Y, label="Current Ramp")
    pl.xlabel("Sample Index")
    pl.ylabel("Current (A)")
    pl.grid(True)
    pl.legend()
    pl.tight_layout()
    pl.show()

