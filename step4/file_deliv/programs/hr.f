program hr
! read from hr.dat prepare data for diag.f
implicit real*8(a-h,o-z)
real*8, allocatable  :: ar(:,:),ai(:,:)
n=7
allocate (ar(n,n),ai(n,n))
! write(8,100)n,0,0,0
read(5,*)  
do i=1,1000
 read(5,*,end=2)lx,ly,lz
 write(6,100)lx,ly,lz
 lxyz=lx**2+ly**2+lz**2
 do j=1,n
  do k=1,n
   read(5,*)ar(j,k),ai(j,k)
   if(lxyz.eq.0)then
    write(6,101)ar(j,k),ai(j,k)
    write(8,101)ar(j,k),ai(j,k)
   endif
  enddo
 enddo
 if(lxyz.eq.0)stop
enddo
2 stop    
100 format(4i7)
101 format(2f18.11)
end

 
