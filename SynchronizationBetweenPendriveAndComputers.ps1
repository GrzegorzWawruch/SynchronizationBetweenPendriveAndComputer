# Script which synchronizes directories on DataTraveler with directories on user desktop

$CurrentAccount = (whoami).Split('\')[1]
$LocalComputerPaths = @{}
$FolderExistOnComputer = @()
$DataTravelerPath = 'F:\'


$UserFolderPaths = Get-ChildItem -Path "C:\Users\$CurrentAccount\Desktop\" -Directory | Select-Object -ExpandProperty FullName | Out-GridView -OutputMode Multiple -Title 'Select Folders on Computer Desktop'
$DataTravelerFolderList = Get-ChildItem -Path $DataTravelerPath -Directory | Select-Object -ExpandProperty FullName | Out-GridView -OutputMode Multiple -Title 'Select Folders on Pendrive'


foreach($item in $DataTravelerFolderList)
{
    $folderName = Split-Path -Path $item -Leaf
    $LocalComputerPath = Join-Path -Path $UserFolderPaths -ChildPath $folderName
    
    $FolderExistOnComputer = Test-Path -Path $LocalComputerPath
    if(-not $FolderExistOnComputer)
    {
        New-Item -Path $LocalComputerPath -ItemType Directory
    }
    
    Robocopy "$item" "$LocalComputerPath" /E /XO /XN /XC
}

Write-Host 'Synchronization from Pendrive to Computer was completed.'

foreach($item in $UserFolderPaths)
{
    $folderName = Split-Path -Path $item -Leaf
    $DataTravelerPath = Join-Path -Path $DataTravelerPath -ChildPath $folderName
    
    $FolderExistOnPendrive = Test-Path -Path $DataTravelerPath
    if(-not $FolderExistOnPendrive)
    {
        New-Item -Path $DataTravelerPath -ItemType Directory
    }
    
    Robocopy "$item" "$DataTravelerPath" /E /XO /XN /XC
}

Write-Host 'Synchronization from Computer to Pendrive was completed.'
