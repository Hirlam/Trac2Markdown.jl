```@meta
EditURL="https://hirlam.org/trac//wiki//How_to_use_hires_topography/hires_convert.f?action=edit"
```
```bash
       program hires_convert
!=======================================================================
! For use when replacing GTOPO30 topography files with equivalents
! containing high-resolution Aster data.
!
! Strip out header from single intermediate topography file, 
! and write everything out again in format expected by PGD; 
! i.e., in 2 files, first a "header" file.hdr file, 
! then a "data" or file.dir file.  
! These still have the "old" gtopo30 names, but contain Aster data!!
!=======================================================================
!
       implicit none
       character(len=100)     ::  ystring
       character(len=50)      ::  caux
       integer*4 :: north, south, east, west, ios
!
       real*8                 ::  deltax, deltay
       integer*4              ::  npts_ns, npts_ew, i,j
       integer*4, allocatable ::  elevation(:)
       integer*2, allocatable ::  elev_hm(:,:)
       integer*2              ::  idata
       character*2            ::  cdata, ctmp
       equivalence (idata, cdata)
!
!
!=======================================================================
!    Start of code executable section.
!=======================================================================
!
!  Open original file and read header from it:
       open(unit=21,file='hires_topog.dat',status='old',
     &      form='unformatted')
       read(21) north, south, east, west
       read(21) deltax, deltay, npts_ns, npts_ew
!
       Write(*,*) 'North, South, East, West limits are:',
     &             north, south, east, west
       write(*,*) 'deltax, deltay, npts_ns, npts_ew are:',
     &             deltax, deltay, npts_ns, npts_ew
!
       allocate (elevation(npts_ew))
!
!    Header file for harmonie:
       open(unit=23,file="gtopo30.hdr",form='formatted',
     &      status='new',IOSTAT=ios)
       if(ios.eq.0) then
            write(23,FMT='(A)') "ASTER topography model, starting UL"
            write(23,FMT='(A)') "nodata: -9999"
                  write(caux,*) north
            write(23,FMT='(A)') "north: "//adjustl(trim(caux))
                  write(caux,*) south
            write(23,FMT='(A)') "south: "//adjustl(trim(caux))
                  write(caux,*) west
            write(23,FMT='(A)') "west: "//adjustl(trim(caux))
                  write(caux,*) east
            write(23,FMT='(A)') "east: "//adjustl(trim(caux))
                  write(caux,*) npts_ns
            write(23,FMT='(A)') "rows: "//adjustl(trim(caux))
                  write(caux,*) npts_ew
            write(23,FMT='(A)') "cols: "//adjustl(trim(caux))
            write(23,FMT='(A)') "recordtype: integer 16 bits"
       else
            write(*,*) "Problem opening hires_irluk_hm.hdr; must quit!"
            stop
       endif
            close(23)
!
!   So that's the header done. Now for main data:
!
       allocate (elev_hm(npts_ew,npts_ns))
!
!  Start of main (outer) loop (i.e., working from North to South):
       do j=1,npts_ns
          read(21) elevation
          elev_hm(:,j) = elevation(:)
       enddo
          close(21)
          deallocate(elevation)
!
!  So now elev_hm should be filled.
!
!  Byte-swap from little to big-endian (for sake of Harmonie build...):
       do j=1,npts_ns
          do i=1,npts_ew
              idata = elev_hm(i,j)
              ctmp(1:1) = cdata(1:1)
              cdata(1:1) = cdata(2:2)
              cdata(2:2) = ctmp(1:1)
              elev_hm(i,j) = idata
          enddo
       enddo
!
       open(unit=24,file="gtopo30.dir",form="unformatted",
     &      access="direct",recl=npts_ns*npts_ew*2,status="new",err=999)
!
!  j=1 is northmost limit:
!  Write starting from SW corner, working east, then north one row:
!       write(24,rec=1) ((elev_hm(i,j),i=1,npts_ew), j=npts_ns,1,-1)
!  Write starting from NW corner, working east, then south one row:
        write(24,rec=1) ((elev_hm(i,j),i=1,npts_ew), j=1,npts_ns)
        close(24)
        deallocate(elev_hm)
!
       stop 'Normal end'
 999   stop 'Problem opening hires_irluk_hm.dir file.  Quitting.'
       end
```