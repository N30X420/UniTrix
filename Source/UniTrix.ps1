#######################################
# Configurable Variables
#--------------------------------------
$version = "2.0"
$ProgramName = "UniTrix"
########################################
$UnifiRootDir = "$env:Userprofile\Ubiquiti UniFi"
$tempdir = "C:\INSTALL\$ProgramName-$version"
$CTWAssetsDir = "C:\ProgramData\Certify\assets\$fqdn"
$KeyToolBin = "C:\Program Files\Eclipse Adoptium\jdk-11.0.17.8-hotspot\bin\keytool.exe"
$JavaBin = "C:\Program Files\Eclipse Adoptium\jdk-11.0.17.8-hotspot\bin\java.exe"
#######################################
$error.clear()
$ProgressPreference = 'SilentlyContinue'
#######################################
#######################################
# Configurable Variables by Config File
#--------------------------------------
$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
$ScriptDir = "C:\Users\vincent\Desktop\Github Repositories\UniTrix\Source"
$ScriptDir += "\$ProgramName.cfg"
$ScriptConfig = $ScriptDir

# Check for UniTrix.cfg
if (-Not (Test-Path $ScriptConfig)){
    Write-Host "Config file not found" -ForegroundColor Red
    Start-Sleep -Seconds 2
    New-Item -ItemType File -Path $ScriptConfig | Out-Null
    Add-Content -Path $ScriptConfig -Value "fqdn = "
    #Add-Content -Path $ScriptConfig -Value "UnifiRootDir = "
    #Add-Content -Path $ScriptConfig -Value "CTWAssetsDir = "
    #Add-Content -Path $ScriptConfig -Value "KeyToolBin = "
    #Add-Content -Path $ScriptConfig -Value "JavaBin = "
    Write-Host "Config File Created" -ForegroundColor Yellow
    write-host "`nPlease configure $ProgramName.cfg located here $ScriptDir" -ForegroundColor Yellow
    Write-Host "Restart $ProgramName to load configuration" -ForegroundColor Yellow
    $error.Add("Unconfigured Config file") | Out-Null
    Start-Sleep -Seconds 5
    Write-Host "`nPress a key to exit $ProgramName" -ForegroundColor Yellow
    $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit
}

# Read Config file
$ScriptVars = Get-Content -raw -Path $ScriptConfig | ConvertFrom-StringData

# Define vars from config file
$fqdn = $ScriptVars['fqdn']

# Check if vars from config file are configured
if ($fqdn -eq "") {
    Write-Host "Fully Qualified Domain Name not specified in $ProgramName.cfg" -ForegroundColor Red
    $error.Add("FQDN not specified") | Out-Null
    Start-Sleep -Seconds 5
    Write-Host "`nPress a key to exit $ProgramName" -ForegroundColor Yellow
    $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit
}

