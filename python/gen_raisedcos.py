import numpy as np
import matplotlib.pyplot as plt
import argparse

def generate_raised_cosine(num_points: int, amplitude: float, output_file: str):
    """
    Generate and plot a full-period raised cosine waveform.

    Parameters:
        num_points (int): Number of samples in the period.
        amplitude (float): Amplitude of the waveform.
        output_file (str): File name to save the waveform data.
    """
    # Time base: 0 to 2π (full cosine period)
    t = np.linspace(0, 2 * np.pi, num_points)

    # Raised cosine: from 0 up to 1, back to 0
    raised_cosine = 0.5 * (1 - np.cos(t))

    # Scale by amplitude
    scaled_cosine = raised_cosine * amplitude

    # Plot
    plt.figure(figsize=(10, 4))
    plt.plot(scaled_cosine, label='Full Raised Cosine (float)')
    plt.title('Raised Cosine Full Period (0 → max → 0)')
    plt.xlabel('Sample Index')
    plt.ylabel('Amplitude')
    plt.grid(True)
    plt.legend()
    plt.tight_layout()
    plt.show()

    # Save to file
    np.savetxt(output_file, scaled_cosine, fmt='%.6f')
    print(f"Saved waveform to {output_file}")

    return scaled_cosine

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Generate a raised cosine waveform.")
    parser.add_argument("num_points", type=int, help="Number of sample points.")
    parser.add_argument("amplitude", type=float, help="Amplitude of the waveform.")
    parser.add_argument("output_file", type=str, help="Output file name (e.g., output.txt).")

    args = parser.parse_args()

    generate_raised_cosine(args.num_points, args.amplitude, args.output_file)



