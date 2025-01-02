#######################################
# Configurable Variables
#--------------------------------------
$version = "2.8.2"
$ProgramName = "UniTrix"
########################################
$DefaultUnifiRootDir = "$env:Userprofile\Ubiquiti UniFi"
$tempdir = "C:\MATRIXNET\$ProgramName-$version"
$JavaRootDir = "C:\Program Files\Eclipse Adoptium\" + (Get-ChildItem -ErrorAction SilentlyContinue "C:\Program Files\Eclipse Adoptium" | Sort-Object LastWriteTime | Select-Object -last 1).Name
#######################################
$error.clear()
$ProgressPreference = 'SilentlyContinue'
$host.UI.RawUI.WindowTitle = "$ProgramName - Version $version"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
#######################################

###################################
####
# Functions
#--------------------------------------
# Logo
function SplashLogo {
write-host ""
write-host "███╗   ███╗ █████╗ ████████╗██████╗ ██╗██╗  ██╗" -ForegroundColor White -NoNewline
Write-host "███╗   ██╗███████╗████████╗" -ForegroundColor Red
write-host "████╗ ████║██╔══██╗╚══██╔══╝██╔══██╗██║╚██╗██╔╝" -ForegroundColor white -NoNewline
Write-Host "████╗  ██║██╔════╝╚══██╔══╝" -ForegroundColor Red
write-host "██╔████╔██║███████║   ██║   ██████╔╝██║ ╚███╔╝ " -ForegroundColor White -NoNewline
Write-Host "██╔██╗ ██║█████╗     ██║   " -ForegroundColor Red
write-host "██║╚██╔╝██║██╔══██║   ██║   ██╔══██╗██║ ██╔██╗ " -ForegroundColor White -NoNewline
Write-Host "██║╚██╗██║██╔══╝     ██║   " -ForegroundColor Red
write-host "██║ ╚═╝ ██║██║  ██║   ██║   ██║  ██║██║██╔╝ ██╗" -ForegroundColor White -NoNewline
write-host "██║ ╚████║███████╗   ██║   " -ForegroundColor Red
write-host "╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝" -ForegroundColor White -NoNewline
write-host "╚═╝  ╚═══╝╚══════╝   ╚═╝   " -ForegroundColor Red                                         

}
function Logo {
    Write-Host " "
    Write-Host "     __  __     _ ______    _" -ForegroundColor Blue
    write-host "    / / / /__  (_)_  __/___(_)_ __" -ForegroundColor Blue
    Write-Host "   / /_/ / _ \/ / / / / __/ /\ \ /" -ForegroundColor Blue
    Write-Host "   \____/_//_/_/ /_/ /_/ /_//_\_\" -ForegroundColor Blue
    write-Host "v$version" -ForegroundColor Blue
}
function UI_INSTALL_SVC {
    Write-Host "`nINSTALL SERVICE" -ForegroundColor Blue
    try {
        Write-Host "`n* Installing Unifi Service" -ForegroundColor Yellow
        & $JavaRootDir\bin\java.exe -jar "$UnifiRootDir\lib\ace.jar" installsvc
        Write-Host "* Unifi Service Installed" -ForegroundColor Yellow
    }
    catch {
        Write-Host "`nUnable to install Unifi Service" -ForegroundColor Red
        Write-Host "Check logs for more information about the error" -ForegroundColor Yellow
        $error.Add($_)
        Write-Host $error -ForegroundColor Red
        Start-Sleep -Seconds 5
    }
}
function UI_UNINSTALL_SVC {
    Write-Host "`nUNINSTALL SERVICE" -ForegroundColor Blue
    try {
        Write-Host "`n* Stopping Unifi Service" -ForegroundColor Yellow
        & $JavaRootDir\bin\java.exe -jar "$UnifiRootDir\lib\ace.jar" stopsvc
        Write-Host "* Unifi Service Stopped" -ForegroundColor Yellow
        Start-Sleep -Seconds 2
        Write-Host "* Removing Unifi Service" -ForegroundColor Yellow
        & $JavaRootDir\bin\java.exe -jar "$UnifiRootDir\lib\ace.jar" uninstallsvc
        Write-Host "* Unifi Service Removed" -ForegroundColor Yellow
    }
    catch {
        Write-Host "`nUnable to uninstall Unifi Service" -ForegroundColor Red
        Write-Host "Check logs for more information about the error" -ForegroundColor Yellow
        $error.Add($_)
        Write-Host $error -ForegroundColor Red
        Start-Sleep -Seconds 5
    }
}
function UI_START_SVC {
    Write-Host "`nSTART SERVICE" -ForegroundColor Blue
    try {
        Write-Host "`n* Starting Unifi Service" -ForegroundColor Yellow
        & $JavaRootDir\bin\java.exe -jar "$UnifiRootDir\lib\ace.jar" startsvc
        Write-Host "* Unifi Service Started" -ForegroundColor Yellow
    }
    catch {
        Write-Host "`nUnable to start Unifi Service" -ForegroundColor Red
        Write-Host "Check logs for more information about the error" -ForegroundColor Yellow
        $error.Add($_)
        Write-Host $error -ForegroundColor Red
        Start-Sleep -Seconds 5
    }
}
function UI_STOP_SVC {
    Write-Host "`nSTOP SERVICE" -ForegroundColor Blue
    try {
        Write-Host "`n* Stopping Unifi Service" -ForegroundColor Yellow
        & $JavaRootDir\bin\java.exe -jar "$UnifiRootDir\lib\ace.jar" stopsvc
        Write-Host "* Unifi Service Stopped" -ForegroundColor Yellow
    }
    catch {
        Write-Host "`nUnable to stop Unifi Service" -ForegroundColor Red
        Write-Host "Check logs for more information about the error" -ForegroundColor Yellow
        $error.Add($_)
        Write-Host $error -ForegroundColor Red
        Start-Sleep -Seconds 5
    }
}
function UI_RESTART_SVC {
    Write-Host "`nRESTART SERVICE" -ForegroundColor Blue
    try {
        Write-Host "`n* Stopping Unifi Service" -ForegroundColor Yellow
        & $JavaRootDir\bin\java.exe -jar "$UnifiRootDir\lib\ace.jar" stopsvc
        Write-Host "* Unifi Service stopped" -ForegroundColor Yellow
        Start-Sleep -Seconds 5
        Write-Host "* Starting Unifi Service" -ForegroundColor Yellow
        & $JavaRootDir\bin\java.exe -jar "$UnifiRootDir\lib\ace.jar" startsvc
        Write-Host "* Unifi Service started" -ForegroundColor Yellow
    }
    catch {
        Write-Host "`nUnable to restart Unifi Service" -ForegroundColor Red
        Write-Host "Check logs for more information about the error" -ForegroundColor Yellow
        $error.Add($_)
        Write-Host $error -ForegroundColor Red
        Start-Sleep -Seconds 5
    }
}
function UI_SVC_STATUS {
    Write-Host "`nSERVICE STATUS" -ForegroundColor Blue
    try {
        get-service -name Unifi | Format-List
        start-sleep -Seconds 3
        Write-Host "Press a key to return to the menu" -ForegroundColor Yellow
        $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
    catch {
        Write-Host "`nUnable to get Unifi Service status" -ForegroundColor Red
        Write-Host "Check logs for more information about the error" -ForegroundColor Yellow
        $error.Add($_)
        Write-Host $error -ForegroundColor Red
        Start-Sleep -Seconds 5
    }
}
function UI_UPDATE_SVC {
    Write-Host "`nUPDATE SERVICE" -ForegroundColor Blue
    try {
        UI_UNINSTALL_SVC
        Write-Host "`nWould you like to manualy download the new controller version ? (Y/N)" -ForegroundColor Yellow -NoNewline
        $DownloadManual = $Host.UI.RawUI.ReadKey()
        if ($DownloadManual.Character -eq "N"){
            Write-Host "`nEnter Custom version number (Example: 7.3.76)" -ForegroundColor Yellow
            $CustomVersion = Read-Host "Custom Version"
            Write-Host "Downloading Unifi installer for version: $CustomVersion" -ForegroundColor Cyan
            Invoke-WebRequest -Uri "https://dl.ui.com/unifi/$CustomVersion/UniFi-installer.exe" -OutFile "$tempdir\Unifi-installer.exe"
            Write-Host "* Update downloaded" -ForegroundColor Yellow
            $UpdateDownloadType = 1
        }

        else {
            Write-Host "`nManually download latest installer from Ubiquiti Unifi" -ForegroundColor Yellow
            start-process "https://www.ui.com/download/unifi/"
            while ($null -eq $UpdateDownloaded) {
                Write-Host "`nUpdate downloaded ? (Y/N)" -ForegroundColor Yellow -NoNewline
                $UpdateDownloaded = $Host.UI.RawUI.ReadKey()
                if ($UpdateDownloaded.Character -eq "N") {
                    Write-Host "`nPlease download the latest Unifi Network Controller Software" -ForegroundColor Yellow
                    $UpdateDownloaded = $null
                }
                else {
                    Write-Host "`n* Starting Update" -ForegroundColor Yellow
                    $UpdateDownloaded = $true
                    $UpdateDownloadType = 2
                }
            }
        }


        if ($UpdateDownloadType -eq 1) {
            $UpdateFileLocation = "$tempdir\Unifi-installer.exe"
        }
        elseif ($UpdateDownloadType -eq 2) {
            $UpdateFileLocation = "$env:Userprofile\Downloads\Unifi-installer.exe"
        }
        else {
            Write-Host "Unexpected error" -ForegroundColor Red
            $error.Add("Unexpected error while update was preparing")
            $error.add($_)
            Write-Host $error -ForegroundColor Red
        }

        Start-Sleep -Seconds 2
        Write-Host "* Starting Unifi Controller Update" -ForegroundColor Yellow
        Start-Process -ErrorAction Stop -Wait "$UpdateFileLocation" /S
        Start-Sleep -Seconds 2
        Write-Host "* Update Completed" -ForegroundColor Yellow
        UI_INSTALL_SVC
        Start-Sleep -Seconds 2
        UI_START_SVC
        Write-Host "* Removing Update File" -ForegroundColor Yellow
        Remove-Item -Path $UpdateFileLocation -Force -Confirm:$false
        Write-Host "* Update File Removed" -ForegroundColor Yellow
        Start-Sleep -Seconds 2


    }
    catch {
        Write-Host "`nUnable to update Unifi Service" -ForegroundColor Red
        Write-Host "Check logs for more information about the error" -ForegroundColor Yellow
        $error.Add($_)
        Write-Host $error -ForegroundColor Red
        Start-Sleep -Seconds 5
    }
}
function UI_UPDATE_CERT {
    Write-Host "`nUPDATE CERTIFICATE" -ForegroundColor Blue
    try {
        UI_STOP_SVC
        Write-Host "* Unlocking Keystore" -ForegroundColor Yellow
        Set-ItemProperty -Path "$UnifiRootDir\Data\keystore" -Name IsReadOnly -Value $false
        Start-Sleep -Seconds 2
        Write-Host "* Replacing certificate" -ForegroundColor Yellow

        if ($CustomCert -eq $false) {
            $NewCert = Get-ChildItem $CertDir | Sort-Object LastWriteTime | Select-Object -last 1
            Write-Host "Using certificate: $NewCert" -ForegroundColor Cyan
            $Params = "-importkeystore -srckeystore ""$CertDir\$NewCert"" -srcstoretype pkcs12 -srcstorepass """" -destkeystore ""$env:Userprofile\Ubiquiti UniFi\data\newstore"" -deststoretype pkcs12 -deststorepass ""aircontrolenterprise"" -destkeypass ""aircontrolenterprise"""
            $Prms   = $Params.Split(" ")
            & $JavaRootDir\bin\keytool.exe $Prms
            
        }
        elseif ($CustomCert -eq $true) {
            Write-Host "`nIs the certificate password protected ? (Y/N) : " -ForegroundColor Yellow -NoNewline
            Start-Sleep -Milliseconds 500
            $RequireExportPass = Read-Host
            if ($RequireExportPass -eq "Y" -or "y") {
                Write-Host "`nEnter certificate password" -ForegroundColor Yellow
                $CertSPass = Read-Host "Password" -AsSecureString
                $CertPass =[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($CertSPass))
            }
            else {
                Write-Host "`nNo password" -ForegroundColor Yellow
                $CertPass = ""
            }
            $NewCert = Get-ChildItem $CertDir | Sort-Object LastWriteTime | Select-Object -last 1
            Write-Host "Using certificate: $NewCert" -ForegroundColor Cyan
            $Params = "-importkeystore -srckeystore ""$CertDir\$NewCert"" -srcstoretype pkcs12 -srcstorepass ""$CertPass"" -destkeystore ""$UnifiRootDir\data\newstore"" -deststoretype pkcs12 -deststorepass ""aircontrolenterprise"" -destkeypass ""aircontrolenterprise"""
            $Prms   = $Params.Split(" ")
            & $JavaRootDir\bin\keytool.exe $Prms
        }

        else {
            Write-Host "Unexpected error has occurred" -ForegroundColor Red
            $error.Add("Unexpected error has occurred - Certificate Path")
            Write-Host $error -ForegroundColor Red
        }

        Write-Host "Changing Alias to unifi" -ForegroundColor Yellow
        $srcAlias = &$JavaRootDir\bin\keytool.exe -v -list -storetype pkcs12 -keystore "$UnifiRootDir\data\newstore" -storepass "aircontrolenterprise" | Select-String -SimpleMatch "Alias name"
        $srcAliasFormatted = $srcAlias -replace "Alias name: ", ""
        & $JavaRootDir\bin\keytool.exe -changealias -alias $srcAliasFormatted -destalias "unifi" -storetype pkcs12 -keystore "$UnifiRootDir\data\newstore" -storepass "aircontrolenterprise"

        Write-Host "* Certificate Replaced Successfully" -ForegroundColor Yellow
        Copy-Item "$env:Userprofile\Ubiquiti UniFi\data\newstore" "$env:Userprofile\Ubiquiti UniFi\data\keystore" -Recurse -force
        Remove-Item "$env:Userprofile\Ubiquiti UniFi\data\newstore"
        Write-Host "* Locking Keystore" -ForegroundColor Yellow
        Set-ItemProperty -Path "$UnifiRootDir\Data\keystore" -Name IsReadOnly -Value $true
        UI_START_SVC

    }
    catch {
        Write-Host "`nUnable to renew & install certificate" -ForegroundColor Red
        Write-Host "Check logs for more information about the error" -ForegroundColor Yellow
        $error.Add($_)
        Write-Host $error -ForegroundColor Red
        Start-Sleep -Seconds 5
    }
}
function UI_EXIT {
    Clear-Host
    Write-Host "BYE BYE !!!" -ForegroundColor Green
    Write-Host "`n############################################" -ForegroundColor Magenta
    Write-Host "Last Errors :" -ForegroundColor Yellow
    Write-host "$error" -ForegroundColor Red
    Write-Host "############################################" -ForegroundColor Magenta
    $curDateFinished = Get-Date -Format "dd/MM/yyyy HH/mm/ss"
    Write-Host "`nFinished : $curDateFinished" -ForegroundColor Yellow
    Write-Host " "
    Write-Host " "
    Write-Host "################ LOG END ################"-ForegroundColor Magenta
    Stop-Transcript
    Start-Sleep -Seconds 3
    Exit 0
    
}
function CheckMongoShell {
    try {
        Write-Host "`nChecking MongoDB Shell" -ForegroundColor Yellow
        Write-Host "MongoDB Shell Path: $MongoShell" -ForegroundColor Cyan
        if (-Not (Test-Path $MongoShell)){
            Write-Host "`nMongoDB Shell not found" -ForegroundColor Red
            InstallMongoShell
        }
        else {
            Write-Host "`nMongoDB Shell found" -ForegroundColor Yellow
        }
    }
    catch {
        $error.Add("Unexpected error has occurred while checking MongoDB-Shell")
    }
}
function InstallMongoShell {
    try {
        Write-Host "`nInstalling MongoDB Shell" -ForegroundColor Yellow
        $MongoShellURL = "https://github.com/mongodb-js/mongosh/releases/download/v2.3.2/mongosh-2.3.2-x64.msi"
        $MongoShellPath = "$tempdir\MongoDB-Shell.msi"
        Write-Host "Downloading MongoDB Shell from: $MongoShellURL" -ForegroundColor Cyan
        Write-Host "Saving to: $MongoShellPath" -ForegroundColor Cyan
        Invoke-WebRequest -Uri $MongoShellURL -OutFile $MongoShellPath
        $MSIArguments = @(
            "/i $MongoShellPath ALLUSERS='1'"
            "/passive"
            "/norestart"
        )
        Start-Process "msiexec.exe" -ArgumentList $MSIArguments -Wait -NoNewWindow 
        Write-Host "MongoDB Shell Installed" -ForegroundColor Yellow
    }
    catch {
        $error.Add("Unexpected error has occurred while installing MongoDB-Shell")
    }
}
function MongoDBConnect {
    try {
        Write-Host "`nConnecting to MongoDB" -ForegroundColor Yellow
        Start-Process $MongoShell -ArgumentList "--port 27117" -Wait -NoNewWindow
        Write-Host "Connected to MongoDB" -ForegroundColor Yellow
    }
    catch {
        Write-Host "`nUnable to connect to MongoDB" -ForegroundColor Red
        Write-Host "Check logs for more information about the error" -ForegroundColor Yellow
        $error.Add($_)
        CheckMongoShell
        Start-Sleep -Seconds 5
    }
}
function MongoDBSearchDevice {
    Write-Host "`nSearch Device in MongoDB" -ForegroundColor Yellow
    Write-Host "Enter MAC Address" -ForegroundColor Yellow
    $mac = Read-Host "MAC Address ::"
    $Arguments = @(
            "--port 27117"
            "--eval db.getSiblingDB('ace').device.find({'mac':'$mac'})"
        )
    try {
        Start-Process $MongoShell -ArgumentList $Arguments -Wait -NoNewWindow
        Write-Host "`nPress a key to return" -ForegroundColor Yellow
        $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
    catch {
        $error.Add("Unexpected error has occurred")
        $error.Add($_)
        CheckMongoShell
        Start-Sleep -Seconds 5
    }
}
function MongoDBDeleteDevice {
    Write-Host "`nDelete Device in MongoDB" -ForegroundColor Yellow
    Write-Host "Enter MAC Address" -ForegroundColor Yellow
    $mac = Read-Host "MAC Address ::"
    $Arguments = @(
            "--port 27117"
            "--eval db.getSiblingDB('ace').device.deleteOne({'mac':'$mac'})"
        )
    try {
        Start-Process $MongoShell -ArgumentList $Arguments -Wait -NoNewWindow
        Write-Host "`nPress a key to return" -ForegroundColor Yellow
        $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
    catch {
        $error.Add("Unexpected error has occurred")
        $error.Add($_)
        CheckMongoShell
        Start-Sleep -Seconds 5
    }
}
function CheckJava {
    try {
        Write-Host "`nChecking if Java is installed on your system" -ForegroundColor Yellow
        Write-Host "JavaRootDir: $JavaRootDir" -ForegroundColor Cyan
        $JavaExePath = "$JavaRootDir\bin\java.exe"
        Write-Host "Checking path: $JavaExePath" -ForegroundColor Cyan
        $JavaCheck = Test-Path $JavaExePath
        if ($JavaCheck -eq $false) {
            Write-Host "Java not found" -ForegroundColor Red
            Write-Warning "Java is required to run this script"
            Write-Host "`nInstall java ? (y/n)" -ForegroundColor Yellow
            $InstallJava = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            if ($InstallJava.Character -ine "y") {
                Write-Host "`nJava is required to run this script" -ForegroundColor Red
                $error.Add("Java not found")
                Start-Sleep -Seconds 5
                Write-Host "`nPress a key to exit $ProgramName" -ForegroundColor Yellow
                $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
                UI_EXIT
            } else {
                InstallJava
            }
        } else {
            Write-Host "`nJava found" -ForegroundColor Yellow
            Start-Sleep -Seconds 2
        }
    } catch {
        Write-Host "`nAn error occurred while checking for Java" -ForegroundColor Red
        $error.Add($_)
        Start-Sleep -Seconds 5
    }
}
function InstallJava {
    try {
        Write-Host "Checking for old Java JRE" -ForegroundColor Yellow
        $OldJavaJRE = Get-WmiObject win32_product | Where-Object{$_.name -match "Eclipse"}
        if ($OldJavaJRE){
            Write-Host "`nOld Java JRE found" -ForegroundColor Yellow
            Write-Host "`nUninstalling Old Java JRE" -ForegroundColor Yellow
            try {
                foreach ($OldJava in $OldJavaJRE.IdentifyingNumber){
                    Write-Host "Uninstalling Java JRE with ID: $OldJava" -ForegroundColor Cyan
                    $MSIArguments = @(
                    "/x $OldJava"
                    "/passive"
                    "/norestart"
                    )
                    Start-Process "msiexec.exe" -ArgumentList $MSIArguments -Wait -NoNewWindow 
                }
            }
            catch {
                write-host "`nUnexpected error has occurred while uninstalling Java" -ForegroundColor Red
                $error.Add("Unexpected error has occurred while uninstalling Java")
            }
            Write-Host "`nOld Java JRE Uninstalled" -ForegroundColor Yellow
        }
        Write-Host "`nInstalling Java" -ForegroundColor Yellow
        $JavaURL = "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.5%2B11/OpenJDK21U-jre_x64_windows_hotspot_21.0.5_11.msi"
        $JavaJREInstallerPath = "$tempdir\JavaJRE.msi"
        Write-Host "Downloading Java JRE from: $JavaURL" -ForegroundColor Cyan
        Write-Host "Saving to: $JavaJREInstallerPath" -ForegroundColor Cyan
        Invoke-WebRequest -Uri $JavaURL -OutFile $JavaJREInstallerPath
        Write-Host "Java JRE downloaded successfully" -ForegroundColor Yellow
        $MSIArguments = @(
            "/i $JavaJREInstallerPath ALLUSERS='1'"
            "/passive"
            "/norestart"
        )
        Write-Host "Starting Java JRE installation" -ForegroundColor Yellow
        Start-Process "msiexec.exe" -ArgumentList $MSIArguments -Wait -NoNewWindow 
        Write-Host "Java Installed" -ForegroundColor Yellow
        Write-Warning "Restart $ProgramName" -ForegroundColor Yellow
    }
    catch {
        write-host "`nUnexpected error has occurred while installing Java" -ForegroundColor Red
        $error.Add("Unexpected error has occurred while installing Java")
    }
}
#####################################################################
# Main Code --- Main Code --- Main Code --- Main Code --- Main Code #
#-------------------------------------------------------------------#
SplashLogo
Write-Host "Unifi Controller Management Program" -ForegroundColor Yellow
Write-Host "MATRIXNET ~ Vincent" -ForegroundColor Yellow
Write-Host "Version $version" -ForegroundColor Blue
Write-Host
Write-Host "----------------------------" -ForegroundColor Magenta
write-Host "| Always trust the process |" -ForegroundColor Magenta
Write-Host "----------------------------" -ForegroundColor Magenta
Start-Sleep -Seconds 3


# Check admin rights
function isadmin { ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator") }
 if (isadmin -eq "True") {
     Write-Host "`nGot Administrator Permissions" -ForegroundColor Green
     Start-Sleep -Seconds 1
 }
 else {
     Write-Host "`nThis script needs Administrator Privileges to work it's magic" -ForegroundColor Red
     Start-Sleep -Seconds 3
 }
 if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
  if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
   $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
   Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
   Exit
  }
}

# Check Program Folder
if (-Not (Test-Path $tempdir)){
    New-Item -ItemType Directory -Path $tempdir
}

# Start Logging in Program directory (Tempdir)
$CurDate = Get-Date -Format "dd-MM-yyyy_HH-mm-ss"
Start-Transcript -Path $tempdir\"$ProgramName-$version-$CurDate.log" | Out-Null
Write-Host " "
Write-Host " "
Write-Host "################ LOG BEGIN ################" -ForegroundColor Magenta

#######################################
# Configurable Variables by Config File
#--------------------------------------
$ScriptDir = $tempdir
$ScriptDir += "\$ProgramName.cfg"
$ScriptConfig = $ScriptDir


# Check for UniTrix.cfg
if (-Not (Test-Path $ScriptConfig)){
    Write-Host "Config file not found" -ForegroundColor Red
    Start-Sleep -Seconds 2
    New-Item -ItemType File -Path $ScriptConfig | Out-Null
    Add-Content -Path $ScriptConfig -Value "### FQDN - Enter certificate subject ###"
    Add-Content -Path $ScriptConfig -Value "FQDN="
    Add-Content -Path $ScriptConfig -Value "### CertPath - Custom certificate path ###"
    Add-Content -Path $ScriptConfig -Value "CertPath=$tempdir\Certificates"
    Add-Content -Path $ScriptConfig -Value "### UnifiRootDir - Custom root folder for Unifi installation ###"
    Add-Content -Path $ScriptConfig -Value "UnifiRootDir=$DefaultUnifiRootDir"
    Add-Content -Path $ScriptConfig -Value "### JavaRootPath - Java bin path ###"
    Add-Content -Path $ScriptConfig -Value "JavaRootPath=$DefaultUnifiRootDir\jre"
    Add-Content -Path $ScriptConfig -Value "### MongoDB Shell Path - Path to MongoDB Shell ###"
    Add-Content -Path $ScriptConfig -Value "MongoDBShellPath=C:\Program Files\mongosh\mongosh.exe"
    Write-Host "Config File Created" -ForegroundColor Yellow
    write-host "`nPlease configure $ProgramName.cfg located here $ScriptDir" -ForegroundColor Yellow
    Write-Host "Restart $ProgramName to load configuration" -ForegroundColor Yellow
    $error.Add("Unconfigured Config file") | Out-Null
    Start-Sleep -Seconds 5
    Write-Host "`nPress a key to exit $ProgramName" -ForegroundColor Yellow
    $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit
}

# Read Config file and set variables
Foreach ($i in $(Get-Content $ScriptConfig)){
    Set-Variable -Name $i.split("=")[0] -Value $i.split("=",2)[1]
}

# Check if vars from config file are configured
if ($FQDN -eq "") {
    Write-Host "Fully Qualified Domain Name not specified in $ProgramName.cfg" -ForegroundColor Red
    $error.Add("FQDN not specified") | Out-Null
    Start-Sleep -Seconds 5
    Write-Host "`nPress a key to exit $ProgramName" -ForegroundColor Yellow
    $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit
}

# Check if vars from config file are configured
if ($CertPath -eq "") {
    Write-Host "No custom certificate path set. Using Default Certify The Web Path" -ForegroundColor Yellow
    $CertDir = "C:\ProgramData\Certify\assets\$FQDN"
    $CustomCert = $false
}
else {
    Write-Host "Custom certificate path configured :" -ForegroundColor Yellow
    write-Host "$CertPath"
    $CertDir = $CertPath
    $CustomCert = $true
    if (-Not (Test-Path $CertDir)){
        New-Item -ItemType Directory -Path $CertDir
}
}

# Check if vars from config file are configured
if ($UnifiRootDir -eq "") {
    Write-Host "Using default root directory for Unifi Controller Installation" -ForegroundColor Yellow
    $UnifiRootDir = $DefaultUnifiRootDir
    Write-host "$UnifiRootDir"
}
else {
    Write-Host "Custom Unifi Installation path configured :" -ForegroundColor Yellow
    write-Host "$UnifiRootDir"
}

# Check if vars from config file are configured
if ($JavaRootPath -eq "") {
    Write-Host "Using Java Located at : $JavaRootDir" -ForegroundColor Yellow
}
else {
    Write-Host "Custom Java path configured :" -ForegroundColor Yellow
    write-Host "$JavaRootPath"
    $JavaRootDir = $JavaRootPath
}

if ($MongoDBShellPath -eq "") {
    Write-Host "Using Default MongoDB Shell Path" -ForegroundColor Yellow
    $MongoDBShellPath = "C:\Program Files\mongosh\mongosh.exe"
    $MongoShell = $MongoDBShellPath
}
else {
    Write-Host "Custom MongoDB Shell Path configured :" -ForegroundColor Yellow
    write-Host "$MongoDBShellPath"
    $MongoShell = $MongoDBShellPath
}


##################################
# Begin Loop
$WhileLoopVar = 1
while ($WhileLoopVar -eq 1){
##################################
##################################
# Interactive Menu #
##################################
#Menu items
$list = @('CHECK JAVA','SERVICE STATUS','INSTALL SERVICE','UNINSTALL SERVICE','START SERVICE','STOP SERVICE','RESTART SERVICE','UPDATE CONTROLLER','UPDATE CERTIFICATE','MONGODB SHELL','MONGODB SEARCH DEVICE','MONGODB DELETE DEVICE','EXIT')
 
#menu offset to allow space to write a message above the menu
$xmin = 3
$ymin = 10
 
#Write Menu
Clear-Host
Logo
$host.UI.RawUI.WindowTitle = "$ProgramName - Version $version"
Write-Host ""
Write-Host "  Use the up / down arrow to navigate and Enter to make a selection" -ForegroundColor Yellow
[Console]::SetCursorPosition(0, $ymin)
foreach ($name in $List) {
    for ($i = 0; $i -lt $xmin; $i++) {
        Write-Host " " -NoNewline
    }
    Write-Host "   " + $name
}
 
#Highlights the selected line
function Write-Highlighted {
 
    [Console]::SetCursorPosition(1 + $xmin, $cursorY + $ymin)
    Write-Host ">" -BackgroundColor Yellow -ForegroundColor Black -NoNewline
    Write-Host " " + $List[$cursorY] -BackgroundColor Yellow -ForegroundColor Black
    [Console]::SetCursorPosition(0, $cursorY + $ymin)     
}
 
#Undoes highlight
function Write-Normal {
    [Console]::SetCursorPosition(1 + $xmin, $cursorY + $ymin)
    Write-Host "  " + $List[$cursorY]  
}
 
#highlight first item by default
$cursorY = 0
Write-Highlighted
 
$selection = ""
$menu_active = $true
while ($menu_active) {
    if ([console]::KeyAvailable) {
        $x = $Host.UI.RawUI.ReadKey()
        [Console]::SetCursorPosition(1, $cursorY)
        Write-Normal
        switch ($x.VirtualKeyCode) { 
            38 {
                #down key
                if ($cursorY -gt 0) {
                    $cursorY = $cursorY - 1
                }
            }
 
            40 {
                #up key
                if ($cursorY -lt $List.Length - 1) {
                    $cursorY = $cursorY + 1
                }
            }
            13 {
                #enter key
                $selection = $List[$cursorY]
                $menu_active = $false
            }
        }
        Write-Highlighted
    }
    Start-Sleep -Milliseconds 5 #Prevents CPU usage from spiking while looping
}
 
Clear-Host
switch ($selection) {
    "CHECK JAVA" {CheckJava}
    "SERVICE STATUS" {UI_SVC_STATUS}
    "INSTALL SERVICE" {UI_INSTALL_SVC}
    "UNINSTALL SERVICE" {UI_UNINSTALL_SVC}
    "START SERVICE" {UI_START_SVC}
    "STOP SERVICE" {UI_STOP_SVC}
    "RESTART SERVICE" {UI_RESTART_SVC}
    "UPDATE CONTROLLER" {UI_UPDATE_SVC}
    "UPDATE CERTIFICATE" {UI_UPDATE_CERT}
    "MONGODB SHELL" {MongoDBConnect}
    "MONGODB SEARCH DEVICE" {MongoDBSearchDevice}
    "MONGODB DELETE DEVICE" {MongoDBDeleteDevice}
    "EXIT" {UI_EXIT}
}
}