#!/bin/bash
#
# Author:      Christian Herzig, cherzig@gauselmann.de
#
# Description: This script basically calls xmllint to check xml files to be
#              well-formed.
#
# Dependency:  xmllint, shellcheck
#                sudo apt-get update
#                sudo apt-get install libxml2-utils

VERSION="1.0.0"
PROG="xmllint"
BUILDDIR="build"
LOGFILE="${BUILDDIR}/xmllint.log"
SC_LOGFILE="${BUILDDIR}/shellcheck.log"

declare -a ERRSTR=("No error" \
    "Unclassified" \
    "Error in DTD" \
    "Validation error" \
    "Validation error" \
    "Error in schema compilation" \
    "Error writing output" \
    "Error in pattern (generated when --pattern option is used)" \
    "Error in Reader registration (generated when --chkregister option is used)" \
    "Out of memory error")

declare -a XML_FILES

# SC2044 conform way to put any xml files in an array":
while IFS= read -r -d '' file
do
  XML_FILES+=("$file")
done <   <(find . -name '*.xml' -print0)

echo ""
echo "Starting $0, Version ${VERSION}"
echo "----------------------------------------"

# check system
$PROG --version &> /dev/null
declare -i RET=$?

if [ $RET -ne 0 ]; then
  echo "Error: Jenkins server requires $PROG:"
  echo "  sudo apt-get update"
  echo "  sudo apt-get install libxml2-utils"
  exit 1
fi

mkdir -p $BUILDDIR

# start testing
shellcheck "$0" &> $SC_LOGFILE
RET=$?
if [ $RET -ne 0 ]; then
  echo "$0 has shellcheck issues:"
  cat $SC_LOGFILE
  exit $RET
else
  echo "shellcheck $0: ($RET) ${ERRSTR[${RET}]}"
fi

for XML_FILE in "${XML_FILES[@]}"; do
  "$PROG" "$XML_FILE" &> $LOGFILE
  RET=$?
  echo "$PROG $XML_FILE: ($RET) ${ERRSTR[${RET}]}"

  if [ $RET -ne 0 ]; then
    cat $LOGFILE
    exit $RET
  fi
done

echo ""
exit $RET
