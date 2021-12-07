# UMCCR Conda Recipes

- [UMCCR Conda Recipes](#umccr-conda-recipes)
  - [Setup](#setup)
    - [MacOS](#macos)
    - [Docker](#docker)
  - [Recipe Generation](#recipe-generation)
  - [Package build](#package-build)
  - [Upload](#upload)
  - [Cleanup](#cleanup)
  - [Notes](#notes)

Recipes for tools that can't quite make it to bioconda/conda-forge, for one reason or another.

## Setup

### MacOS

- If you want to generate a MacOS conda build:

```bash
mamba create -n cbuild conda-build anaconda-client conda-verify boa \
  -c conda-forge \
  -c defaults
```

### Docker

- If you want to generate a Linux conda build with Docker
  (and don't want to mess with cloud EC2 instances or HPC):

```bash
# this has all the build tools already installed
docker run --rm -it -v $(PWD):/home/umccr/recipes quay.io/condaforge/linux-anvil-comp7:latest
```

## Recipe Generation

- If you don't have a recipe ready, you can use `conda skeleton`. Read up on tips at:
  - <https://bioconda.github.io/contributor/guidelines.html>
  - <https://docs.conda.io/projects/conda-build/en/latest/user-guide/tutorials/build-pkgs-skeleton.html>
- For GitHub-hosted R packages, for example, you'd use the following:

```bash
conda skeleton cran https://github.com/umccr/gpgr
```

- The above generates a folder (`r-gpgr`) with three files: `meta.yaml`, `build.sh`, and `bld.bat` (just delete the last one since it's for Windows)
- It automatically pulls the latest tag. You can specify a different tag on the command line with `--git-tag`.

## Package build

- `boa` (<https://github.com/mamba-org/boa>) is a very fast conda package builder that is the
  preferred tool for building packages. Use the following syntax to use it as an alternative to `conda-build`:

```bash
conda mambabuild r-gpgr \
  --R 4.1 \
  -c conda-forge -c defaults
```

## Upload

- Depending on where you want to upload the built conda package, you need the specific anaconda channel's token.
  Assuming you have an account on <https://anaconda.org/>, you grab this by going to the particular channel of
  interest, clicking on your username -> Settings -> Access, then the pre-generated token should be all the way down
  - if you want to generate a new token, just select at least both of the 'Allow read/write access to the API site' options.
- The token is then used in the following command:

```bash
anaconda -t <token> upload /path/to/miniconda/envs/cbuild/conda-bld/linux-64/r-gpgr-0.0.1-r41_0.tar.bz2
```

## Cleanup

- Handy commands for cleaning up after yourself:

```bash
conda build purge
conda clean --all
```


## Notes

- `r-nnlm` needs to be built on Linux else it outputs an error when running pkgdown on GitHub Actions:

```
shared object 'NNLM.so' not found
```
