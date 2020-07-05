%-Abstract
%
%   CSPICE_DSKV02 returns specified vertices from a type 2 DSK segment.
%
%-Disclaimer
%
%   THIS SOFTWARE AND ANY RELATED MATERIALS WERE CREATED BY THE
%   CALIFORNIA  INSTITUTE OF TECHNOLOGY (CALTECH) UNDER A U.S.
%   GOVERNMENT CONTRACT WITH THE NATIONAL AERONAUTICS AND SPACE
%   ADMINISTRATION (NASA). THE SOFTWARE IS TECHNOLOGY AND SOFTWARE
%   PUBLICLY AVAILABLE UNDER U.S. EXPORT LAWS AND IS PROVIDED
%   "AS-IS" TO THE RECIPIENT WITHOUT WARRANTY OF ANY KIND, INCLUDING
%   ANY WARRANTIES OF PERFORMANCE OR MERCHANTABILITY OR FITNESS FOR
%   A PARTICULAR USE OR PURPOSE (AS SET FORTH IN UNITED STATES UCC
%   SECTIONS 2312-2313) OR FOR ANY PURPOSE WHATSOEVER, FOR THE
%   SOFTWARE AND RELATED MATERIALS, HOWEVER USED.
%
%   IN NO EVENT SHALL CALTECH, ITS JET PROPULSION LABORATORY,
%   OR NASA BE LIABLE FOR ANY DAMAGES AND/OR COSTS, INCLUDING,
%   BUT NOT LIMITED TO, INCIDENTAL OR CONSEQUENTIAL DAMAGES OF
%   ANY KIND, INCLUDING ECONOMIC DAMAGE OR INJURY TO PROPERTY
%   AND LOST PROFITS, REGARDLESS OF WHETHER CALTECH, JPL, OR
%   NASA BE ADVISED, HAVE REASON TO KNOW, OR, IN FACT, SHALL
%   KNOW OF THE POSSIBILITY.
%
%   RECIPIENT BEARS ALL RISK RELATING TO QUALITY AND PERFORMANCE
%   OF THE SOFTWARE AND ANY RELATED MATERIALS, AND AGREES TO
%   INDEMNIFY CALTECH AND NASA FOR ALL THIRD-PARTY CLAIMS RESULTING
%   FROM THE ACTIONS OF RECIPIENT IN THE USE OF THE SOFTWARE.
%
%-I/O
%
%   Given:
%
%      handle    is the handle of a DSK file containing a type 2
%                segment from which data are to be fetched.
%
%                [1,1] = size(handle); int32 = class(handle)
%
%      dladsc    is the DLA descriptor associated with the segment
%                from which data are to be fetched.
%
%                [SPICE_DLA_DSCSIZ,1]  = size(dladsc)
%                                int32 = class(dladsc)
%
%      start     is the ID of the first vertex to be fetched from the
%                segment designated by `handle' and `dladsc'. The ID
%                of a vertex is its ordinal position within the
%                segment. Vertex IDs range from 1 to NV, where NV is
%                the number of vertices in the segment.
%
%                [1,1] = size(start); int32 = class(start)
%
%                Note that Fortran-style 1-based indexing is used for
%                vertex IDs because these IDs must be consistent with
%                the IDs used in DSK files, across all languages
%                supported by SPICE.
%
%      room      is the maximum number of vertices to return.
%
%                [1,1] = size(room); int32 = class(room)
%
%   the call:
%
%      [vrtces] = cspice_dskv02( handle, dladsc, start, room )
%
%   returns:
%
%      vrtces    is the array representing a contiguous set of `n' vertices,
%                where `n' is between 1 and `room' inclusive. The returned
%                vertices are arranged in order of increasing vertex ID.
%                The IDs of the returned vertices range from
%
%                    start
%
%                to
%
%                    start + n - 1
%
%
%                [3,n] = size(vrtces); double = class(vrtces)
%
%                Each vertex is a 3-vector. The correspondence of elements
%                of `vrtces' with the elements of the set of vertices
%                contained in the segment is:
%
%                   vrtces[1,1]      segment_vertex_set(1, start)
%                   vrtces[2,1]      segment_vertex_set(2, start)
%                   vrtces[3,1]      segment_vertex_set(3, start)
%                     ...             ...
%                   vrtces[1,n]      segment_vertex_set(1, start+n-1)
%                   vrtces[2,n]      segment_vertex_set(2, start+n-1)
%                   vrtces[3,n]      segment_vertex_set(3, start+n-1)
%
%                The vertices are expressed in the body-fixed
%                reference frame of the segment designated by `handle'
%                and `dladsc'. The center of this frame is the origin
%                of the cartesian coordinate system in which the
%                vertices are expressed. Note that the frame center
%                need not coincide with the central body of the
%                segment. Units are km.
%
%                If an error occurs on the call, `vrtces' is
%                undefined.
%
%-Examples
%
%   Any numerical results shown for this example may differ between
%   platforms as the results depend on the SPICE kernels used as input
%   and the machine specific arithmetic implementation.
%
%      Look up all the vertices associated with each plate
%      of the model contained in a specified type 2 segment. For each
%      plate, display the plate's vertices and normal vector.
%
%      For this example, we'll show the context of this look-up:
%      opening the DSK file for read access, traversing a trivial,
%      one-segment list to obtain the segment of interest.
%
%         function dskz02_t
%
%            %
%            % MiceUser globally defines DSK parameters.
%            % For more information, please see DSKMiceUser.m and
%            % DSKMice02.m.
%            %
%            MiceUser
%
%            %
%            % Constants
%            %
%            PBUFSIZ = 10000;
%
%            %
%            % Initial values
%            %
%            verts = zeros(3,3);
%
%
%            %
%            % Prompt for the name of a DSK file.
%            %
%            dsk = input( 'Enter DSK name         > ','s');
%
%            %
%            % Open the DSK file for read access.
%            % We use the DAS-level interface for
%            % this function.
%            %
%            handle  = cspice_dasopr( dsk );
%
%            %
%            % Begin a forward search through the
%            % kernel, treating the file as a DLA.
%            % In this example, it's a very short
%            % search.
%            %
%            [dladsc, found] = cspice_dlabfs( handle );
%
%            if ~found
%
%               %
%               % We arrive here only if the kernel
%               % contains no segments. This is
%               % unexpected, but we're prepared for it.
%               %
%               fprintf( 'No segments found in DSK file %s\n', dsk )
%               return
%
%            end
%
%            %
%            % If we made it this far, `dladsc' is the
%            % DLA descriptor of the first segment.
%            %
%            % Get segment vertex and plate counts.
%            %
%            [nv, np] = cspice_dskz02( handle, dladsc );
%
%            fprintf( '\n' )
%            fprintf( 'Number of vertices:  %d\n', nv )
%            fprintf( 'Number of plates:    %d\n', np )
%
%            %
%            %  Display the vertices of each plate.
%            %
%            remain = np;
%            start  = 1;
%
%            while (remain > 0 )
%
%               %
%               % `nread' is the number of plates we"ll read on this
%               % loop pass. Set `nread' to the minimum of PBUFSIZ
%               % and `remain'.
%               %
%               nread = min(PBUFSIZ, remain);
%
%               plates = cspice_dskp02( handle, dladsc, start, nread );
%
%               for  i = 1:(nread)
%
%                  plix = start + i - 1;
%
%                  %
%                  %  Read the vertices of the current plate.
%                  %
%                  for  j = 1:3
%
%                     verts(j,:) = cspice_dskv02( handle, ...
%                                                 dladsc, plates(j,i), 1 );
%
%                  end
%
%
%                  %
%                  % Display the vertices of the ith plate:
%                  %
%                  fprintf( '\n' )
%                  fprintf( 'Plate number: %d\n', i )
%
%                  for  j = 1:3
%                       fprintf( '   Vertex %d: ( %16.8e %16.8e %16.8e )\n', ...
%                                                            j, verts(j,:) )
%                  end
%
%                  %
%                  % Display the normal vector of the current plate:
%                  %
%                  normal = cspice_dskn02( handle, dladsc, plix );
%                  fprintf( '   Normal:   ( %16.8e %16.8e %16.8e )\n', normal )
%
%               end
%
%               start  = start  + nread;
%               remain = remain - nread;
%
%            end
%
%
%            %
%            % Close file.
%            %
%            cspice_dascls( handle )
%
%   MATLAB outputs:
%
%      Number of vertices:  12
%      Number of plates:    20
%
%      [Only the first and last few rows are shown]
%
%      Plate number: 1
%         Vertex 1: (   0.00000000e+00   0.00000000e+00   1.17557000e+00 )
%         Vertex 2: (   1.05146000e+00   0.00000000e+00   5.25731000e-01 )
%         Vertex 3: (   3.24920000e-01   1.00000000e+00   5.25731000e-01 )
%         Normal:   (   4.91124160e-01   3.56821347e-01   7.94654382e-01 )
%
%      Plate number: 2
%         Vertex 1: (   0.00000000e+00   0.00000000e+00   1.17557000e+00 )
%         Vertex 2: (   3.24920000e-01   1.00000000e+00   5.25731000e-01 )
%         Vertex 3: (  -8.50651000e-01   6.18034000e-01   5.25731000e-01 )
%         Normal:   (  -1.87592328e-01   5.77350079e-01   7.94654645e-01 )
%
%           ...
%
%      Plate number: 19
%         Vertex 1: (  -3.24920000e-01  -1.00000000e+00  -5.25731000e-01 )
%         Vertex 2: (   0.00000000e+00   0.00000000e+00  -1.17557000e+00 )
%         Vertex 3: (   8.50651000e-01  -6.18034000e-01  -5.25731000e-01 )
%         Normal:   (   1.87592328e-01  -5.77350079e-01  -7.94654645e-01 )
%
%      Plate number: 20
%         Vertex 1: (   8.50651000e-01  -6.18034000e-01  -5.25731000e-01 )
%         Vertex 2: (   0.00000000e+00   0.00000000e+00  -1.17557000e+00 )
%         Vertex 3: (   8.50651000e-01   6.18034000e-01  -5.25731000e-01 )
%         Normal:   (   6.07061680e-01   0.00000000e+00  -7.94654715e-01 )
%
%-Particulars
%
%   None.
%
%-Required Reading
%
%   For important details concerning this module's function, please
%   refer to the CSPICE routine dskv02_c.
%
%   MICE.REQ
%   DAS.REQ
%   DSK.REQ
%
%-Version
%
%   -Mice Version 1.0.0, 04-APR-2017, NJB (JPL), EDW (JPL), ML (JPL)
%
%-Index_Entries
%
%   return specified vertices from type 2 DSK segment
%
%-&

function [vrtces] = cspice_dskv02( handle, dladsc, start, room )

   switch nargin
      case 4

         handle = zzmice_int( handle );
         dladsc = zzmice_int( dladsc );
         start  = zzmice_int( start  );
         room   = zzmice_int( room, [1, int32(inf)/2] );

      otherwise

         error ( [ 'Usage: [vrtces] = ' ...
                   'cspice_dskv02( handle, dladsc, start, room ) ' ] )
   end

   %
   % Call the MEX library.
   %
   try

      [vrtces] = mice( 'dskv02_c', ...
                       handle, dladsc, start, room );
   catch
      rethrow(lasterror)
   end
