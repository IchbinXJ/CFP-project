SHELL = /bin/sh
FC = ifort
MPF = mpif90
CC = gcc
FOPT     = -FR -mp1 -w -prec_div -pc80 -pad -ip -DINTEL_VML -traceback -assume buffered_io 
FPOPT =  $(FOPT) -Dmkl_scalapack 
DParallel = '-DParallel'
FGEN     =  $(PARALLEL)
LDFLAGS = $(FOPT) -L$(MKLROOT)/lib/$(MKL_TARGET_ARCH) -pthread
R_LIBS   =     -lmkl_lapack95_lp64 -lmkl_intel_lp64 -lmkl_intel_thread -lmkl_core -openmp -lpthread
RP_LIBS =   -lmkl_scalapack -lmkl_blacs_lp64 $(R_LIBS)
DESTDIR  = .
EXECNAME = bkq   
P_EXECNAME =    bkq_mpi

###############################################################################
###############################################################################


EXEC = $(DESTDIR)/$(EXECNAME)
P_EXEC = $(DESTDIR)/$(P_EXECNAME)

#..............................................................................
#
#  Routines which can be compiled unmodified
#
OBJS =  bkq.f  trafo.f transf.f  tensor.f

#..............................................................................
default: seq

all: 
	make seq para

seq: keep_seq_files
	$(MAKE) $(EXEC) FORT=$(FC) FFLAGS='$(FGEN) $(FOPT)'

para: keep_par_files
	$(MAKE) $(P_EXEC) FORT=$(MPF) FFLAGS='$(FGEN) $(FPOPT) $(DParallel)'

#..............................................................................

$(EXEC): $(OBJS)
	$(FORT) -o $(EXEC) $(OBJS) $(LDFLAGS) $(R_LIBS)
$(P_EXEC): $(P_OBJS)
	$(FORT) -o $(P_EXEC) $(P_OBJS) $(LDFLAGS) $(RP_LIBS)

keep_seq_files:
	if [ -f .parallel ]; then \
		rm -f .parallel $(P_OBJS) *.mod; \
	fi
	touch .sequential

keep_par_files:
	if [ -f .sequential ]; then \
		rm -f .sequential $(OBJS) *.mod; \
	fi
	touch .parallel
#..............................................................................
#
#  All routines depend upon an include file (contains common PARAMETERS)
#
$(OBJS):		Makefile
$(OBJSMOD):		modules.o

clean:
	-rm -f *.o _tmp_.* *.P .real .complex .sequential .parallel *.mod

#..............................................................................
#
#
.f.o:
	$(FORT) $(FFLAGS) -c $<
.F.o:
	$(FORT) $(FFLAGS) -c $<
#${OBJS} : %.o : %.f90
#	$(FC) $(FFLAGS) -c $< 

