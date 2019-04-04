# Singularity already sets up the login environment
if ( x"${SINGULARITY_CONTAINER}" == "x" ) then 

    # Use the lal-data bundled in the image if not set
    if ( "x${LAL_DATA_PATH}" == "x" ) then
        setenv LAL_DATA_PATH /cvmfs/oasis.opensciencegrid.org/ligo/sw/pycbc/lalsuite-extra/e02dab8c/share/lalsimulation
    endif


    # Add path to Intel MKL Libraries
    if ( "x${LD_LIBRARY_PATH}" == "x" ) then
        setenv LD_LIBRARY_PATH /opt/intel/composer_xe_2015.0.090/mkl/lib/intel64
    else
        setenv LD_LIBRARY_PATH /opt/intel/composer_xe_2015.0.090/mkl/lib/intel64:${LD_LIBRARY_PATH}
    endif
endif
