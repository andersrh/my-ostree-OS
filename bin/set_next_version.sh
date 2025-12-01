#!/bin/bash
# -----------------------------------------------------------
# Script til beregning af AlmaLinux's næste minor version
# og lagring af værdien som en DNF variabel.
# -----------------------------------------------------------

VAR_FILE="/etc/dnf/vars/epel_next_releasever"
VERSION_FILE="/etc/os-release"

# 1. Hent den fulde version (f.eks. "10.1")
# Vi bruger VERSION_ID fra /etc/os-release, da den er standardiseret.
if [ ! -f "$VERSION_FILE" ]; then
    echo "Fejl: OS-versionsfil ($VERSION_FILE) ikke fundet." >&2
    exit 1
fi

# Henter strengen (f.eks. 10.1)
FULL_VERSION=$(grep '^VERSION_ID=' "$VERSION_FILE" | cut -d'"' -f2)

if [[ ! "$FULL_VERSION" =~ ^[0-9]+\.[0-9]+$ ]]; then
    echo "Fejl: Ugyldig versionsformat fundet i $VERSION_FILE: $FULL_VERSION" >&2
    exit 1
fi

# 2. Opdel i Major (10) og Minor (1)
MAJOR_VERSION=$(echo "$FULL_VERSION" | cut -d. -f1)
CURRENT_MINOR=$(echo "$FULL_VERSION" | cut -d. -f2)

# 3. Udfør aritmetik: Minor + 1
NEXT_MINOR=$((CURRENT_MINOR + 1))

# 4. Sammensæt den næste version streng (f.eks. 10.2)
NEXT_VERSION="${MAJOR_VERSION}.${NEXT_MINOR}"

# 5. Opret DNF vars mappen, hvis den ikke findes
mkdir -p /etc/dnf/vars

# 6. Skriv den beregnede værdi til DNF variabelfilen
echo "$NEXT_VERSION" | tee "$VAR_FILE"

# Output til log (nyttigt i en Dockerfil)
echo "---------------------------------------------------------"
echo "Nuværende AlmaLinux version: $FULL_VERSION"
echo "Næste version beregnet: $NEXT_VERSION"
echo "Værdien '$NEXT_VERSION' er gemt i $VAR_FILE."
echo "---------------------------------------------------------"

exit 0
