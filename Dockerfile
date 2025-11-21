# ap-course-env/Dockerfile
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Basic dev tools for C
RUN apt-get update && \
    apt-get install -y \
        build-essential \
        gdb \
        make \
        cmake \
        clang \
        clang-format \
        valgrind \
        git \
        vim \
        neovim \
        nano \
        btop \
        sudo \
        python3 \
        python3-pip \
        # Documentation and man pages \
        man-db \
        manpages-dev \
        manpages-posix-dev \
        # Debugging and analysis tools \
        strace \
        ltrace \
        cppcheck \
        # Shell and text processing utilities \
        bash-completion \
        shellcheck \
        less \
        curl \
        wget \
        tree \
        bc \
        diffutils \
        patch \
        zip \
        unzip \
        # Additional build tools \
        autoconf \
        automake \
        libtool \
        pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user "student"
RUN useradd -ms /bin/bash student
USER student
WORKDIR /ap

# Nice prompt, optional
RUN echo 'export PS1="(ap-env) \u@\h:\w$ "' >> ~/.bashrc

CMD ["/bin/bash"]
