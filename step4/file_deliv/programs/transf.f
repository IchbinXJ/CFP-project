      subroutine transf(n,T,iwf,ipr)
! transf provides transformation matrices for Ylm basis
! as well as for real, normalized spherical harmonics
! see K. Kurki-Suomi Israel J. Chem. 16, 115 (1977)
      complex*16 img,czero,T(n,n),sum
      logical unitary
      czero=(0.,0.)
      img=(0.,1.)
      s2=sqrt(2.)
      do m1=1,n
       do m2=1,n
        T(m1,m2)=czero
       enddo
      enddo
      l=(n-1)/2
       write(6,101)L
101    format(' L=',i3,'. Unitary transformation from w90 real to |LM> basis')
      if(L.eq.3)then
       if(iwf.eq.0)then
        write(6,*)' 2014  w2w ordering of wf'
        T(1, 3)= 1./s2      ! xz^2 
        T(1, 5)=-1./s2
  
        T(2,3)=img/s2       ! yz^2
        T(2,5)=img/s2
  
        T(3,4)= 1.          ! z^3
 
        T(4,1)= 1./s2       ! x(x^2-3y^2)
        T(4,7)=-1./s2

        T(5,1)=img/s2       ! y(3x^2-y^2)
        T(5,7)=img/s2
  
        T(6, 2)= 1./s2      ! z(x^2-y^2)
        T(6, 6)= 1./s2
 
        T(7,2)=img/s2       ! xyz
        T(7,6)=-img/s2
       else if(iwf.eq.1)then
        write(6,*)' 2012 w2w ordering of wf'
        T(1, 1)=img/s2      ! 3+
        T(1, 7)=img/s2

        T(2,2)= 1./s2      ! 2+
        T(2,6)= 1./s2

        T(3,3)=img/s2      ! 1+
        T(3,5)=img/s2

        T(4,3)=1./s2       ! 1-
        T(4,5)=-1./s2

        T(5,2)=img/s2      ! 2-
        T(5,6)=-img/s2

        T(6, 1)= 1./s2     ! 3-
        T(6, 7)=-1./s2

        T(7,4)=1.           ! 0

       endif
      else if(L.eq.2)then
       T(1,1)=img/s2       ! xy
       T(1,5)=-img/s2

       T(2,2)=img/s2       ! yz
       T(2,4)=img/s2

       T(3,2)=1./s2        ! xz
       T(3,4)=-1./s2

       T(4,1)=1./s2        ! x^ - y^2
       T(4,5)=1./s2 

       T(5,3)=1.           ! z^2
      endif
      if(ipr.gt.0)then
       write(6,*)' Real part of unitary matrix'
      do m1=1,n
       write(6,555)(dble(T(m1,m2)),m2=1,n)
      enddo
      write(6,*)' Imaginary part of unitary matrix'
      do m1=1,n
       write(6,555)(imag(T(m1,m2)),m2=1,n)
      enddo
      endif
      if(ipr.gt.2)then
       write(6,*)' Real part of herm. conjugate matrix'
       do m1=1,n
        write(6,555)(dble(conjg(T(m2,m1))),m2=1,n)
       enddo
       write(6,*)' Imaginary part of herm. conjugate matrix'
       do m1=1,n
        write(6,555)(imag(conjg(T(m2,m1))),m2=1,n)
       enddo
      endif
! test of unitarity
      unitary=.true.
      do m1=1,n
       do m2=1,n
        sum=0.
        do m3=1,n
         sum=sum+T(m1,m3)*conjg(T(m2,m3))         
        enddo
        if(m1.eq.m2)then
         if(abs(sum-1.).gt.0.000001)then
          write(6,666)m1,m2,sum
          unitary=.false.
666       format(' incorrect normalization',2i4,2f12.5)
         endif
        else
         if(abs(sum).gt.0.000001)then
          write(6,667)m1,m2,sum
          unitary=.false.
667       format(' incorrect orthogonality',2i4,2f12.5)
         endif
        endif
       enddo
      enddo
      if(ipr.gt.1)then
       if(unitary)write(6,*)' Unitarity of transformation checked'
      endif
555   format(7f9.4)
      return
      end
