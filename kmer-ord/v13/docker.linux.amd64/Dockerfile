# v12 binner image. linux/amd64 only: the toolchain below is the x86_64 conda
# compiler, matching kmer-ord.20261028.RAM-efficient-fork.v12.def.
FROM condaforge/miniforge3:26.3.2-3

SHELL ["/bin/bash", "-c"]

ENV CONDA_EXE=/opt/conda/bin/conda \
    MAMBA_ROOT_PREFIX=/opt/conda \
    PATH=/opt/conda/bin:$PATH

RUN <<'EOF'
set -eux

# Drop host conda state inherited from the build environment.
unset CONDA_PREFIX
unset CONDA_SHLVL
unset CONDA_DEFAULT_ENV
unset _CE_CONDA
unset _CE_M
unset CONDA_EXE

export CONDA_EXE=/opt/conda/bin/conda
export PATH=/opt/conda/bin:$PATH
. /opt/conda/etc/profile.d/conda.sh

conda install -y -n base \
    -c conda-forge \
    -c bioconda \
    git \
    compilers \
    binutils \
    make \
    cmake \
    pkg-config \
    seqkit \
    > /tmp/buildtools.log 2>&1 || (cat /tmp/buildtools.log >&2 && exit 1)

# Checkout already contains the binner NA labels. Patch rDNA-miner before
# `pip install .` because that install is not editable.
WORKDIR=$(mktemp -d)
cd "$WORKDIR"
git clone https://github.com/mpampuch/kmer-ord
cd kmer-ord
git checkout 7ec912c47a23256dcd948843e9c1e8573b0ff565

python - <<'PY'
from pathlib import Path

path = Path("src/kmer_ord/system/env_manager.py")
text = path.read_text()
repo_old = 'RDNA_REPO = "https://github.com/FDBoever/rDNA-miner"'
repo_new = 'RDNA_REPO = "https://github.com/mpampuch/rDNA-miner"'
clone_old = """\
    subprocess.run(
        ["git", "clone", "--depth", "1", RDNA_REPO, str(tmp_dir)],
        check=True
    )"""
clone_new = """\
    subprocess.run(
        ["git", "clone", "--branch", "silva_pr2_incorporation", RDNA_REPO, str(tmp_dir)],
        check=True
    )
    subprocess.run(
        ["git", "checkout", "d44de20810f34cda88e333c7990a1cade306e754"],
        cwd=str(tmp_dir),
        check=True
    )"""
if repo_old not in text:
    raise SystemExit("RDNA_REPO line not found in env_manager.py")
if clone_old not in text:
    raise SystemExit("rDNA-miner clone call not found in env_manager.py")
path.write_text(text.replace(repo_old, repo_new, 1).replace(clone_old, clone_new, 1))
PY
grep -n 'mpampuch/rDNA-miner' src/kmer_ord/system/env_manager.py
grep -n 'silva_pr2_incorporation' src/kmer_ord/system/env_manager.py
grep -n 'd44de20810f34cda88e333c7990a1cade306e754' src/kmer_ord/system/env_manager.py

conda env update -n base -f environment.yml \
    > /tmp/conda_env.log 2>&1 || (cat /tmp/conda_env.log >&2 && exit 1)

# Stable GNU toolchain for the Rust native extension. These names exist only
# in the amd64 conda compilers package.
export CC=x86_64-conda-linux-gnu-cc
export CXX=x86_64-conda-linux-gnu-c++
export AR=x86_64-conda-linux-gnu-ar
export RUSTFLAGS="-C linker=x86_64-conda-linux-gnu-cc -C link-arg=-fuse-ld=bfd"
export CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_LINKER=x86_64-conda-linux-gnu-cc
export CARGO_NET_GIT_FETCH_WITH_CLI=true
export RUST_BACKTRACE=1

pip install .
kmer-ord setup

conda env export --name base --no-builds > /environment.lock
conda clean -a -y
rm -rf "$WORKDIR"
EOF

# Runtime linker settings from the definition's %environment section.
ENV CC=x86_64-conda-linux-gnu-cc \
    CXX=x86_64-conda-linux-gnu-c++ \
    RUSTFLAGS="-C link-arg=-fuse-ld=bfd" \
    CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_LINKER=x86_64-conda-linux-gnu-cc

ENTRYPOINT ["kmer-ord"]
CMD ["--help"]
