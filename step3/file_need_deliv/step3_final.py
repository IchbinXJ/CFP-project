import os

cif_files = [f for f in os.listdir('.') if os.path.isfile(f) and f.endswith('.struct')]

for cif_file in cif_files:
    case = cif_file.split('.')[0]
    print(case)
    os.system('write_win num_iter 1000')
    os.system('mpiexec.hydra -n 1 wannier90.x -pp {}'.format(case))
    os.system('x w2w')
    os.system('mpiexec.hydra -n 1 wannier90.x {}'.format(case))
