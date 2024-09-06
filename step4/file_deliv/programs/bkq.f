program Bkq
implicit real*8(a-h,o-z)
! calculate CFP using local Wannier Hamiltonian
! arbitrary symmetry, 3 real, up to 12 complex CFP 
! P. Novak, November 2013
!         fort.7: wannier90, case_hr.dat with 
!                standard ordering of local w90 hamiltonian basis:
!                y(3x2-y2), z(x2-y2), yz2, xz2, xyz, x(x2-3y2), z3
!         fort.90: spherical tensor operators Ckq extracted from lanthanide
!                k=2, 4, 6; q = -k, -k+1,....,+k
! output  fort.6 standard
!         fort.7 cfp.inp for refit and/or lanthanide
real*8, allocatable  :: e(:),cfr(:,:),cfi(:,:),hr(:,:),hi(:,:)
real*8, allocatable  :: cfpr(:),cfpi(:),cfpabs(:),cf(:,:,:),norm(:)
complex*16, allocatable :: h(:,:),t(:,:),tt(:,:),c(:,:),ham(:,:)
complex*16, allocatable :: hall(:,:)
integer, allocatable :: degnr(:),kc(:),qc(:),indat(:),nlorb(:),lorb(:,:)
complex*16 czero,ima
integer ncfp(3)
data ncfp/4,9,16/
ima=(0.,1.)
czero=(0.,0.)
109 format(' number of atoms for which Wannier functions were calculated=',i5)
! inhr=0 old(2012) format of case_hr.dat inhr=1 new (October 2013) format
! ipr (main), iprt, iprf(Zlm -> Ylm), iprcqk(Cqk) printing options
! iwf=0 w2w ordering of wf, iwf=1 orderinr 3+,2+,1+,0,1-,2-,3-
read(5,*)nat,icfp,lcfp,inhr,iwf,ipr,iprt,iprf,iprcqk
write(6,109)nat
allocate (indat(nat),nlorb(nat),lorb(nat,4))
write(6,*)' Atoms and orb. numbers for which Wannier functions were calculated'
do i=1,nat
 read(5,*)indat(i),nlorb(i),(lorb(i,j),j=1,nlorb(i))
 write(6,108)i,indat(i),nlorb(i),(lorb(i,j),j=1,nlorb(i))
enddo
write(6,110)icfp,lcfp
110 format(' Crystal field parameters for atom',i4,' from above atoms, L=',i3)
nall=0
do i=1,nat
 do j=1,nlorb(i)
  if((i.eq.icfp).and.(lorb(i,j).eq.lcfp))istart=nall+1
  nall=nall+2*lorb(i,j)+1
 enddo
enddo
108 format(' atom ',i5,', index in w2win',i5,', nL=',i3,', L=',4i3)
L=lcfp
iend=istart+2*L
write(6,112)nall,istart,iend
112 format(' total number of WF',i7,', starting index for Hloc',i7,', iend=',i7)
ncf=ncfp(L)  ! maximum number of CFP
n=2*L+1      ! 2L+1 number of Wannier functions for atom selected for CFP
allocate (e(n),h(n,n),cfr(0:n,-n:n),cfi(0:n,-n:n),hr(nall,nall),hi(nall,nall))
allocate (t(n,n),tt(n,n),c(n,n),ham(n,n),hall(nall,nall))
allocate (cfpr(ncf),cfpi(ncf),cfpabs(ncf),cf(ncf,n,n),norm(ncf),kc(ncf),qc(ncf))
do L1=0,7
 do M1=-L1,L1
  cfr(L1,M1)=0.
  cfi(L1,M1)=0.
 enddo
