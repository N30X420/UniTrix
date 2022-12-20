# UniTrix
-------------------------------------------------
Unifi Controller Management Script - By Vincent | MATRIXNET
-------------------------------------------------
This is an automated script to manage your Ubiquiti Unifi Network Controller for Windows

## Features
There are a few features already present and more will be added in the future

1. Install Service - Installs the Unifi Network Controller as a service in Windows
2. Uninstall Service - Removes the installed Unifi Network Controller service from Windows
3. Start Service - Starts the Unifi Network Controller Service in Windows
4. Stop Service - Stops the Unifi Network Controller Service in Windows
5. Restart Service - Restarts the Unifi Network Controller Service in Windows
6. Update Controller - Updates the Unifi Network Controller to the latest version (Currently not working)
7. Update Certificate - Updates the SSL Certificate used by the Unifi Network Controller (See notes below!)
8. Exit - Closes UniTrix

## How to use ?
1. Make sure you have all the dependencies installed on your system. For a list please see the notes section below.
2. Run the binary UniTrix.exe
3. A config file (UniTrix.cfg) will be created. In this file you need to specify the fqdn of your controller certificate.
4. Run the binary UniTrix.exe again
5. Then use the arrow keys and enter to navigate the menu.


## Notes
### Dependencies
- CertifyTheWeb (Script checks for certificates in C:\ProgramData\Certify\Assets\)
- Eclipse Adoptium - JDK-11.x (For keytool & Unifi relies on Java 11)

## To Do
- Implement a way to check if required dependencies are installed


## Debugging
Logs are saved in C:\INSTALL\UniTrix-2.0\UniTrix-2.0-xx-xx-xxxx_xx-xx-xx.log