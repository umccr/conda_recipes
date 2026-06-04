#!/bin/bash

export DISABLE_AUTOBREW=1

# cross-r-base leaves SHLIB_LIBADD undefined; define it in user Makevars so
# R's install code doesn't get a length-zero vector from nzchar()
mkdir -p "${HOME}/.R"
echo "SHLIB_LIBADD = " >> "${HOME}/.R/Makevars"

# shellcheck disable=SC2086
${R} CMD INSTALL --build . ${R_ARGS}