enddo
if(inhr.eq.1)then
 write(6,*)' new format of wannier90  case_hr.dat'
 read(7,*)    ! date of file_hr.dat creation
 read(7,*)    ! num_wann: number of Wannier functions
 read(7,*)    ! nrpts: number of Wigner-Seitz grid-points
 allocate (degnr(nrpts))
 read(7,*)(degnr(i),i=1,nrpts)
 do i=1,1000000
  do j=1,nall
   do k=1,nall
    read(7,*,end=2)lx,ly,lz,m4,m5,hr(m4,m5),hi(m4,m5)
    lxyz=lx**2+ly**2+lz**2
    if(lxyz.eq.0)then 
     hi(m4,m5)=0.      ! with real seed functions local Hw is real
     hall(m4,m5)=hr(m4,m5)+ima*hi(m4,m5)
    if(ipr.gt.2)write(6,118)lx,ly,lz,m4,m5,hr(m4,m5),hi(m4,m5)
    endif
    118 format(5i4,2f18.11)
   enddo
  enddo
!  if(lxyz.eq.0)goto 2
 enddo
elseif(inhr.eq.0)then
 write(6,*)' old format of wannier90 case_hr.dat'
 read(7,*)           ! read local Wannier hamiltonian Hw [eV]
 do i=1,1000000
  read(7,*,end=2)lx,ly,lz
  lxyz=lx**2+ly**2+lz**2
  if(lxyz.eq.0)then
   if(ipr.gt.2)then
    write(6,*)' mult * (2L+1) Hloc for unit cell at origin'
    write(6,*)'  lx  ly  lz   j   k       real(j,k)          imag(j,k)'
   endif
  endif
  do j=1,nall
   do k=1,nall
    read(7,*)hr(j,k),hi(j,k)
    if(lxyz.eq.0)then
     hi(j,k)=0.       ! with real seed functions local Hw is real
     hall(j,k)=hr(j,k)+ima*hi(j,k)
     if(ipr.gt.2)write(6,118)lx,ly,lz,j,k,hr(j,k),hi(j,k)
    endif
   enddo
  enddo
!  if(lxyz.eq.0)goto 2
 enddo
endif
2 continue
!if((ipr.gt.1).and.(mult.gt.1))then
! m=2*L
! write(6,*)
! i1=1
! do iat=1,mult
!  j1=1
!  do jat=iat,mult
!   write(6,107)iat,jat
! 107 format('local hamiltonian between atoms',i4,' and',i4)
!   do i=i1,i1+m
!    write(6,100)(hr(i,j),j=j1,j1+m)
!   enddo
!   j1=j1+7
!   write(6,*)
!  enddo
!  i1=i1+7
! enddo
!endif
i1=0
do i=istart,iend
 i1=i1+1
 j1=0              ! local hamiltonian 
 do j=istart,iend
  j1=j1+1
  h(i1,j1)=hall(i,j)
  c(i1,j1)=h(i1,j1)
 enddo
enddo
write(6,*)'L,n',L,n
if(ipr.gt.0)then
 write(6,104)n
 write(6,*)' real part'
 do i=1,n
  write(6,100)(dble(c(i,j)),j=1,n)
 enddo
 write(6,*)' imag. part'
 do i=1,n
  write(6,100)(dimag(c(i,j)),j=1,n)
 enddo
endif
call zdiag(n,h,e)
write(6,*)' energies w90 Hamiltonian'
write(6,100)(e(i),i=1,n)
if(ipr.gt.0)then
 write(6,*)' Eigenvectors real part/imag part'
 do i=1,n
  write(6,100)e(i)
  write(6,100)(dble(h(j,i)),j=1,n)
  write(6,100)(dimag(h(j,i)),j=1,n)
 enddo
endif

call transf(n,tt,iwf,iprf)     ! construct unit. matrix tt 
                           ! to transform Hw from real W90 to Ylm basis

call trafo(n,n,tt,c,t,iprt)   ! make unit. trafo from w90 to Ylm

if(ipr.gt.0)then
 write(6,*)' transformed matrix real part'
 do i=1,n  
  write(6,100)(dble(t(i,j)),j=1,n)
 enddo
 write(6,*)' imag part'
 do i=1,n
  write(6,100)(dimag(t(i,j)),j=1,n)
 enddo
endif

do i=1,n
 do j=1,n
  ham(i,j)=t(i,j)
 enddo
enddo

call zdiag(n,ham,e)
write(6,*)' energies of Hamiltonian transformed to Ylm'
write(6,100)(e(i),i=1,n)

