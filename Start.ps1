
[CmdletBinding(SupportsShouldProcess)]
Param
(
    [Parameter(Mandatory = $False, Position = 0)]
    [string]$XAMLPath = "./MainWindow.xaml",
    [Parameter(Mandatory = $False)]
    [switch]$UseFormNameAsNamespace = $True
)

[void][System.Reflection.Assembly]::LoadWithPartialName('PresentationFramework')
[void][System.Reflection.Assembly]::LoadWithPartialName('PresentationCore')
[void][System.Reflection.Assembly]::LoadWithPartialName('WindowsBase')
[void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
[void][System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')
[void][System.Reflection.Assembly]::LoadWithPartialName('System')
[void][System.Reflection.Assembly]::LoadWithPartialName('System.Xml')
[void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows')

#Build the GUI
[xml]$xaml = Get-Content $XAMLPath 
     
$reader=(New-Object System.Xml.XmlNodeReader $xaml)
$Window=[Windows.Markup.XamlReader]::Load( $reader )

#AutoFind all controls 
$xaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]")  | ForEach-Object {  
    New-Variable  -Name $_.Name -Value $Window.FindName($_.Name) -Force -Scope Global
    Write-Host "Variable named: Name $($_.Name)"
}

function Invoke-PopulateContainersList {
    $containers = $containers = Get-DockerContainersData
    $ContainersListBox.ItemsSource = $null
    $ContainersListBox.ItemsSource = $containers
    
}

function Invoke-PopulateStacksList {
    $stacks = List-PortainerStacks | Select Name, Status, UpdateDate | Convert-PortainerStacks
    $StacksListBox.ItemsSource = $null
    $StacksListBox.ItemsSource = $stacks
}

function Invoke-StartContainerBtn{
    $selectedContainer = $ContainersListBox.SelectedItem
    if($selectedContainer -ne $Null) 
    {
        #$name = ($selectedContainer -split '\s+')[0]
        $selectedContainer
    }
}

function Invoke-StopContainerBtn{
    $selectedContainer = $ContainersListBox.SelectedItem
    Write-Host "[Invoke-StopContainerBtn] Selected:"
    Write-Host $selectedContainer
    
    if ($null -ne $selectedContainer) {
        $name = $selectedContainer[0].Name
        Write-Host "name $name"
        Invoke-PopulateContainersList
    }
}

function Invoke-ShowDetailsContainerBtn{
    $selectedContainer = $ContainersListBox.SelectedItem
    if ($null -ne $selectedContainer) {
        $name = ($selectedContainer -split '\s+')[0]
        Start-Process "docker inspect $name"
    }
}

$StacksListBox.add_SelectionChanged({
    $selectedStack = $StacksListBox.SelectedItem
    if ($null -ne $selectedStack) {
        Write-Host "Selected Stack:" -ForegroundColor Green
        Write-Host $selectedStack
    }
})

# Event Handler for Containers Selection
$ContainersListBox.add_SelectionChanged({
    $selectedContainer = $ContainersListBox.SelectedItem
    if ($null -ne $selectedContainer) {
        Write-Host "Selected Container:" -ForegroundColor Green
        Write-Host $selectedContainer
    }
})


# Stack Button Handlers

# Stop Stack
$StopStackButton.Add_Click({
    $selectedStack = $StacksListBox.SelectedItem
    if ($null -ne $selectedStack) {
        $sname = $($selectedStack.Name)
        Write-Host "Restarting Stack: $($selectedStack.Name)" -ForegroundColor Cyan
         List-PortainerStacks | Where Name -match $sname | Stop-PortainerStack
         Invoke-PopulateStacksList
    } else {
        Write-Host "No stack selected!" -ForegroundColor Yellow
    }
})

# Restart Stack
$RestartStackButton.Add_Click({
    $selectedStack = $StacksListBox.SelectedItem
    if ($null -ne $selectedStack) {
        $sname = $($selectedStack.Name)
        Write-Host "Restarting Stack: $($selectedStack.Name)" -ForegroundColor Cyan
         List-PortainerStacks | Where Name -match $sname | Stop-PortainerStack
         Start-Sleep 1
         List-PortainerStacks | Where Name -match $sname | Start-PortainerStack
         Invoke-PopulateStacksList
    } else {
        Write-Host "No stack selected!" -ForegroundColor Yellow
    }
})
# Start Stack
$StartStackButton.Add_Click({
    $selectedStack = $StacksListBox.SelectedItem
    if ($null -ne $selectedStack) {
        Write-Host "Starting Stack: $($selectedStack.Name)" -ForegroundColor Green
        $sname = $($selectedStack.Name)
        Write-Host "Restarting Stack: $($selectedStack.Name)" -ForegroundColor Cyan
         List-PortainerStacks | Where Name -match $sname | Start-PortainerStack
    } else {
        Write-Host "No stack selected!" -ForegroundColor Yellow
    }
})

$CloseButton = $Window.FindName("CloseButton")

# Button Click Handlers
$StartContainerButton.Add_Click({Invoke-StartContainerBtn})


$StopContainerButton.Add_Click({Invoke-StopContainerBtn})
$DetailsContainerButton.Add_Click({Invoke-ShowDetailsContainerBtn})
  
$CloseButton.Add_Click({ $Window.Close() })
Invoke-PopulateStacksList
Invoke-PopulateContainersList
$Window.ShowDialog() | Out-Null





