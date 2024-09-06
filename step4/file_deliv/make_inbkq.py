import os

# Read values from step3.band_number file
file_path = './step3.band_number'
with open(file_path, 'r') as file:
    line = file.readline().strip()  # Read the first line and remove any extra whitespace
    aa, bb, cc, dd = line.split()  # Split the line into aa and bb

# Construct the command using the read values
#os.system('echo -e "{} {}\n{}:f\n{}:f\n" | write_inwf'.format(aa, bb))
cc = int(cc)
dd = int(dd)

struct_files = [f for f in os.listdir('.') if os.path.isfile(f) and f.endswith('.struct')]
for struct_file in struct_files:
    case = struct_file.split('.')[0]

# Create the case.inbkq file
output_file_path = f'./{case}.inbkq'
with open(output_file_path, 'w') as output_file:
    # Write the first line
    output_file.write(f"{cc} 1 3 1 0 1 0 0 0\n")
    
    # Write the remaining lines
    for i in range(1, cc + 1):
        output_file.write(f"{i} 1 3\n")

print(f"{output_file_path} file created successfully with {cc + 1} lines.")
