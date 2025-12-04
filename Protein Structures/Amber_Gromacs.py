import parmed as pmd 
import sys
import os

#function to convert AMBER files to GROMACS
def convert_amber_to_gromacs(top_file, crd_file, base_name):
    print(f"Converting {top_file}, {crd_file} to GROMACS format...")

    try:
        amber = pmd.load_file(top_file, crd_file)
        amber.save(f"{base_name}_gro.top")
        amber.save(f"{base_name}.gro")
        print(f"Saved {base_name}_gro.top and {base_name}.gro")
    except Exception as e:
        print(f"Conversion faield: {e}")
        sys.exit(1)
if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: amber_to_gromacs.py <topology.top> <coordinates.crd> <basename>")
        sys.exit(1)

    top_file = sys.argv[1]
    crd_file = sys.argv[2]
    base_name = sys.argv[3]

    convert_amber_to_gromacs(top_file, crd_file, base_name)

    
