subroutine trafo(n,m,b,h,d,ipr)
implicit real*8(a-h,o-z)
! unitary transformation d = (b+(m,n)) x h(n,n) x b(n,m)
complex*16 one,czero,ima
complex*16 a(m,n),b(n,m),c(m,n),h(n,n),d(m,m),f(m,n) !a=b+ b=b, c=(v+)h
 one=(1.,0.)
 czero=(0.,0.)
 ima=(0.,1.)
 if(ipr.gt.1)write(6,*)' unitary transformation d = (b+(m,n)) x h(n,n) x b(n,m)'
 if(ipr.gt.2)then
  write(6,101)m,n
  write(6,*)' Matrix h'
 do i=1,n
   write(6,100)(dble(h(i,j)),j=1,n)
 enddo
  write(6,*)
  write(6,*)' Matrix b real part'
  do i=1,n
   write(6,100)(dble(b(i,j)),j=1,n)
  enddo
  write(6,*)
  write(6,*)' Matrix b imag part'
  do i=1,n
   write(6,100)(dimag(b(i,j)),j=1,n)
  enddo
 endif
 do i=1,m
  do j=1,n
   a(i,j)=dconjg(b(j,i))   ! b+(m,n)
  enddo
 enddo
if(ipr.gt.2)then
  write(6,*)
  write(6,*)' Matrix b+ real part'
  do i=1,n
   write(6,100)(dble(a(i,j)),j=1,n)
  enddo
  write(6,*)
  write(6,*)' Matrix b+ imag part'
  do i=1,n
   write(6,100)(dimag(a(i,j)),j=1,n)
  enddo
do i=1,n
 do j=1,n
  f(i,j)=czero
  do k=1,n
   f(i,j)=f(i,j)+a(i,k)*b(k,j)
  enddo
 enddo
enddo
write (6,*)' unitarity test'
 do i=1,n
   write(6,100)(dble(f(i,j)),j=1,n)
 enddo
endif
do i=1,n
 do j=1,n
  c(i,j)=czero
  do k=1,n
   c(i,j)=c(i,j)+a(i,k)*h(k,j)
  enddo
 enddo
enddo
if(ipr.gt.2)then
  write(6,*)
  write(6,*)' Matrix b+ x h real part'
  do i=1,n
   write(6,100)(dble(c(i,j)),j=1,n)
  enddo
  write(6,*)
  write(6,*)' Matrix b+ x h imag part'
  do i=1,n
   write(6,100)(dimag(c(i,j)),j=1,n)
  enddo
endif
do i=1,n
 do j=1,n
  d(i,j)=czero
  do k=1,n
   d(i,j)=d(i,j)+c(i,k)*b(k,j)
  enddo
 enddo
enddo

if(ipr.gt.1)then
 write(6,*)' Transformed matrix D real part'
 do i=1,m
  write(6,100)(dble(d(i,j)),j=1,m)
 enddo
 write(6,*)' D imag part'
 do i=1,m
  write(6,100)(dimag(d(i,j)),j=1,m)
 enddo
endif
100 format(7f12.6)
101 format(2i4,'   m, n')
102 format(2i4,4f16.7)
return
end

