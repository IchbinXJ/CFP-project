program ortho
implicit real*8(a-h,o-z)
real*8 cf(16,7,7),norm(16),hr(7,7),hi(7,7),br(16),bi(16)
real*8 sum(16,16)
integer kc(16),qc(16)
real*8 cr
do i=1,7
 do j=1,7
  cf(1,i,j)=0.        ! unit operator goes first
  if(i.eq.j)cf(1,i,j)=1.
 enddo
enddo
kc(1)=0
qc(1)=0
lcf=6       
k=1
do l=2,lcf,2         ! read spherical tensor operators
 do m=-l,l
  read(90,*)ll,ml
  if(m.le.0)then
   k=k+1
   kc(k)=l
   qc(k)=m
  endif 
  do i=1,7
   do j=i,7
    read(90,*)cr      ! real Ckq used in lanthanide
    if(m.le.0)then
     cf(k,i,j)=cr
     cf(k,j,i)=cf(k,i,j)
    endif
   enddo
  enddo
 enddo
enddo
write(6,*)' number of tensor operators is ',k
ncf=k
! orthonormality
do k1=1,ncf
 do k2=k1,ncf
  sum(k1,k2)=0.
   do i=1,7
    do j=i,7
     sum(k1,k2)=sum(k1,k2)+cf(k1,i,j)*cf(k2,i,j)
    enddo
   enddo
  if(sum(k1,k2).gt.0.000001)write(6,100)k1,k2,kc(k1),qc(k1),kc(k2),qc(k2),sum(k1,k2)
 enddo
enddo
100 format(6i4,f12.6)
stop
end 