###################################
####
# Functions
#--------------------------------------
# Logo
function SplashLogo {
    Write-Host "                                                                                " -ForegroundColor Red
    Write-Host "                              *####(((///*****////(/.                            " -ForegroundColor Red
    Write-Host "                        (#####((/*,,....         ....,**/(.                      " -ForegroundColor Red
    Write-Host "                    #######((*,..                    (@@&#%#                     " -ForegroundColor Red
    Write-Host "                .########(/*,..                 @@&##%%%%#((#%#.                 " -ForegroundColor Red
    Write-Host "              ##########(/*......          (@&&%#(((#%&&&&&&&%%%%#               " -ForegroundColor Red
    Write-Host "            ##(,..*####(/*,,.........  /@&&&&&&&&&&&&&&&&&&&&&&&&%&#             " -ForegroundColor Red
    Write-Host "          ##(. .*(#####(/*,,,,,....,@@&&&&&&&&&&&&&&&&&&&&%(.    ..,*//*,        " -ForegroundColor Red
    Write-Host "        /##(..*((,/###((/****,,,*@@&&&&&&&&&&&&&&&&&&,             ..,,*,/       " -ForegroundColor Red
    Write-Host "       ################((///*#@@&&&&&&&&&&&&&&&*                     ....,/      " -ForegroundColor Red
    Write-Host "      #################((((@@&&&&&&&&&&&&&#......                      ...,/,    " -ForegroundColor Red
    Write-Host "     ###################@@&&&&&&&&&&&&#***,,,,...                        .,*(    " -ForegroundColor Red
    Write-Host "    (################%@&&&&&&&&&&&&(/////****,,,..                        .*/(   " -ForegroundColor Red
    Write-Host "    #%#############@@&&&&&&&&&&%#(((((((////****,,..                      .*/(/  " -ForegroundColor Red
    Write-Host "   ,#%%%%########@@&&&&&&&&&##########(((((////*****,,,..                 .*(##  " -ForegroundColor Red
    Write-Host "   /%%%%%%%%###@@&&&&&&&&&&&&&&&&&%%#####(((((/////*****,,,,,...          ./(##  " -ForegroundColor Red
    Write-Host "   /&&%%%%%%%@@&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&#((///*****,,,,,,..       ,/(##  " -ForegroundColor Red
    Write-Host "   /#&&&&&%%%%%%%#######%@@@@&&&&&&&&&&&&&&&&&&&&&&&&&&&&%(***,,.         */(##  " -ForegroundColor Red
    Write-Host "    (&&&&&&&%%%%%%%%##############&@@&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&#,,,..*//(#(  " -ForegroundColor Red
    Write-Host "    (&&&&&&&&&&%%%%%%%##################%@@&&&&&&&&&&&&&&&&&&&&&&@@&#*..*//(##   " -ForegroundColor Red
    Write-Host "     #&&&&&&&&&&&&%%%%%%%############((((((#%&&&&&&&&&&&&&&&@@&%*      *//((#*   " -ForegroundColor Red
    Write-Host "      #&&&&&&&&&&&&&%%%%%%%##########((#%&&&&&&&&&&&&&&@@&#*         *///((#(    " -ForegroundColor Red
    Write-Host "       #&&&&&&&&&&&&&&%%%%%%%%######%&&&&&&&&&&&&&@@&#*            *////((#/     " -ForegroundColor Red
    Write-Host "        %&&&&&&&&&&&&&&&%%%%%%%%%&&&&&&&&&&&&@@&(/.             .*/////(##.      " -ForegroundColor Red
    Write-Host "         .&&&&&&&&&&&&&&&%%%%&&&&&&&&&&&@@&(/*,             .,*//////((##        " -ForegroundColor Red
    Write-Host "           #&&&&&&&&&&%&&&@@@@@&&&&@@&##((((///***,,,,,**//////////((##        " -ForegroundColor Red  
    Write-Host "             *@&&&&&&&@@@@@@@@@&%%#####((((((((((///////////////((##(  " -ForegroundColor Red          
    Write-Host "                &@#@@@@@@&&%%%%%#######(((((((((((//////////(((#(#.     " -ForegroundColor Red     
    Write-Host "                    .&&&&&%%%%#########((((((((((((///(((((####         " -ForegroundColor Red
    Write-Host "                       &&&&&&&%%%%######((((((((((((#######             " -ForegroundColor Red
    Write-Host "                            .###%%&&&&&&&&%%%%%%%####,                  " -ForegroundColor Red        
    Write-Host "                                                                        " -ForegroundColor Red



    Write-Host "___ _   _  ____ ___  _   _ _____ _        ______     __                                                           "
    Write-Host "|_ _| \ | |/ ___/ _ \| \ | | ____| |      | __ ) \   / /                                                           "
    Write-Host " | ||  \| | |  | | | |  \| |  _| | |      |  _ \\ \ / /                                                            "
    Write-Host " | || |\  | |__| |_| | |\  | |___| |___   | |_) |\ V /                                                             "
    Write-Host "|___|_| \_|\____\___/|_| \_|_____|_____|  |____(_)\_(_)                                                            "
    Write-Host "__        __   _        ___     _   _      _                      _      ____        _       _   _                 "
    Write-Host "\ \      / /__| |__    ( _ )   | \ | | ___| |___      _____  _ __| | __ / ___|  ___ | |_   _| |_(_) ___  _ __  ___ "
    Write-Host " \ \ /\ / / _ \ '_ \   / _ \/\ |  \| |/ _ \ __\ \ /\ / / _ \| '__| |/ / \___ \ / _ \| | | | | __| |/ _ \| '_ \/ __|"
    Write-Host "  \ V  V /  __/ |_) | | (_>  < | |\  |  __/ |_ \ V  V / (_) | |  |   <   ___) | (_) | | |_| | |_| | (_) | | | \__ \"
    Write-Host "   \_/\_/ \___|_.__/   \___/\/ |_| \_|\___|\__| \_/\_/ \___/|_|  |_|\_\ |____/ \___/|_|\__,_|\__|_|\___/|_| |_|___/"
    Write-Host "                                                                                                                   "
    Write-Host ""
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
    Write-Host "`nInstalling Unifi Service" -ForegroundColor Yellow
    try {
        & $JavaBin -jar "$UnifiRootDir\lib\ace.jar" installsvc
    }
    catch {
        Write-Host "Unable to install Unifi Service" -ForegroundColor Red
        Write-Host "Check logs for more information about the error" -ForegroundColor Yellow
        $error.Add($_)
        Write-Host $error -ForegroundColor Red
        Start-Sleep -Seconds 5
    }
}

