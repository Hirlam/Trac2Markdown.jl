```@meta
EditURL="https://hirlam.org/trac//wiki//hires_topog_gather_tiles.f?action=edit"
```
```bash
       program hires_topog_gather_tiles
!=======================================================================
!  Program to read unpacked ASTER (lon,lat,elevation)
!  data written in simple ascii files and write out
!  just the elevation in one complete binary file.
!
!  The file consists of a header containing:
!    north, south, east, west (lon, lat limits)
!    longitude increment (deltax), latitude increment (deltay)
!          No. lon. points, No. lat. points
!    elevation data
!        (with each record consisting of a line of latitude,
!         starting at NW corner, proceeding eastwards.
!         Each subsequent record is from next row to south.)
!
!  Method is to open one granule box at a time, starting at NW,
!  working eastwards then southwards.
!  From each box, extract elevation points.
!  Once a complete row of boxes at each lat. are read,
!  write out complete row of elevations at each lat. to final file.
!
!=======================================================================

!=======================================================================
!    Declarations:
!=======================================================================
       implicit none
       integer, parameter :: gran_dim=3601, gran_size=12967201
       integer, parameter :: box_dim=3600, box_size=12960000
! compact domain size:
!      integer, parameter :: north=60, south=49, east=3, west=-11
! extended domain size:
       integer, parameter :: north=60, south=48, east=3, west=-15
!
       real*8                 ::  lon_in, lat_in, deltax, deltay
       integer*4              ::  npts_ns, npts_ew, jlim
       integer*4              ::  i,j,k, nbox_x, nbox_y, ibox_x, ibox_y
       integer*4              ::  latbox_id,lonbox_id
       integer*4              ::  box_elev(gran_dim,gran_dim,east-west)
       integer*4, allocatable ::  elevation(:)
       character*27           ::  fname_asc_curr
       character*1            ::  charid
       logical                ::  file_exists
       data fname_asc_curr /'ASTGTM2_N***0**_dem.tif.xyz'/
!
!=======================================================================
!    Start of code execution:
!=======================================================================
!  These next 4 numbers are essentially derived from "parameters" above:
       deltax = 1.d0/dble(box_dim)
       deltay = deltax
       npts_ns = box_dim*(north - south) + 1
       npts_ew = box_dim*(east - west) + 1

       nbox_x = east - west      ! resolves to 14 (compact), or 18 (extended)
       nbox_y = north - south    ! resolves to 11 (compact), or 12 (extended)

       allocate (elevation(npts_ew))

!  Open output file and write header to it:
       open(unit=21,file='hires_topog.dat',status='new',
     &      form='unformatted')
       write(21) north, south, east, west
       write(21) deltax, deltay, npts_ns, npts_ew


!  Start of main (outer) loop over all Aster granules (and even empty seas...)
       do ibox_y=1,nbox_y       ! from north to south
         write(*,*) 'Starting to process Lat. box ', ibox_y
         do ibox_x=1,nbox_x     ! from west to east
         write(*,*) '    Starting to process Lon. box ', ibox_x

!      So now we're in a coarse-grained box id:
!      Are we over sea (elev=0), or do we have data?
           latbox_id = north - ibox_y      ! actual lat. in ascii filename
           lonbox_id = west + ibox_x  -1   ! actual lon. in ascii filename
           if(lonbox_id .lt. 0) then       ! Handle lon. being west or east of 0
              lonbox_id = -lonbox_id
              charid = 'W'
           else
              charid = 'E'
           endif
           write(*,*)'lon, lat box ids are:',latbox_id,charid,lonbox_id

!  Fill in variable bits of ascii data file-name:
           write(fname_asc_curr(10:11),'(i2)') latbox_id
           write(fname_asc_curr(12:12),'(a1)') charid
           if(lonbox_id.ge.10) then
             write(fname_asc_curr(14:15),'(i2)') lonbox_id
           else
             write(fname_asc_curr(14:14),'(a1)') '0'
             write(fname_asc_curr(15:15),'(i1)') lonbox_id
           endif

           inquire(FILE=fname_asc_curr,EXIST=file_exists)

           if(file_exists) then
              open(22,file=fname_asc_curr,form='formatted',status='old')
              write(*,*) "File ",fname_asc_curr," opened for reading..."

!  Internal loop over lon, lat within each granule box:
             do j=1,gran_dim
               do i=1,gran_dim
                  read(22,*) lon_in, lat_in, box_elev(i,j,ibox_x)
               enddo
             enddo
                  close(22)

           else
              box_elev(:,:,ibox_x) = 0
           endif

!  So we have box_elev(:,:,ibox_x) filled.
         enddo    ! end of loop over ibox_x

!  Now we're at end of latitude row, fill in elevation for complete row:
              if(ibox_y.eq.nbox_y) then
                  jlim = gran_dim
              else
                  jlim = box_dim
              endif

              do j=1,jlim
                 do k=1,nbox_x
                   do i=1,box_dim
                       elevation(i + (k-1)*box_dim) = box_elev(i,j,k)
                   end do
                 end do
                 elevation(box_dim*nbox_x+1)=box_elev(gran_dim,j,nbox_x)
                 write(21) elevation
              end do

           write(*,*) "One complete row of granules written to binary."

       enddo       ! End of main outer loop over ibox_y (all boxes)

       close(21)
       stop 'Normal end'
       end
```