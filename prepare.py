import os

cif_files = [f for f in os.listdir('.') if os.path.isfile(f) and f.endswith('.cif')]

for cif_file in cif_files:
    case = cif_file.split('.')[0]
    print(case)
    os.system('setrmt_lapw {}'.format(case))
    os.system('mv {}.struct_setrmt {}.struct'.format(case, case))
    os.system('x sgroup')
    os.system('mv {}.struct_sgroup {}.struct'.format(case, case))