function UI_UNINSTALL_SVC {
    Write-Host "`nUninstalling Unifi Service" -ForegroundColor Yellow
    try {
        Write-Host "Stopping Unifi Service" -ForegroundColor Yellow
        & $JavaBin -jar "$UnifiRootDir\lib\ace.jar" stopsvc
        Start-Sleep -Seconds 2
        Write-Host "Removing Unifi Service" -ForegroundColor Yellow
        & $JavaBin -jar "$UnifiRootDir\lib\ace.jar" uninstallsvc
        Write-Host "Unifi Service Removed" -ForegroundColor Yellow
    }
    catch {
        Write-Host "Unable to uninstall Unifi Service" -ForegroundColor Red
        Write-Host "Check logs for more information about the error" -ForegroundColor Yellow
        $error.Add($_)
        Write-Host $error -ForegroundColor Red
        Start-Sleep -Seconds 5
    }
}

function UI_START_SVC {
    Write-Host "`nStarting Unifi Service" -ForegroundColor Yellow
    try {
        & $JavaBin -jar "$UnifiRootDir\lib\ace.jar" startsvc
    }
    catch {
        Write-Host "Unable to start Unifi Service" -ForegroundColor Red
        Write-Host "Check logs for more information about the error" -ForegroundColor Yellow
        $error.Add($_)
        Write-Host $error -ForegroundColor Red
        Start-Sleep -Seconds 5
    }
}

function UI_STOP_SVC {
    Write-Host "`nStopping Unifi Service" -ForegroundColor Yellow
    try {
        & $JavaBin -jar "$UnifiRootDir\lib\ace.jar" stopsvc
    }
    catch {
        Write-Host "Unable to stop Unifi Service" -ForegroundColor Red
        Write-Host "Check logs for more information about the error" -ForegroundColor Yellow
        $error.Add($_)
        Write-Host $error -ForegroundColor Red
        Start-Sleep -Seconds 5
    }
}

