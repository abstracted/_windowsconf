
# RUN AS ADMIN
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
  if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
    $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
    Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
    Exit
   }
}

# MAKE ME KING
Set-ExecutionPolicy Unrestricted -Scope Process -Force;

# GLOBAL VARIABLES
$CHOCO_SOFTWARE = @(
    # multimedia
    "cccp"
    "foobar2000"
    "spotify"
    "vlc"
    # development
    "docker-desktop"
    "git"
    "kitty"
    "nodejs"
    "putty"
    "python"
    "vagrant"
    "virtualbox"
    "vscodium"
    "zeal"
    # creative
    "bitwig"
    "blender"
    "gimp"
    "inkscape"
    "kdenlive"
    "krita"
    "musescore"
    "obs-studio"
    # internet and downloads
    "filzilla"
    "firefox"
    "protonvpn"
    "qbittorrent"
    "syncthing-gtk"
    "youtube-dl-gui"
    "youtube-dl"
    # gaming
    "steam"
    # utils
    "7zip"
    "etcher"
    "f.lux.install"
    "ffmpeg"
    "gnuwin32-coreutils.install"
    "gzip"
    "lftp"
    "nmap"
    "pandoc"
    "rsync"
    "windirstat"
    # office & social
    "discord"
    "firefox"
    "libreoffice-fresh"
    "okular"
    "protonmailbridge"
    "typora"
)

# INSTALL CHOCO
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# INSTALL CHOCO SOFTWARE
foreach ($SOFTWARE in $CHOCO_SOFTWARE) {
    choco install -y --ignorechecksum $SOFTWARE
}

# DEBLOAT
Invoke-WebRequest -Uri "https://github.com/W4RH4WK/Debloat-Windows-10/archive/master.zip" -OutFile "Debloat-Windows-10.zip"
Expand-Archive -Force -Path Debloat-Windows-10.zip Debloat-Windows-10

Invoke-Expression "./Debloat-Windows-10/Debloat-Windows-10-master/scripts/block-telemetry.ps1"
Invoke-Expression "./Debloat-Windows-10/Debloat-Windows-10-master/scripts/disable-services.ps1"
Invoke-Expression "./Debloat-Windows-10/Debloat-Windows-10-master/scripts/disable-windows-defender.ps1"
Invoke-Expression "./Debloat-Windows-10/Debloat-Windows-10-master/scripts/fix-privacy-settings.ps1"
Invoke-Expression "./Debloat-Windows-10/Debloat-Windows-10-master/scripts/optimize-windows-update.ps1"
Invoke-Expression "./Debloat-Windows-10/Debloat-Windows-10-master/scripts/remove-default-apps.ps1"
Invoke-Expression "./Debloat-Windows-10/Debloat-Windows-10-master/scripts/remove-onedrive.ps1"
Invoke-Expression "./Debloat-Windows-10/Debloat-Windows-10-master/utils/enable-god-mode.ps1"

# WINDOWS SUBSYSTEM FOR LINUX
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
