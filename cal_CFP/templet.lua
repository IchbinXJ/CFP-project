-- script contributed by Yaroslav Kvashnin
 
-- Minimize the output of the program, i.e. for longer calculations
-- the program tells the user what it is doing. For these short
-- examples the result is instant.
Verbosity(0X0)
 
 
--dofile("conf.in")
beta = 1.0
Hex = 300

-- Element Sm
Nelec=5
zeta_4f= 0.155; F2ff=10.92; F4ff=6.85; F6ff=4.93
 
-- scaling with beta factor
F2ff=beta*F2ff; F4ff=beta*F4ff; F6ff=beta*F6ff 
 
-- number of possible many-body states in the initial configuration
-- Npsi = fact(14) / (fact(Nelec) * fact(14-Nelec))
Npsi = 1 
 
-- Bringing everything to the same units (eV)
--T = T * EnergyUnits.Kelvin.value
--Bx = Bx * EnergyUnits.Tesla.value
--By = By * EnergyUnits.Tesla.value
--Bz = Bz * EnergyUnits.Tesla.value
Hex = Hex * EnergyUnits.Tesla.value
 
-- 14 f-electrons + 10 d-electrons
NF=14                  
NB=0
IndexDn_4f={0,2,4,6,8,10,12}
IndexUp_4f={1,3,5,7,9,11,13}
 
-- define the operators
OppSx   =NewOperator("Sx"   ,NF, IndexUp_4f, IndexDn_4f)
OppSy   =NewOperator("Sy"   ,NF, IndexUp_4f, IndexDn_4f)
OppSz   =NewOperator("Sz"   ,NF, IndexUp_4f, IndexDn_4f)
OppSsqr =NewOperator("Ssqr" ,NF, IndexUp_4f, IndexDn_4f)
OppSplus=NewOperator("Splus",NF, IndexUp_4f, IndexDn_4f)
OppSmin =NewOperator("Smin" ,NF, IndexUp_4f, IndexDn_4f)

OppLx   =NewOperator("Lx"   ,NF, IndexUp_4f, IndexDn_4f)
OppLy   =NewOperator("Ly"   ,NF, IndexUp_4f, IndexDn_4f)
OppLz   =NewOperator("Lz"   ,NF, IndexUp_4f, IndexDn_4f)
OppLsqr =NewOperator("Lsqr" ,NF, IndexUp_4f, IndexDn_4f)
OppLplus=NewOperator("Lplus",NF, IndexUp_4f, IndexDn_4f)
OppLmin =NewOperator("Lmin" ,NF, IndexUp_4f, IndexDn_4f)

OppJx   =NewOperator("Jx"   ,NF, IndexUp_4f, IndexDn_4f)
OppJy   =NewOperator("Jy"   ,NF, IndexUp_4f, IndexDn_4f)
OppJz   =NewOperator("Jz"   ,NF, IndexUp_4f, IndexDn_4f)
OppJsqr =NewOperator("Jsqr" ,NF, IndexUp_4f, IndexDn_4f)
OppJplus=NewOperator("Jplus",NF, IndexUp_4f, IndexDn_4f)
OppJmin =NewOperator("Jmin" ,NF, IndexUp_4f, IndexDn_4f)
 
Oppldots=NewOperator("ldots",NF, IndexUp_4f, IndexDn_4f)
 
-- define the coulomb operator
-- we here define the part depending on F0 seperately from the part depending on F2
-- when summing we can put in the numerical values of the slater integrals
 
OppF0 =NewOperator("U", NF, IndexUp_4f, IndexDn_4f, {1,0,0,0})
OppF2 =NewOperator("U", NF, IndexUp_4f, IndexDn_4f, {0,1,0,0})
OppF4 =NewOperator("U", NF, IndexUp_4f, IndexDn_4f, {0,0,1,0})
OppF6 =NewOperator("U", NF, IndexUp_4f, IndexDn_4f, {0,0,0,1})
 
-- Crystal field operator for the f-shell, obtained from PHYSICAL REVIEW B 96, 155132 (2017)
Akm = {
}

OppCF = NewOperator("CF", NF, IndexUp_4f, IndexDn_4f, Akm)
--print(OppCF) 
--print(OppCF-ConjugateTranspose(OppCF))
--print(OperatorToMatrix(OppCF))
--os.exit()
 
------------------------------------------------
----- Input parameters for the Hamiltonian -----
-- in crystal field theory U drops out of the equation
U       =  0.000 
F0ff    = U+F2ff*4/195+F4ff*2/143+F6ff*100/5577

print("")
io.write(string.format("--> Assumed initial configuration: 3d10f%i", Nelec))
llist = {F0ff, F2ff, F4ff, F6ff, zeta_4f}
print("")
print("--> INITIAL STATE PARAMETERS")
io.write("  F0ff    F2ff    F4ff    F6ff    zeta_4f\n")
for i=1,5 do
io.write(string.format("%7.4f ",llist[i]))
end
print("")

-- initial state Hamiltonian 
Hamiltonian_U =  F0ff*OppF0 + F2ff*OppF2 + F4ff*OppF4 + F6ff*OppF6
for theta=0,180,5 do
for phi=-180,180,5 do
--Hamiltonian = Hamiltonian + Bx * (2*OppSx + OppLx) + By * (2*OppSy + OppLy) + Bz * (2*OppSz + OppLz) + Hex * OppSz
Hamiltonian = Hamiltonian_U + zeta_4f*Oppldots + OppCF + 2 * Hex * math.cos(theta/180*math.pi) * OppSz + 2 * Hex * math.sin(theta/180*math.pi) * math.cos(phi/180*math.pi) * OppSx + 2 * Hex * math.sin(theta/180*math.pi) * math.sin(phi/180*math.pi) * OppSy
--print( Hamiltonian - ConjugateTranspose(Hamiltonian) )

-- in order to make sure we have a filling of 2 electrons we need to define some restrictions
StartRestrictions = {NF, NB, {"11111111111111",Nelec,Nelec}}
 
psiList = Eigensystem(Hamiltonian, StartRestrictions, Npsi)

expvalue = psiList*Hamiltonian*psiList
--print(expvalue)
io.write(string.format("%4d %4d %11.7f",theta, phi, expvalue))
io.write("\n")
end
end
--os.exit() 