call tensor(ncf,n,kc,qc,cf,norm,iprcqk)  ! spherical tensors
do k=1,ncf
 cfpr(k)=0.
 cfpi(k)=0.
 do i=1,n
  do j=i,n
   cfpr(k)=cfpr(k)+cf(k,i,j)*dble(t(i,j))
   cfpi(k)=cfpi(k)+cf(k,i,j)*dimag(t(i,j))
  enddo
 enddo
 cfpr(k)=cfpr(k)/norm(k)   
 cfpi(k)=cfpi(k)/norm(k)
enddo

write(6,*)
write(6,*)' Nonzero crystal field parameters [eV]'
write(6,*)' iCqk kCqk |qCqk|  normCqk    Bqk real    Bqk imag     |Bqk|'  
ncqk=0
do k=1,ncf
 cfpabs(k)=sqrt(cfpr(k)**2+cfpi(k)**2)
 if(cfpabs(k).gt.0.00001)then
  ncqk=ncqk+1
  write(6,102)ncqk,kc(k),abs(qc(k)),norm(k),cfpr(k),cfpi(k),cfpabs(k)
  if(k.gt.1)then
   cfr(kc(k),qc(k))=cfpr(k)
   cfi(kc(k),qc(k))=cfpi(k)
   cfr(kc(k),-qc(k))=cfpr(k)
   cfi(kc(k),-qc(k))=-cfpi(k)
  endif
 endif
enddo

! test: Htest = sum_lm Bkq * Ckq;
if(ipr.gt.0)then
 do i=1,n
  do j=1,n
   c(i,j)=czero
   do k=1,ncf
    c(i,j)=c(i,j)+(cfpr(k)+ima*cfpi(k))*cf(k,i,j)
   enddo
  enddo
 enddo
 write(6,*)
 write(6,*)' Hamiltonian constructed from CFP: real part'
 do i=1,n
  write(6,100)(dble(c(i,j)),j=1,n)
 enddo
 write(6,*)' imag part'
 do i=1,n
  write(6,100)(dimag(c(i,j)),j=1,n)
 enddo
 call  zdiag(n,c,e)
 write(6,*)' energies of CFP Hamiltonian'
 write(6,100)(e(i),i=1,n)
 write(6,*)' Eigenvectors real part/imag part'
 do i=1,n
  write(6,100)e(i)
  write(6,100)(dble(c(j,i)),j=1,n)
  write(6,100)(dimag(c(j,i)),j=1,n)
 enddo
endif    ! end test

! write input for refit or lanthanide (cfp.inp) on fort.8
  cmev=8066.          ! convert eV -> cm-1
  do L1=0,7
   do M1=-L1,L1
    write(8,106)L1,M1,cmev*cfr(L1,M1),cmev*cfi(L1,M1)
   enddo
  enddo

stop
100 format(9f12.6)
101 format(' solve complex linear system rank m: A x = B, m=',i6)
102 format(3i5,4f12.6)
104 format(' Wannier local Hamiltonian matrix nxn, n=',i6)
106 format(2i5,2f18.6)
111 format(' local hamiltonian is not real, i,j,h_ij(imag) ',2i4,f16.6)
end

 SUBROUTINE ZDIAG(N,A,E)
      IMPLICIT NONE
      real*8 E(N)
      DOUBLE COMPLEX  A(N,N)
      DOUBLE COMPLEX, allocatable   :: WORK(:)
      DOUBLE PRECISION, allocatable :: RWORK(:)
      INTEGER LWORK, INFO, N, I, J
!
!     Diagonalize matrix:
!     a) obtain workspace size
      allocate ( WORK(1) )
      allocate ( RWORK(3*(N)-2) )
      CALL ZHEEV('N','U',N,A,N,E,WORK,-1,RWORK,INFO)
      LWORK=WORK(1)
!     WRITE(6,*) "Requested size of WORK array: ",LWORK
      deallocate ( WORK )
!
!     b) reallocate work array and calculate eigenvalues and eigenvectors
      allocate ( WORK(LWORK) )
      CALL ZHEEV('V','U',N,A,N,E,WORK,LWORK,RWORK,INFO)
      return
      end

