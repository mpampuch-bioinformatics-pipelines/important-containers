# README

Made from v1 docker container

## NOTE

Working, but in order to get it to work, I had to run it as follows

1. Bind a writeable directory

```bash
mkdir work

apptainer shell \
    --bind $PWD/work:/work \
    oras://docker.io/mpampuch/kemet_128b584_linux-amd64_singularity:baaab2c9811796da
```

2. Then inside I ran this:

```bash
cp -a /opt/KEMET /work/
```

### This may mean that for any Nextflow module that uses this container, I might need to include `cp -a /opt/KEMET /work/` at the top of the module script 

I tested if the container works with this script

```bash
#!/usr/bin/env bash
set -e

echo "========================================"
echo "KEMET / CarveMe FULL INSTALL TEST"
echo "========================================"

BASE_DIR=$(pwd)

echo
echo "## Step 1: Extract test datasets (if needed)"
cd tests 2>/dev/null || { echo "tests/ directory not found"; exit 1; }

if [ -f test_MAG_results.tar.gz ]; then
    echo "Extracting MAG test dataset..."
    tar -xf test_MAG_results.tar.gz
else
    echo "MAG tar.gz already extracted or missing"
fi

if [ -f test_complete_genomes_results.tar.gz ]; then
    echo "Extracting complete genome test dataset..."
    tar -xf test_complete_genomes_results.tar.gz
else
    echo "Complete genome tar.gz already extracted or missing"
fi

cd "$BASE_DIR"

echo
echo "## Step 2: Executables check"
for exe in python mafft hmmsearch hmmbuild diamond prodigal carve merge_community; do
    printf "%-18s" "$exe"
    command -v "$exe" || echo "NOT FOUND"
done

echo
echo "## Step 3: Versions"

python --version
mafft --version | head -n 1
hmmsearch -h | head -n 2
hmmbuild -h | head -n 2
diamond version
prodigal -v

echo
echo "## Step 4: Python packages"

python <<'EOF'
import importlib

mods = ["carveme", "reframed", "pandas"]

for m in mods:
    try:
        mod = importlib.import_module(m)
        print(f"{m}: OK ({getattr(mod,'__version__','no version')})")
    except Exception as e:
        print(f"{m}: FAILED -> {e}")
EOF

echo
echo "## Step 5: Solver availability"

python <<'EOF'
import importlib

solvers = []
for pkg in ["swiglpk","optlang","cplex","gurobipy"]:
    try:
        importlib.import_module(pkg)
        solvers.append(pkg)
    except Exception:
        pass

print("Detected solvers:", solvers if solvers else "NONE")
EOF

echo
echo "## Step 6: Functional CarveMe test"

FAA="tests/complete_genome_base_results/prodigal/NC_000913.3.faa"

if [ ! -f "$FAA" ]; then
    echo "ERROR: FAA file not found:"
    echo "$FAA"
    exit 1
fi

rm -f install_test.xml

set +e
carve "$FAA" -o install_test.xml
STATUS=$?
set -e

echo
echo "========================================"

if [ $STATUS -eq 0 ] && [ -f install_test.xml ]; then
    echo "SUCCESS: CarveMe ran successfully"
    echo "Model file generated: install_test.xml"
else
    echo "PARTIAL SUCCESS / FAILURE"
    echo "CarveMe executed but model reconstruction failed"
    echo "Most likely cause: missing MILP solver (GLPK/Gurobi/CPLEX)"
fi

echo "========================================"
```