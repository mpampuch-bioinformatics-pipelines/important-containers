On your laptop, connect with the port forwarded:

```bash
ssh -L 8050:127.0.0.1:8050 pampum@ilogin.ibex.kaust.edu.sa
```

In that same session, start the app on the login node. Keep this SSH session open; a second ssh to ilogin can land on a different login node, and the tunnel would miss the server.

```bash
mamba activate apptainer

# Kill any existing running processes that might be using the port
lsof -i :8050
# Kill the PID

# Go to directory with all your kmer-ord sqlite databases
apptainer shell --bind=$PWD /ibex/project/c2303/20260614_make-kmer-ord-singularity-container/kmer-ord.linux.amd64.potentiallyWorking.needsTesting.20261029.RAM-efficient-fork.v14.sif

# Run the binning tool
kmer-ord bin \
  --output "$PWD/bins" \
  --host 127.0.0.1 \
  --port 8050 \
  --db kmerord.sqlite
```

Then open http://127.0.0.1:8050 locally. Exported bins are written to the --output directory next to the database. --bind /ibex makes scratch and project visible inside the container, and the database directory stays writable so SQLite can create its journal files.