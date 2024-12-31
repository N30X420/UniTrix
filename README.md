# UniTrix

UniTrix is a PowerShell script designed to manage Ubiquiti UniFi Controller services, update certificates, and interact with MongoDB for device management.

## Features

- Install, uninstall, start, stop, and restart UniFi services
- Update UniFi Controller
- Update SSL certificates
- Check and install Java
- Check and install MongoDB Shell
- Connect to MongoDB
- Search and delete devices in MongoDB

## Debug Features

The script now includes enhanced debug information to help troubleshoot issues. Debug messages are displayed in the console and logged in the transcript file.

## Usage

1. **Download the latest UniTrix.exe release:**
    ```sh
    https://github.com/N30X420/UniTrix/releases
    ```
2. **Run UniTrix.exe from desktop**

3. **Follow the on-screen instructions to navigate through the menu and perform desired actions.**

## Configuration

The script uses a configuration file (`UniTrix.cfg`) to set various parameters. If the configuration file is not found, it will be created automatically with default values. You can edit this file to customize the settings.

### Configuration Parameters

- `FQDN`: Fully Qualified Domain Name for the certificate
- `CertPath`: Custom path for the SSL certificate
- `UnifiRootDir`: Custom root directory for UniFi installation
- `JavaRootPath`: Custom path for Java installation
- `MongoDBShellPath`: Path to MongoDB Shell

## Logging

The script logs all actions and debug information to a log file located in the `C:\MATRIXNET\UniTrix-<version>` directory. The log file is named with the format `UniTrix-<version>-<date>.log`.

## Troubleshooting

If you encounter any issues, check the log file for detailed debug information. The log file is located in the `C:\MATRIXNET\UniTrix-<version>` directory specified in the script.