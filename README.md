# ESP32-S3 CI/CD with ESP-IDF and SPIFFS Demo

This repository demonstrates how to implement a Continuous Integration and Continuous Deployment (CI/CD) pipeline for ESP32-S3 projects using ESP-IDF, with a practical SPIFFS (SPI Flash File System) implementation example.

## Overview

This project showcases a modern development workflow for ESP32-S3 firmware development, featuring:

- Containerized development environment with Docker
- CI/CD pipeline setup
- ESP-IDF framework integration
- SPIFFS implementation for efficient file storage on the ESP32-S3
- Best practices for ESP32-S3 firmware development

## Repository Structure

```
.
├── .gitignore              # Git ignore file for ESP-IDF projects
├── Dockerfile              # Docker configuration for ESP32-S3 development
├── .github/workflows/      # CI/CD pipeline configurations
├── main/                   # Application source code
│   ├── spiffs_main.c       # SPIFFS demo implementation main file
│   ├── include/            # Header files
│   └── CMakeLists.txt      # Main component build configuration
├── pytest_spiffs.py        # Python for testing SPIFFS 
├── spiffs_data/            # Files to be included in SPIFFS partition
├── partitions.csv          # Custom partition table with SPIFFS partition
├── CMakeLists.txt          # Project build configuration
├── sdkconfig.defaults      # Default ESP-IDF configuration
└── README.md               # Project documentation
```

## Getting Started

### Prerequisites

- [Docker](https://www.docker.com/get-started) installed
- [Git](https://git-scm.com/downloads) installed
- ESP32-S3 development board

### Setting Up the Development Environment

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/esp32-s3-cicd.git
   cd esp32-s3-cicd
   ```

2. Build the Docker image:
   ```bash
   docker build -t esp32s3-dev .
   ```

3. Run the development container:
   ```bash
   docker run -it --rm \
     -v $(pwd):/workspace \
     --device=/dev/ttyUSB0 \
     esp32s3-dev
   ```
   
   **Note**: Replace `/dev/ttyUSB0` with your device path.

### Building Your Project

From within the Docker container:

```bash
idf.py build
```

This will compile the application and package the SPIFFS data files.

### Flashing to ESP32-S3

From within the Docker container:

```bash
idf.py -p /dev/ttyUSB0 flash
```

This command flashes both the application and the SPIFFS partition.

### Building and Flashing SPIFFS Only

If you only want to update the files in SPIFFS without reflashing the entire application:

```bash
idf.py -p /dev/ttyUSB0 spiffs-flash
```

### Monitoring

From within the Docker container:

```bash
idf.py -p /dev/ttyUSB0 monitor
```

Press `Ctrl+]` to exit the monitor.

### SPIFFS Demo Features

The SPIFFS example demonstrates:

1. Mounting the SPIFFS filesystem
2. Creating and writing to files
3. Reading file contents
4. Listing directory contents
5. Deleting files
6. File system statistics (free/used space)

## CI/CD Pipeline

This repository uses GitHub Actions for CI/CD. The pipeline:

1. Builds the project for ESP32-S3
2. Runs tests including SPIFFS functionality tests
3. Creates firmware artifacts (app binary and SPIFFS image)
4. (Optional) Deploys firmware to devices

Pipeline configurations are located in the `.github/workflows/` directory.

### SPIFFS Testing in CI

The CI pipeline includes automated tests for SPIFFS functionality:

1. Mounting SPIFFS and verifying it initializes correctly
2. Writing test files and validating their contents
3. Checking file operations (create, read, write, delete)
4. Validating filesystem integrity after operations
5. Stress testing with multiple file operations

## ESP-IDF Configuration

This project uses ESP-IDF v5.1.1, which provides comprehensive support for ESP32-S3.

Key ESP-IDF settings:
- Target: ESP32-S3
- Flash size: 8MB (configurable in `menuconfig`)
- PSRAM: Enabled (configurable in `menuconfig`)
- SPIFFS partition: 1MB (defined in `partitions.csv`)

### SPIFFS Configuration

The project includes a SPIFFS partition for file storage:

```
# Name,   Type, SubType, Offset,  Size, Flags
nvs,      data, nvs,     0x9000,  0x6000,
phy_init, data, phy,     0xf000,  0x1000,
factory,  app,  factory, 0x10000, 3M,
spiffs,   data, spiffs,  ,        1M,
```

SPIFFS is initialized in the application startup and provides:
- File read/write operations
- Directory support
- Wear leveling for flash memory protection

## Development Workflow

1. Create a feature branch from `main`
2. Make your changes and commit
3. Push your branch and create a pull request
4. CI will automatically build and test your changes
5. After review and approval, merge to `main`
6. CI will build the release version

## Troubleshooting

### USB Connection Issues

ESP32-S3 uses USB for both programming and serial communication. If you're having trouble:

1. Check if the board is in download mode
2. Try different USB ports
3. Verify USB permissions on Linux: `sudo usermod -a -G dialout $USER`

### Build Issues

If build fails:

1. Update ESP-IDF: `cd $IDF_PATH && git pull && ./install.sh esp32s3`
2. Clean build: `idf.py fullclean && idf.py build`

## Docker Build
### Build the Docker image
``` docker build -t esp32s3-dev . ```

### Run the container with your project mounted
``` docker run -it --rm  -v {path}/esp32s3_espidf_spiffs_deployment_demo:/workspace  esp32s3-dev ```



## SPIFFS Demo Implementation

The SPIFFS demo showcases how to:

1. Initialize and mount a SPIFFS filesystem
2. Handle file operations efficiently
3. Manage file data on the ESP32-S3's flash memory
4. Implement proper error handling for file operations
5. Package static files into the SPIFFS partition during build


## References

- [ESP-IDF Programming Guide](https://docs.espressif.com/projects/esp-idf/en/latest/esp32s3/index.html)
- [ESP-IDF SPIFFS Documentation](https://docs.espressif.com/projects/esp-idf/en/latest/esp32s3/api-reference/storage/spiffs.html)
- [ESP32-S3 Technical Reference Manual](https://www.espressif.com/sites/default/files/documentation/esp32-s3_technical_reference_manual_en.pdf)
- [Docker Documentation](https://docs.docker.com/)

## License

[MIT License](LICENSE)