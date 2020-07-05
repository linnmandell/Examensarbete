%-Abstract
%
%   Deprecated: This routine has been superseded by the CSPICE routines
%   cspice_ilumin, cspice_illumg and cspice_illumf. This routine is
%   supported for purposes of backward compatibility only.
%
%   CSPICE_ILLUM_PL02 returns the illumination angles---phase, solar
%   incidence, and emission---at a specified point on a target body at a
%   particular epoch, optionally corrected for light time and stellar
%   aberration. The target body's surface is represented by a triangular
%   plate model contained in a type 2 DSK segment.
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
%      handle      the DAS file handle of a DSK file open for read
%                  access. This kernel must contain a type 2 segment
%                  that provides a plate model representing the entire
%                  surface of the target body.
%
%                  [1,1] = size(handle); int32 = class(handle)
%
%      dladsc      the DLA descriptor of a DSK segment representing
%                  the surface of the target body.
%
%                  [SPICE_DLA_DSCSIZ,1]  = size(dladsc)
%                                int32 = class(dladsc)
%
%      target      the name of the target body. `target' is
%                  case-insensitive, and leading and trailing blanks in
%                  `target' are not significant. Optionally, you may supply
%                  a string containing the integer ID code for the object.
%                  For example both 'MOON' and '301' are legitimate strings
%                  that indicate the moon is the target body.
%
%                  This routine assumes that the target body's surface is
%                  represented using a plate model, and that a DSK file
%                  containing the plate model has been loaded via cspice_dasopr.
%
%                  [1,c1] = size(target); char = class(target)
%
%                     or
%
%                  [1,1] = size(target); cell = class(target)
%
%      et          the epoch, represented as seconds past J2000 TDB, at
%                  which the illumination angles are to be computed. When
%                  aberration corrections are used, `et' refers to the
%                  epoch at which radiation is received at the observer.
%
%                  [1,1] = size(et); double = class(et)
%
%      abcorr      indicates the aberration corrections to be applied to
%                  the position and orientation of the target body and the
%                  position of the Sun to account for one-way light time
%                  and stellar aberration. See the discussion in the
%                  Particulars section for recommendations on how to choose
%                  aberration corrections.
%
%                  [1,c2] = size(abcorr); char = class(abcorr)
%
%                     or
%
%                  [1,1] = size(abcorr); cell = class(abcorr)
%
%                  `abcorr' may be any of the following:
%
%                     'NONE'     Apply no correction. Use the geometric
%                                positions of the Sun and target body
%                                relative to the observer; evaluate the
%                                target body's orientation at `et'.
%
%                  The following values of `abcorr' apply to the
%                  "reception" case in which photons depart from the
%                  target's location at the light-time corrected epoch
%                  et-lt and *arrive* at the observer's location at
%                  `et':
%
%                     'LT'       Correct for one-way light time (also
%                                called "planetary aberration") using a
%                                Newtonian formulation. This correction
%                                uses the position and orientation of the
%                                target at the moment it emitted photons
%                                arriving at the observer at `et'. The
%                                position of the Sun relative to the
%                                target is corrected for the one-way light
%                                time from the Sun to the target.
%
%                                The light time correction uses an
%                                iterative solution of the light time
%                                equation (see Particulars for details).
%                                The solution invoked by the 'LT' option
%                                uses one iteration.
%
%                     'LT+S'     Correct for one-way light time and stellar
%                                aberration using a Newtonian formulation.
%                                This option modifies the positions
%                                obtained with the 'LT' option to account
%                                for the observer's velocity relative to
%                                the solar system barycenter (note the
%                                target plays the role of "observer" in the
%                                computation of the aberration-corrected
%                                target-Sun vector). The result is that the
%                                illumination angles are computed using
%                                apparent position and orientation of the
%                                target as seen by the observer and the
%                                apparent position of the Sun as seen by
%                                the target.
%
%                     'CN'       Converged Newtonian light time correction.
%                                In solving the light time equation, the
%                                'CN' correction iterates until the
%                                solution converges (three iterations on
%                                all supported platforms).
%
%                     'CN+S'     Converged Newtonian light time
%                                and stellar aberration corrections.
%
%      obsrvr      the name of the observing body. This is typically a
%                  spacecraft, the earth, or a surface point on the earth.
%                  `obsrvr' is case-insensitive, and leading and trailing
%                  blanks in `obsrvr' are not significant. Optionally, you
%                  may supply a string containing the integer ID code for
%                  the object. For example both 'EARTH' and '399' are
%                  legitimate strings that indicate the earth is the
%                  observer.
%
%                  [1,c3] = size(obsrvr); char = class(obsrvr)
%
%                     or
%
%                  [1,1] = size(obsrvr); cell = class(obsrvr)
%
%      spoint      a surface point on the target body, expressed in
%                  rectangular body-fixed (body equator and prime meridian)
%                  coordinates. `spoint' need not be visible from the
%                  observer's location at time `et'.
%
%                  [3,1] = size(spoint); double = class(spoint)
%
%   the call:
%
%      [phase, solar, emissn] =                            ...
%               cspice_illum_pl02( handle, dladsc, target, ...
%                                  et,     abcorr, obsrvr, ...
%                                  spoint )
%
%   returns:
%
%               For all of the angles below, if `spoint' does not lie on
%               one of the *exterior* plates comprising the DSK type 2
%               surface representation, the "intercept" style
%               "sub-observer point" corresponding to `spoint' is used
%               in the illumination angle computations in place of
%               `spoint'. The selected point will always be on the
%               *outermost* plate intersected by a ray emanating from
%               the target body's center and passing through `spoint'.
%
%               See the header of CSPICE_SUBPT_PL02 for details
%               concerning the definition of the sub-observer point.
%
%               In all cases, the normal vector is taken from the plate
%               on which the sub-point corresponding to `spoint' lies.
%               If this sub-point lies on an edge or vertex, a normal
%               vector for one of the bordering plates is selected.
%
%
%   phase       the phase angle at `spoint', as seen from `obsrvr' at
%               time `et'. This is the angle between the spoint-obsrvr
%               vector and the spoint-sun vector. Units are radians. The
%               range of `phase' is [0, pi].
%
%               [1,1] = size(phase); double = class(phase)
%
%   solar       the solar incidence angle at `spoint', as seen from
%               `obsrvr' at time `et'. This is the angle between the
%               surface normal vector at `spoint' and the spoint-sun
%               vector. Units are radians. The range of `solar' is [0,
%               pi].
%
%               [1,1] = size(solar); double = class(solar)
%
%   emissn      the emission angle at `spoint', as seen from `obsrvr'
%               at time `et'. This is the angle between the surface
%               normal vector at `spoint' and the spoint-observer
%               vector. Units are radians. The range of `emissn' is
%               is [0, pi].
%
%               [1,1] = size(emissn); double = class(emissn)
%
%               See Particulars below for a detailed discussion of the
%               definitions of these angles.
%
%-Examples
%
%   Any numerical results shown for this example may differ between
%   platforms as the results depend on the SPICE kernels used as input
%   and the machine specific arithmetic implementation.
%
%      Find the illumination angles at both the sub-observer point and
%      sub-solar point on Phobos as seen from Mars for a specified
%      sequence of times. Perform each computation twice, using both the
%      "intercept" and "ellipsoid near point" options for the sub-observer
%      point and sub-solar point computations. Compute the corresponding
%      illumination angles using an ellipsoidal surface for comparison.
%      (Note that the surface points on the plate model generally will
%      not lie on the ellipsoid's surface, so the emission and solar
%      incidence angles won't generally be zero at the sub-observer
%      and sub-solar points, respectively.)
%
%      In the following example program, the file
%
%         phobos_3_3.bds
%
%      is a DSK file containing a type 2 segment that provides a plate model
%      representation of the surface of Phobos.  The file
%
%         mar097.bsp
%
%      is a binary SPK file containing data for Phobos, Mars, and the
%      Sun for a time interval starting at the date
%
%         2000 JAN 1 12:00:00 TDB.
%
%      pck00010.tpc is a planetary constants kernel file containing radii
%      and rotation model constants.  naif0010.tls is a leapseconds kernel.
%
%      All of the kernels other than the DSK file should be loaded via
%      a meta-kernel.  An example of the contents of such a kernel is:
%
%          KPL/MK
%
%          File name: illum.tm
%
%          \begindata
%
%             KERNELS_TO_LOAD = ( 'naif0010.tls'
%                                 'pck00010.tpc'
%                                 'mar097.bsp' )
%          \begintext
%
%   Example:
%
%      function illum_pl02_t( meta, dsk )
%         %
%         % Constants
%         %
%         NCORR       = 2;
%         NSAMP       = 3;
%         NMETHOD     = 2;
%         FIXREF      = 'IAU_PHOBOS';
%         ILUM_METHOD = 'ELLIPSOID';
%         TOL         = 1.d-12;
%
%         %
%         % Initial values
%         %
%         abcorrs     = { 'NONE', 'CN+S' };
%         methods     = { 'Intercept', 'Ellipsoid near point' };
%
%         obsrvr      = 'Mars';
%         target      = 'Phobos';
%
%         %
%         % Load the meta kernel.
%         %
%         cspice_furnsh( meta )
%
%         %
%         % Open the DSK file for read access.
%         % We use the DAS-level interface for
%         % this function.
%         %
%         handle = cspice_dasopr( dsk );
%
%         %
%         % Begin a forward search through the
%         % kernel, treating the file as a DLA.
%         % In this example, it's a very short
%         % search.
%         %
%         [dladsc, found] = cspice_dlabfs( handle );
%
%         if ~found
%
%            %
%            % We arrive here only if the kernel
%            % contains no segments. This is
%            % unexpected, but we're prepared for it.
%            %
%            fprintf( 'No segments found in DSK file %s\n', dsk )
%            return
%
%         end
%
%         %
%         % If we made it this far, `dladsc' is the
%         % DLA descriptor of the first segment.
%         %
%         % Now compute sub-points using both computation
%         % methods. We'll vary the aberration corrections
%         % and the epochs.
%         %
%
%         et0      = 0.0;
%         stepsize = 1.d6;
%
%
%         for  i = 0:(NSAMP-1)
%
%            %
%            % Set the computation time for the ith sample.
%            %
%
%            et = et0 + i * stepsize;
%
%            timstr = cspice_timout( et,                                    ...
%                                    'YYYY-MON-DD HR:MN:SC.### ::TDB(TDB)' );
%
%
%            fprintf( '\n\nObservation epoch:  %s\n', timstr )
%
%
%            for  coridx = 1:NCORR
%
%               abcorr = abcorrs( coridx );
%
%               fprintf( '   abcorr = %s\n', char(abcorr) );
%
%               for  midx = 1:NMETHOD
%
%                  %
%                  % Select the computation method.
%                  %
%                  method = methods( midx );
%
%                  fprintf( '\n     Method =%s\n ', char(method) )
%
%                  %
%                  % Compute the sub-observer point using a plate
%                  % model representation of the target's surface.
%                  %
%                  [xpt, alt, plid] = ...
%                        cspice_subpt_pl02( handle, dladsc, method, ...
%                                           target, et,     abcorr, ...
%                                           obsrvr                    );
%
%                  %
%                  % Compute the illumination angles at the
%                  % sub-observer point.
%                  %
%                  [phase,  solar,  emissn] = cspice_illum_pl02( handle, ...
%                                                  dladsc, target, et, ...
%                                                  abcorr, obsrvr, xpt );
%
%                  %
%                  %  Represent the surface point in latitudinal
%                  % coordinates.
%                  %
%                  [ xr, xlon, xlat] = cspice_reclat( xpt );
%
%                  fprintf(                                                ...
%                  '\n     Sub-observer point on plate model surface:\n' )
%                  fprintf( '       Planetocentric Longitude (deg):  %f\n', ...
%                                                    xlon * cspice_dpr() )
%                  fprintf( '       Planetocentric Latitude  (deg):  %f\n', ...
%                                                    xlat * cspice_dpr() )
%
%                  fprintf(                                              ...
%                   '\n         Illumination angles derived using a\n' )
%                  fprintf( '         plate model surface:\n' )
%                  fprintf(                                              ...
%                    '             Phase angle              (deg): %f\n', ...
%                                                  phase  * cspice_dpr() )
%                  fprintf(                                              ...
%                   '             Solar incidence angle    (deg): %f\n', ...
%                                                  solar  * cspice_dpr() )
%                  fprintf(                                              ...
%                   '             Emission angle           (deg): %f\n\n', ...
%                                                  emissn * cspice_dpr() )
%                  %
%                  % Compute the illumination angles using an ellipsoidal
%                  % representation of the target's surface. The role of
%                  % this representation is to provide an outward surface
%                  % normal.
%                  %
%
%                  [trgepc, srfvec, phase,  solar,  emissn] = ...
%                                           cspice_ilumin( ILUM_METHOD,  ...
%                                               target, et,     FIXREF,  ...
%                                               abcorr, obsrvr, xpt);
%
%
%                  fprintf(                                              ...
%                   '         Illumination angles derived using an\n' )
%                  fprintf( '         ellipsoidal reference surface:':\n' )
%                  fprintf(                                              ...
%                   '             Phase angle              (deg): %f\n', ...
%                                                  phase  * cspice_dpr() )
%                  fprintf(                                              ...
%                   '             Solar incidence angle    (deg): %f\n', ...
%                                                  solar  * cspice_dpr() )
%                  fprintf(                                              ...
%                   '             Emission angle           (deg): %f\n\n', ...
%                                                  emissn * cspice_dpr() )
%
%
%
%                  %
%                  % Now repeat our computations using the
%                  % sub-solar point.
%                  %
%                  % Compute the sub-solar point using a plate model
%                  % representation of the target's surface.
%                  %
%
%                  [xpt, dist, plid] = ...
%                  cspice_subsol_pl02( handle, dladsc, method, ...
%                                      target, et,     abcorr, ...
%                                      obsrvr                    );
%
%                  %
%                  % Compute the illumination angles at the
%                  % sub-solar point.
%                  %
%
%                  [phase,  solar,  emissn] = cspice_illum_pl02( handle, ...
%                                                    dladsc, target, et, ...
%                                                    abcorr, obsrvr, xpt );
%
%                  %
%                  %  Represent the surface point in latitudinal
%                  % coordinates.
%                  %
%                  [ xr, xlon, xlat] = cspice_reclat( xpt );
%
%                  fprintf( '     Sub-solar point on plate model surface:\n' )
%                  fprintf( '       Planetocentric Longitude (deg):  %f\n', ...
%                                                     xlon * cspice_dpr() )
%                  fprintf( '       Planetocentric Latitude  (deg):  %f\n', ...
%                                                     xlat * cspice_dpr() )
%
%                  fprintf(                                              ...
%                   '\n         Illumination angles derived using a\n' )
%                  fprintf( '         plate model surface:\n' )
%                  fprintf(                                              ...
%                   '             Phase angle              (deg): %f\n', ...
%                                                  phase  * cspice_dpr() )
%                  fprintf(                                              ...
%                   '             Solar incidence angle    (deg): %f\n', ...
%                                                  solar  * cspice_dpr() )
%                  fprintf(                                              ...
%                   '             Emission angle           (deg): %f\n\n', ...
%                                                  emissn * cspice_dpr() )
%
%                  %
%                  % Compute the illumination angles using an ellipsoidal
%                  % representation of the target's surface. The role of
%                  % this representation is to provide an outward surface
%                  % normal.
%                  %
%
%                  [trgepc, srfvec, phase,  solar,  emissn] = ...
%                                           cspice_ilumin( ILUM_METHOD, ...
%                                           target, et,     FIXREF,     ...
%                                           abcorr, obsrvr, xpt);
%
%                  fprintf(                                              ...
%                   '         Illumination angles derived using an\n' )
%                  fprintf( '         ellipsoidal surface:\n' )
%                  fprintf(                                              ...
%                   '             Phase angle              (deg): %f\n', ...
%                                                  phase  * cspice_dpr() )
%                  fprintf(                                              ...
%                   '             Solar incidence angle    (deg): %f\n', ...
%                                                  solar  * cspice_dpr() )
%                  fprintf(                                              ...
%                   '             Emission angle           (deg): %f\n\n', ...
%                                                  emissn * cspice_dpr() )
%
%               end
%
%            end
%
%         end
%
%         %
%         % Close the DSK file. Unload all other kernels as well.
%         %
%         cspice_dascls( handle )
%
%         %
%         % It's always good form to unload kernels after use,
%         % particularly in Matlab due to data persistence.
%         %
%         cspice_kclear
%
%   MATLAB outputs:
%
%      >> illum_pl02_t( 'illum_pl02.tm' ,'phobos_3_3.bds')
%
%      Observation epoch:  2000-JAN-01 12:00:00.000 (TDB)
%         abcorr = NONE
%
%           Method =Intercept
%
%           Sub-observer point on plate model surface:
%             Planetocentric Longitude (deg):  -0.348118
%             Planetocentric Latitude  (deg):  0.008861
%
%               Illumination angles derived using a
%               plate model surface:
%                   Phase angle              (deg): 101.596824
%                   Solar incidence angle    (deg): 98.376877
%                   Emission angle           (deg): 9.812914
%
%               Illumination angles derived using an
%               ellipsoidal surface:
%                   Phase angle              (deg): 101.596824
%                   Solar incidence angle    (deg): 101.695444
%                   Emission angle           (deg): 0.104977
%
%           Sub-solar point on plate model surface:
%             Planetocentric Longitude (deg):  102.413905
%             Planetocentric Latitude  (deg):  -24.533127
%
%               Illumination angles derived using a
%               plate model surface:
%                   Phase angle              (deg): 101.665306
%                   Solar incidence angle    (deg): 13.068798
%                   Emission angle           (deg): 98.408735
%
%               Illumination angles derived using an
%               ellipsoidal surface:
%                   Phase angle              (deg): 101.665306
%                   Solar incidence angle    (deg): 11.594741
%                   Emission angle           (deg): 98.125499
%
%
%           Method =Ellipsoid near point
%
%           Sub-observer point on plate model surface:
%             Planetocentric Longitude (deg):  -0.264850
%             Planetocentric Latitude  (deg):  0.004180
%
%               Illumination angles derived using a
%               plate model surface:
%                   Phase angle              (deg): 101.596926
%                   Solar incidence angle    (deg): 98.376877
%                   Emission angle           (deg): 9.812985
%
%               Illumination angles derived using an
%               ellipsoidal surface:
%                   Phase angle              (deg): 101.596926
%                   Solar incidence angle    (deg): 101.593324
%                   Emission angle           (deg): 0.003834
%
%           Sub-solar point on plate model surface:
%             Planetocentric Longitude (deg):  105.857346
%             Planetocentric Latitude  (deg):  -16.270558
%
%               Illumination angles derived using a
%               plate model surface:
%                   Phase angle              (deg): 101.663675
%                   Solar incidence angle    (deg): 16.476730
%                   Emission angle           (deg): 118.124981
%
%               Illumination angles derived using an
%               ellipsoidal surface:
%                   Phase angle              (deg): 101.663675
%                   Solar incidence angle    (deg): 0.422781
%                   Emission angle           (deg): 101.541470
%
%            ...
%
%-Particulars
%
%   The term "illumination angles" refers to following set of
%   angles:
%
%
%      solar incidence angle    Angle between the surface normal at the
%                               specified surface point and the vector
%                               from the surface point to the Sun.
%
%      emission angle           Angle between the surface normal at the
%                               specified surface point and the vector
%                               from the surface point to the observer.
%
%      phase angle              Angle between the vectors from the
%                               surface point to the observing body and
%                               from the surface point to the Sun.
%
%
%   The diagram below illustrates the geometric relationships defining
%   these angles. The labels for the solar incidence, emission, and
%   phase angles are "s.i.", "e.", and "phase".
%
%
%                                                    *
%                                                   Sun
%
%                  surface normal vector
%                            ._                 _.
%                            |\                 /|  Sun vector
%                              \    phase      /
%                               \   .    .    /
%                               .            .
%                                 \   ___   /
%                            .     \/     \/
%                                  _\ s.i./
%                           .    /   \   /
%                           .   |  e. \ /
%       *             <--------------- *  surface point on
%    viewing            vector            target body
%    location           to viewing
%    (observer)         location
%
%
%   Note that if the target-observer vector, the target normal vector
%   at the surface point, and the target-sun vector are coplanar, then
%   phase is the sum of incidence and emission. This is rarely true;
%   usually
%
%      phase angle  <  solar incidence angle + emission angle
%
%
%   All of the above angles can be computed using light time
%   corrections, light time and stellar aberration corrections, or
%   no aberration corrections. The way aberration corrections
%   are used is described below.
%
%   Care must be used in computing light time corrections. The
%   guiding principle used here is "describe what appears in
%   an image."  We ignore differential light time; the light times
%   from all points on the target to the observer are presumed to be
%   equal.
%
%
%      Observer-target body vector
%      ---------------------------
%
%      Let `et' be the epoch at which an observation or remote
%      sensing measurement is made, and let et - lt ("lt" stands
%      for "light time") be the epoch at which the photons received
%      at `et' were emitted from the body (we use the term "emitted"
%      loosely here).
%
%      The correct observer-target vector points from the observer's
%      location at `et' to the target body's location at et - lt.
%      The target-observer vector points in the opposite direction.
%
%      Since light time corrections are not symmetric, the correct
%      target-observer vector CANNOT be found by computing the light
%      time corrected position of the observer as seen from the
%      target body.
%
%
%      Target body's orientation
%      -------------------------
%
%      Using the definitions of `et' and `lt' above, the target
%      body's orientation at et - lt is used. The surface
%      normal is dependent on the target body's orientation, so
%      the body's orientation model must be evaluated for the correct
%      epoch.
%
%
%      Target body -- Sun vector
%      -------------------------
%
%      All surface features on the target body will appear in a
%      measurement made at `et' as they were at the target at epoch
%      et-lt. In particular, lighting on the target body is dependent
%      on the apparent location of the Sun as seen from the target body
%      at et-lt. So, a second light time correction is used in finding
%      the apparent location of the Sun.
%
%
%   Stellar aberration corrections, when used, are applied as follows:
%
%
%      Observer-target body vector
%      ---------------------------
%
%      In addition to light time correction, stellar aberration is
%      used in computing the apparent target body position as seen
%      from the observer's location at time `et'. This apparent
%      position defines the observer-target body vector.
%
%
%      Target body-Sun vector
%      ----------------------
%
%      The target body-Sun vector is the apparent position of the Sun,
%      corrected for light time and stellar aberration, as seen from
%      the target body at time et-lt. Note that the target body's
%      position is not affected by the stellar aberration correction
%      applied in finding its apparent position as seen by the
%      observer.
%
%
%   Once all of the vectors, as well as the target body's
%   orientation, have been computed with the proper aberration
%   corrections, the element of time is eliminated from the
%   computation. The problem becomes a purely geometric one,
%   and is described by the diagram above.
%
%-Required Reading
%
%   For important details concerning this module's function, please refer to
%   the CSPICE routine illum_pl02.
%
%   MICE.REQ
%   ABCORR.REQ
%   DSK.REQ
%   PCK.REQ
%   SPK.REQ
%   TIME.REQ
%
%-Version
%
%   -Mice Version 1.0.0, 25-JUL-2016, NJB (JPL), EDW (JPL)
%
%-Index_Entries
%
%   illumination angles using dsk triangular plate_model
%   lighting angles using dsk triangular plate_model
%   illumination angles using dsk type_2 plate_model
%   lighting angles using dsk type_2 plate_model
%   phase angle using dsk triangular plate_model
%   emission angle using dsk triangular plate_model
%   solar incidence angle using dsk triangular plate_model
%   phase angle using dsk type_2 plate_model
%   emission angle using dsk type_2 plate_model
%   solar incidence angle using dsk type_2 plate_model
%
%-&

function [phase, solar, emissn] = cspice_illum_pl02( handle, dladsc, ...
                                                     target, et,     ...
                                                     abcorr, obsrvr, ...
                                                     spoint            )

   switch nargin
      case 7

         handle = zzmice_int( handle );
         dladsc = zzmice_int( dladsc );
         target = zzmice_str( target );
         et     = zzmice_dp( et );
         abcorr = zzmice_str( abcorr );
         obsrvr = zzmice_str( obsrvr );
         spoint = zzmice_dp( spoint );

      otherwise

         error ( [ 'Usage: [phase, solar, emissn] = '               ...
            'cspice_illum_pl02( handle, dladsc(SPICE_DLA_DSCSIZ), ' ...
                  '`target`, et, `abcorr`, `obsrvr`, spoint(3) )' ] )

   end

   %
   % Call the MEX library.
   %
   try

      [phase, solar, emissn] = mice( 'illum_pl02', ...
                                     handle, dladsc, target, ...
                                     et,     abcorr, obsrvr, spoint);
   catch
      rethrow(lasterror)
   end


