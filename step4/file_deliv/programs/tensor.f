subroutine tensor(ncf,n,kc,qc,cf,norm,ipr)
implicit real*8(a-h,o-z)
real*8 cf(ncf,n,n),norm(ncf)
integer kc(ncf),qc(ncf)
real*8 cr
do i=1,n
 do j=1,n
  cf(1,i,j)=0.        ! unit operator goes first
  if(i.eq.j)cf(1,i,j)=1.
 enddo
enddo
kc(1)=0
qc(1)=0
lcf=n-1               ! maximum L of CFP       
k=1
do l=2,lcf,2         ! read spherical tensor operators
 do m=-l,l
  read(90,*)ll,ml
  if(m.le.0)then
   k=k+1
   kc(k)=l
   qc(k)=m
  endif 
  do i=1,n
   do j=i,n
    read(90,*)cr      ! real Ckq used in lanthanide
    if(m.le.0)then    ! only m.le.0 are nonzero in lanthanide
     cf(k,i,j)=cr
     cf(k,j,i)=cf(k,i,j)
    endif
   enddo
  enddo
 enddo
enddo
mcf=k
! norm of Ckq
do k1=1,mcf
 norm(k1)=0.
 do i=1,n
  do j=i,n
   norm(k1)=norm(k1)+cf(k1,i,j)**2
  enddo
 enddo
enddo
! orthogonality of Ckq
do k1=1,mcf
 do k2=k1,mcf
  s=0.
  do i=1,n
   do j=1,n
    s=s+cf(k1,i,j)*cf(k2,i,j)
   enddo
  enddo
  write(9,100)k1,k2,s
100 format(2i4,6f12.6)
 enddo
enddo
return
end 
