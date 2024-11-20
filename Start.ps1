
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


function AppLog {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory=$True,Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Message,
        [Parameter(Mandatory=$False)]
        [string]$Color = "Black"  # Default color is Black
    )

    # Add the log message to the LogsTextBox
    $LogsTextBox.Dispatcher.Invoke({
        $run = New-Object Windows.Documents.Run $Message
        $run.Foreground = [System.Windows.Media.Brushes]::$Color
        $LogsTextBox.AppendText("$Message`n")
        $LogsTextBox.ScrollToEnd()
    })
}

function Invoke-PopulateContainersList {
    AppLog "Calling Invoke-PopulateContainersList" -Color Red
    $containers = $containers = Get-DockerContainersData
    $ContainersListBox.ItemsSource = $null
    $ContainersListBox.ItemsSource = $containers
    
}

function Invoke-PopulateStacksList {
    AppLog "Calling Invoke-PopulateStacksList"
    $stacks = List-PortainerStacks | Select Name, Status, UpdateDate | Convert-PortainerStacks
    $StacksListBox.ItemsSource = $null
    $StacksListBox.ItemsSource = $stacks
}

function Invoke-RefreshUiLists {
    AppLog "Calling Invoke-RefreshUiLists"
    Invoke-PopulateStacksList
    Invoke-PopulateContainersList
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

function Invoke-RestartDockerButton{
    $SshExe = (Get-Command 'ssh.exe').Source
    &"$SshExe" 'miniautoroot' 'systemctl restart snap.docker.dockerd.service'
}

function Invoke-UpdateAllButton{
    Invoke-RefreshUiLists
}


$StacksListBox.add_SelectionChanged({
    $selectedStack = $StacksListBox.SelectedItem
    if ($null -ne $selectedStack) {
        AppLog "Selected Stack:" -Color Green
        AppLog $selectedStack
    }
})

# Event Handler for Containers Selection
$ContainersListBox.add_SelectionChanged({
    $selectedContainer = $ContainersListBox.SelectedItem
    if ($null -ne $selectedContainer) {
        AppLog "Selected Container:" -Color Green
        AppLog $selectedContainer
    }
})


# Stack Button Handlers

# Stop Stack
$StopStackButton.Add_Click({
    $selectedStack = $StacksListBox.SelectedItem
    if ($null -ne $selectedStack) {
        $sname = $($selectedStack.Name)
        AppLog "Restarting Stack: $($selectedStack.Name)" -Color Cyan
         List-PortainerStacks | Where Name -match $sname | Stop-PortainerStack
         Invoke-PopulateStacksList
    } else {
        AppLog "No stack selected!" -Color Yellow
    }
})

# Restart Stack
$RestartStackButton.Add_Click({
    $selectedStack = $StacksListBox.SelectedItem
    if ($null -ne $selectedStack) {
        $sname = $($selectedStack.Name)
        AppLog "Restarting Stack: $($selectedStack.Name)" -Color Cyan
         List-PortainerStacks | Where Name -match $sname | Stop-PortainerStack
         Start-Sleep 1
         List-PortainerStacks | Where Name -match $sname | Start-PortainerStack
         Invoke-PopulateStacksList
    } else {
        AppLog "No stack selected!" -Color Yellow
    }
})
# Start Stack
$StartStackButton.Add_Click({
    $selectedStack = $StacksListBox.SelectedItem
    if ($null -ne $selectedStack) {
        AppLog "Starting Stack: $($selectedStack.Name)" -Color Green
        $sname = $($selectedStack.Name)
        AppLog "Restarting Stack: $($selectedStack.Name)" -Color Cyan
         List-PortainerStacks | Where Name -match $sname | Start-PortainerStack
    } else {
        AppLog "No stack selected!" -Color Yellow
    }
})
$RestartDockerButton = $Window.FindName("RestartDockerButton")
$CloseButton = $Window.FindName("CloseButton")
$UpdateAllButton = $Window.FindName("UpdateAllButton")
# Button Click Handlers
$StartContainerButton.Add_Click({Invoke-StartContainerBtn})

$RestartDockerButton.Add_Click({Invoke-RestartDockerButton})
$UpdateAllButton.Add_Click({Invoke-UpdateAllButton})

$StopContainerButton.Add_Click({Invoke-StopContainerBtn})
$DetailsContainerButton.Add_Click({Invoke-ShowDetailsContainerBtn})
  
$CloseButton.Add_Click({ $Window.Close() })
Invoke-RefreshUiLists
$Window.ShowDialog() | Out-Null

