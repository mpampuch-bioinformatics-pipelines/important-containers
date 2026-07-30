FROM condaforge/miniforge3:26.3.2-3

SHELL ["/bin/bash", "-c"]

# ----------------------------------------------------------------------
# Remove any inherited conda activation state
# ----------------------------------------------------------------------
RUN unset CONDA_PREFIX \
          CONDA_SHLVL \
          CONDA_DEFAULT_ENV \
          _CE_CONDA \
          _CE_M 

ENV CONDA_EXE=/opt/conda/bin/conda
ENV PATH=/opt/conda/bin:$PATH

# ----------------------------------------------------------------------
# Install build dependencies
# ----------------------------------------------------------------------
RUN source /opt/conda/etc/profile.d/conda.sh && \
    conda install -y -n base -c conda-forge \
        git \
        compilers \
        binutils \
        make \
        cmake \
        pkg-config && \
    conda clean -afy

# ----------------------------------------------------------------------
# Build kmer-ord
# ----------------------------------------------------------------------
WORKDIR /tmp

RUN git clone https://github.com/FDBoever/kmer-ord.git

WORKDIR /tmp/kmer-ord


### NOTE: HERE HAD TO DOWNGRADE MATPLOTLIB MANUALLY BECAUSE WITHOUT IT THE BIN WEB APP ON KMER-ORD COMMIT aa22b130903e8f6aa71c881b22c4b18b2efd2486 SEEMS TO BE BROKEN
RUN source /opt/conda/etc/profile.d/conda.sh && \
    conda env update -n base -f environment.yml && \
    pip uninstall -y matplotlib && \
    pip install --no-cache-dir "matplotlib==3.8.4"

# ----------------------------------------------------------------------
# Rust toolchain configuration
# ----------------------------------------------------------------------
ENV CC=x86_64-conda-linux-gnu-cc
ENV CXX=x86_64-conda-linux-gnu-c++
ENV AR=x86_64-conda-linux-gnu-ar

ENV RUSTFLAGS="-C linker=x86_64-conda-linux-gnu-cc -C link-arg=-fuse-ld=bfd"
ENV CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_LINKER=x86_64-conda-linux-gnu-cc
ENV CARGO_NET_GIT_FETCH_WITH_CLI=true
ENV RUST_BACKTRACE=1

# ----------------------------------------------------------------------
# Install package
# ----------------------------------------------------------------------
RUN source /opt/conda/etc/profile.d/conda.sh && \
    pip install . && \
    kmer-ord setup && \
    conda env export --name base --no-builds > /environment.lock && \
    conda clean -afy

# ----------------------------------------------------------------------
# Patch Broken Webserver Code
# ----------------------------------------------------------------------

RUN sed -n '1765,1780p' /opt/conda/lib/python3.11/site-packages/kmer_ord/dash/b2w.py
RUN cp /opt/conda/lib/python3.11/site-packages/kmer_ord/dash/b2w.py /opt/conda/lib/python3.11/site-packages/kmer_ord/dash/b2w.py.bak
RUN sed -i 's/cm\.get_cmap(/plt.get_cmap(/g' /opt/conda/lib/python3.11/site-packages/kmer_ord/dash/b2w.py

# ----------------------------------------------------------------------
# Cleanup
# ----------------------------------------------------------------------
RUN rm -rf /tmp/kmer-ord

# ----------------------------------------------------------------------
# Runtime environment
# ----------------------------------------------------------------------
ENV MAMBA_ROOT_PREFIX=/opt/conda
ENV PATH=/opt/conda/bin:$PATH

ENV CC=x86_64-conda-linux-gnu-cc
ENV CXX=x86_64-conda-linux-gnu-c++

ENV RUSTFLAGS="-C link-arg=-fuse-ld=bfd"
ENV CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_LINKER=x86_64-conda-linux-gnu-cc

# ----------------------------------------------------------------------
# Test during build
# ----------------------------------------------------------------------
RUN kmer-ord --help

ENTRYPOINT ["kmer-ord"]
CMD ["--help"]%                                                                       
