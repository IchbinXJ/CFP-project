subroutine sphten(l,n,ckq,norm,ipr)
! irreducible spherical tensor operators
! input file is Cqk_f (Cqk_d), which should be copied on fort.90
implicit real*8(a-h,o-z)
real*8, allocatable  :: ckqa(:,:,:,:)
real*8 ckq(0:n,-n:n,-l:l,-l:l),norm(0:n,-l:l)
integer q,q1
n=2*l             ! n <-> m relative to bkq
m=2*l+1
allocate (ckqa(0:n,-n:n,-l:l,-l:l))
do k=0,n
 do q=-n,n
  do i=-l,l
   do j=-l,l
    ckq(k,q,i,j)=0.
   enddo
  enddo
 enddo
enddo
! lanthanide Ckq
do i=-l,l        ! unit operator goes first
 ckq(0,0,i,i)=1.
enddo
do k=2,n,2
 do q=-k,k
  read(90,*)ik,iq     ! read lanthanide k,q
  do i=-l,l
   do j=i,l
    read(90,*)ckq(k,q,i,j)
    ckqa(k,q,j,i)=ckq(k,q,i,j)    ! adjoint operators
   enddo
  enddo
 enddo
enddo
do k=2,n,2       ! lanthanide Ckq with q>0
 do q=1,k
  do i=-l,l
   do j=-l,l
    ckq(k,q,i,j)=ckqa(k,-q,i,j)
    ckqa(k,q,i,j)=ckq(k,-q,i,j)
   enddo
  enddo
 enddo
enddo
norm(0,0)=2*l+1        ! norm of unit operator
if(ipr.gt.0)then
 write(6,*)' spherical tensors: check of orthogonality, norm calculation'
 write(6,*)'  k   q  k1  q1   Ckq*Ck1q1'
 write(6,101)0,0,0,0,norm(0,0)
endif
do k=2,n,2
 do k1=k,n,2
  do q=-k,k
   do q1=-k1,k1
    s=0.
    do i=-l,l
     do j=-l,l
      s=s+ckq(k,q,i,j)*ckq(k1,q1,i,j)
     enddo
    enddo
    if(s.gt.0.0000001)then
     if(ipr.gt.0)write(6,101)k,q,k1,q1,s
     norm(k,q)=s
    endif
   enddo
  enddo
 enddo
enddo
101 format(4i4,f12.7)
if(ipr.gt.1)then
 write(6,*)  
! print operators
 do k=2,n,2
  do q=0,k
   write(6,*)' Ckq, k,q=',k,q
   do i=-l,l
    write(6,100)(ckq(k,q,i,j),j=-l,l)
   enddo
   write(6,*)' Ckq+, k,q=',k,q
   do i=-l,l
    write(6,100)(ckqa(k,q,i,j),j=-l,l)
   enddo
   if(q.gt.0)then
    write(6,*)' Ckq, k,q=',k,-q
    do i=-l,l
     write(6,100)(ckq(k,-q,i,j),j=-l,l)
    enddo
    write(6,*)' Ckq+, k,q=',k,-q
    do i=-l,l
     write(6,100)(ckqa(k,-q,i,j),j=-l,l)
    enddo
   endif
  enddo
 enddo
endif
100 format(7f10.6)
return
end