function UI_RESTART_SVC {
    Write-Host "`nRestarting Unifi Service" -ForegroundColor Yellow
    try {
        Write-Host "Stopping Unifi Service" -ForegroundColor Yellow
        & $JavaBin -jar "$UnifiRootDir\lib\ace.jar" stopsvc
        Write-Host "Unifi Service stopped" -ForegroundColor Yellow
        Start-Sleep -Seconds 5
        Write-Host "Starting Unifi Service" -ForegroundColor Yellow
        & $JavaBin -jar "$UnifiRootDir\lib\ace.jar" startsvc
        Write-Host "Unifi Service started" -ForegroundColor Yellow
    }
    catch {
        Write-Host "Unable to restart Unifi Service" -ForegroundColor Red
        Write-Host "Check logs for more information about the error" -ForegroundColor Yellow
        $error.Add($_)
        Write-Host $error -ForegroundColor Red
        Start-Sleep -Seconds 5
    }
}

function UI_SVC_STATUS {
    Write-Host "`nGetting Unifi Service Status" -ForegroundColor Yellow
    try {
        get-service -name Unifi | Format-List
        start-sleep -Seconds 3
        Write-Host "Press a key to return to the menu" -ForegroundColor Yellow
        $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
    catch {
        Write-Host "Unable to get Unifi Service status" -ForegroundColor Red
        Write-Host "Check logs for more information about the error" -ForegroundColor Yellow
        $error.Add($_)
        Write-Host $error -ForegroundColor Red
        Start-Sleep -Seconds 5
    }
}

function UI_UPDATE_SVC {
    Write-Host "`nUpdating Unifi Service" -ForegroundColor Yellow
    try {
        UI_STOP_SVC
        start-sleep -Seconds 2
        UI_UNINSTALL_SVC
        Write-Host "Fetching Controller Update" -ForegroundColor Yellow
        Write-Host "Press any key to use a custom version or wait 5 seconds" -ForegroundColor Yellow
        Start-Sleep -Seconds 5
        if($host.UI.RawUI.KeyAvailable){
           $CustomVersion = Read-Host "Custom Version"
           Write-Host "Downloading version $CustomVersion" -ForegroundColor Yellow
           Invoke-WebRequest -Uri "https://dl.ui.com/unifi/$CustomVersion/UniFi-installer.exe" -OutFile "$tempdir\Unifi-installer.exe"
           Write-Host "Update downloaded" -ForegroundColor Yellow
        }

        else {
            Write-Host "Manually download latest installer from Ubiquiti Unifi" -ForegroundColor Yellow
            start-process "https://www.ui.com/download/unifi/"
        }

        if ($null -ne $CustomVersion) {
            $UpdateFileLocation = "$tempdir\Unifi-installer.exe"
        }
        else {
            $UpdateFileLocation = "$env:Userprofile\Downloads\Unifi-installer.exe"
        }

        Start-Sleep -Seconds 2
        Write-Host "Starting Unifi Controller Update" -ForegroundColor Yellow
        Start-Process -ErrorAction Stop -Wait "$UpdateFileLocation /S"
        Start-Sleep -Seconds 2
        Write-Host "Update Completed" -ForegroundColor Yellow
        UI_INSTALL_SVC
        Start-Sleep -Seconds 2
        UI_START_SVC


    }
    catch {
        Write-Host "Unable to update Unifi Service" -ForegroundColor Red
        Write-Host "Check logs for more information about the error" -ForegroundColor Yellow
        $error.Add($_)
        Write-Host $error -ForegroundColor Red
        Start-Sleep -Seconds 5
    }
}


function UI_UPDATE_CERT {
    Write-Host "`nUpdating Unifi Controller Certificate" -ForegroundColor Yellow
    try {
        UI_STOP_SVC
        Write-Host "Unlocking Keystore" -ForegroundColor Yellow
        Set-ItemProperty -Path "$UnifiRootDir\Data\keystore" -Name IsReadOnly -Value $false
        Start-Sleep -Seconds 2
        
        Write-Host "Replacing certificate" -ForegroundColor Yellow
        $NewCert = Get-ChildItem $CTWAssetsDir | Sort-Object LastWriteTime | Select-Object -last 1
        $Params = "-importkeystore -srckeystore ""$CTWAssetsDir\$NewCert"" -srcstoretype pkcs12 -srcstorepass """" -destkeystore ""$env:Userprofile\Ubiquiti UniFi\data\newstore"" -deststoretype pkcs12 -deststorepass ""aircontrolenterprise"" -destkeypass ""aircontrolenterprise"""
        $Prms   = $Params.Split(" ")
        & "$KeyToolBin" $Prms

        Copy-Item "$env:Userprofile\Ubiquiti UniFi\data\newstore" "$env:Userprofile\Ubiquiti UniFi\data\keystore" -Recurse -force
        Remove-Item "$env:Userprofile\Ubiquiti UniFi\data\newstore"
        Write-Host "Locking Keystore" -ForegroundColor Yellow
        Set-ItemProperty -Path "$UnifiRootDir\Data\keystore" -Name IsReadOnly -Value $true
        UI_START_SVC

    }
    catch {
        Write-Host "Unable to renew & install certificate" -ForegroundColor Red
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






#####################################################################
# Main Code --- Main Code --- Main Code --- Main Code --- Main Code #
#-------------------------------------------------------------------#
SplashLogo
Write-Host "Unifi Controller Management Program" -ForegroundColor Yellow
Write-Host "MATRIXNET ~ Vincent" -ForegroundColor Yellow
Write-Host "INCONEL BV ~ Vincent" -ForegroundColor Yellow
Write-Host "Version $version" -ForegroundColor Yellow
Write-Host
Write-Host "----------------------------" -ForegroundColor Magenta
write-Host "| Always trust the process |" -ForegroundColor Magenta
Write-Host "----------------------------" -ForegroundColor Magenta
Start-Sleep -Seconds 5
$host.UI.RawUI.WindowTitle = "$ProgramName - Version $version"


# Check admin rights
function isadmin
 {
 # Returns true/false
   ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
 }
 if (isadmin -eq "True") {

     Write-Host "`nGot Administrator Permissions" -ForegroundColor Green
     Start-Sleep -Seconds 2

 }
 else {
     Write-Host "`nThis script needs Administrator Privileges to work it's magic" -ForegroundColor Red
     Start-Sleep -Seconds 2
 }
 if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
  if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
   $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
   Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
   Exit
  }
}

# Check Install Folder
if (-Not (Test-Path $tempdir)){
    New-Item -ItemType Directory -Path $tempdir
}

# Start Logging in Install directory (Tempdir)
$CurDate = Get-Date -Format "dd/MM/yyyy_HH/mm/ss"
Start-Transcript -Path $tempdir\"$ProgramName-$version-$CurDate.log"
Write-Host " "
Write-Host " "
Write-Host "################ LOG BEGIN ################"


$WhileLoopVar = 1
while ($WhileLoopVar -eq 1){

##################################
# Interactive Menu #
##################################
#Menu items
$list = @('SERVICE STATUS','INSTALL SERVICE','UNINSTALL SERVICE','START SERVICE','STOP SERVICE','RESTART SERVICE','UPDATE CONTROLLER','UPDATE CERTIFICATE','EXIT')
 
#menu offset to allow space to write a message above the menu
$xmin = 3
$ymin = 6
 
#Write Menu
Clear-Host
Logo
Write-Host ""
Write-Host ""
Write-Host ""
Write-Host ""
Write-Host "  Use the up / down arrow to navigate and Enter to make a selection"
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
    "SERVICE STATUS" {UI_SVC_STATUS}
    "INSTALL SERVICE" {UI_INSTALL_SVC}
    "UNINSTALL SERVICE" {UI_UNINSTALL_SVC}
    "START SERVICE" {UI_START_SVC}
    "STOP SERVICE" {UI_STOP_SVC}
    "RESTART SERVICE" {UI_RESTART_SVC}
    "UPDATE CONTROLLER" {UI_UPDATE_SVC}
    "UPDATE CERTIFICATE" {UI_UPDATE_CERT}
    "EXIT" {UI_EXIT}
}
}