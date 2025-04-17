FROM ubuntu:24.04

# Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Set ESP-IDF version - using v5.1.1 which has good ESP32-S3 support
ENV ESP_IDF_VERSION=v5.3.1
ENV ESP_IDF_TOOLS_PATH=/opt/esp/tools
ENV IDF_PATH=/opt/esp/esp-idf
ENV IDF_TOOLS_PATH=${ESP_IDF_TOOLS_PATH}

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    wget \
    flex \
    bison \
    gperf \
    python3 \
    python3-pip \
    python3-venv \
    python3-setuptools \
    cmake \
    ninja-build \
    ccache \
    libffi-dev \
    libssl-dev \
    dfu-util \
    libusb-1.0-0 \
    nano \
    vim \
    usbutils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create ESP directory
RUN mkdir -p /opt/esp

# Clone ESP-IDF repository
RUN cd /opt/esp && \
    git clone --recursive https://github.com/espressif/esp-idf.git -b ${ESP_IDF_VERSION}

# Install ESP-IDF tools specifically for ESP32-S3
RUN cd ${IDF_PATH} && \
    ./install.sh esp32s3

# Add ESP32-S3 specific toolchain to PATH
ENV PATH=${ESP_IDF_TOOLS_PATH}/tools/xtensa-esp32s3-elf/esp-12.2.0_20230208/xtensa-esp32s3-elf/bin:${IDF_PATH}/tools:${PATH}

# Set up shell environment
RUN echo ". ${IDF_PATH}/export.sh" >> ~/.bashrc

# Set default target to ESP32-S3
RUN echo "export IDF_TARGET=esp32s3" >> ~/.bashrc

# Create a workspace directory
RUN mkdir -p /workspace
WORKDIR /workspace

# Set entrypoint to source ESP-IDF environment and set target
ENTRYPOINT ["/bin/bash", "-c", "source ${IDF_PATH}/export.sh && export IDF_TARGET=esp32s3 && exec \"$@\"", "--"]

# Default command
CMD ["/bin/bash"]
