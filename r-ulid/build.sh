#!/bin/bash

export DISABLE_AUTOBREW=1
export SHLIB_LIBADD="${SHLIB_LIBADD:-}"

# shellcheck disable=SC2086
${R} CMD INSTALL --build . ${R_ARGS}
