# docker-build/Rstudio/Dockerfile
FROM rocker/rstudio:3.5.1 as builder

RUN sudo apt-get update -y && sudo apt-get upgrade -y \
    && sudo apt-get install -y make build-essential libssl-dev zlib1g-dev \
    && sudo apt-get install -y libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
    && sudo apt-get install -y libncurses5-dev  libncursesw5-dev xz-utils tk-dev \
    && sudo apt-get install -y vim nano ssh net-tools openssh-client \
    && apt-get clean 

# -------------------------------------------------------
FROM builder as custom-image

# Copy the R script with the pacman installs
COPY ["./pacmanInstall.R", "./"]

# Add a default CRAN mirror
RUN echo 'options(repos = c(CRAN = "https://cran.rstudio.com/"), download.file.method = "libcurl")' >> /etc/R/Rprofile.site \
    # Install pacman for pkg management
    && R -e "install.packages('pacman')" \
    && echo 'if (!require("pacman")) install.packages("pacman")' >> /etc/R/Rprofile.site \
    # Install required R packages via pacman
    && Rscript ./pacmanInstall.R \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
    && rm -rf /var/lib/apt/lists/* \
    && export ADD=shiny \
    && bash /etc/cont-init.d/add