
[CmdletBinding(SupportsShouldProcess)]
Param()

[string]$XAMLPath = "$PSScriptRoot\MainWindow.xaml"
[bool]$UseEmbeddedXaml = $True

[void][System.Reflection.Assembly]::LoadWithPartialName('PresentationFramework')
[void][System.Reflection.Assembly]::LoadWithPartialName('PresentationCore')
[void][System.Reflection.Assembly]::LoadWithPartialName('WindowsBase')
[void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
[void][System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')
[void][System.Reflection.Assembly]::LoadWithPartialName('System')
[void][System.Reflection.Assembly]::LoadWithPartialName('System.Xml')
[void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows')

if($UseEmbeddedXaml){
    $TempFilePath = "$ENV:Temp\ui.xaml"
    $XamlFile_000 = "77u/PFdpbmRvdyB4bWxucz0iaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93aW5meC8yMDA2L3hhbWwvcHJlc2VudGF0aW9uIg0KICAgICAgICB4bWxuczp4PSJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dpbmZ4LzIwMDYveGFtbCINCiAgICAgICAgVGl0bGU9IlBvcnRhaW5lciBhbmQgRG9ja2VyIE1hbmFnZXIiDQogICAgICAgIEhlaWdodD0iNjQwIiBXaWR0aD0iOTAwIiBXaW5kb3dTdGFydHVwTG9jYXRpb249IkNlbnRlclNjcmVlbiIgUmVzaXplTW9kZT0iTm9SZXNpemUiIFdpbmRvd1N0eWxlPSJTaW5nbGVCb3JkZXJXaW5kb3ciPg0KICAgIDxHcmlkIFJlbmRlclRyYW5zZm9ybU9yaWdpbj0iMC41LDAuNSIgTWFyZ2luPSIwLDAsMCwzNiI+DQogICAgICAgIDwhLS0gRGVmaW5lIExheW91dCB3aXRoIFJvd3MgYW5kIENvbHVtbnMgLS0+DQogICAgICAgIDxHcmlkLlJvd0RlZmluaXRpb25zPg0KICAgICAgICAgICAgPFJvd0RlZmluaXRpb24gSGVpZ2h0PSJBdXRvIi8+DQogICAgICAgICAgICA8IS0tIEdyb3VwIEJveGVzIC0tPg0KICAgICAgICAgICAgPFJvd0RlZmluaXRpb24gSGVpZ2h0PSJBdXRvIi8+DQogICAgICAgICAgICA8IS0tIEdyb3VwIEJveGVzIC0tPg0KICAgICAgICAgICAgPFJvd0RlZmluaXRpb24gSGVpZ2h0PSIqIi8+DQogICAgICAgICAgICA8IS0tIExvZ3MgLS0+DQogICAgICAgICAgICA8Um93RGVmaW5pdGlvbiBIZWlnaHQ9IkF1dG8iLz4NCiAgICAgICAgICAgIDwhLS0gQ2xvc2UgQnV0dG9uIC0tPg0KICAgICAgICA8L0dyaWQuUm93RGVmaW5pdGlvbnM+DQogICAgICAgIDxHcmlkLkNvbHVtbkRlZmluaXRpb25zPg0KICAgICAgICAgICAgPENvbHVtbkRlZmluaXRpb24gV2lkdGg9IjIuNSoiIC8+DQogICAgICAgICAgICA8Q29sdW1uRGVmaW5pdGlvbiBXaWR0aD0iMi41KiIgLz4NCiAgICAgICAgICAgIDxDb2x1bW5EZWZpbml0aW9uIFdpZHRoPSIyLjUqIiAvPg0KICAgICAgICAgICAgPENvbHVtbkRlZmluaXRpb24gV2lkdGg9IjIuNSoiIC8+DQogICAgICAgIDwvR3JpZC5Db2x1bW5EZWZpbml0aW9ucz4NCg0KICAgICAgICA8IS0tIFN0YWNrcyBHcm91cCBCb3ggLS0+DQogICAgICAgIDxHcm91cEJveCBIZWFkZXI9IlN0YWNrcyIgR3JpZC5Sb3c9IjAiIEdyaWQuQ29sdW1uPSIwIiBHcmlkLkNvbHVtblNwYW49IjIiIE1hcmdpbj0iMTAiPg0KICAgICAgICAgICAgPEdyaWQ+DQogICAgICAgICAgICAgICAgPEdyaWQuUm93RGVmaW5pdGlvbnM+DQogICAgICAgICAgICAgICAgICAgIDxSb3dEZWZpbml0aW9uIEhlaWdodD0iKiIvPg0KICAgICAgICAgICAgICAgICAgICA8IS0tIExpc3RCb3ggLS0+DQogICAgICAgICAgICAgICAgICAgIDxSb3dEZWZpbml0aW9uIEhlaWdodD0iQXV0byIvPg0KICAgICAgICAgICAgICAgICAgICA8IS0tIEJ1dHRvbnMgLS0+DQogICAgICAgICAgICAgICAgPC9HcmlkLlJvd0RlZmluaXRpb25zPg0KICAgICAgICAgICAgICAgIDwhLS0gTGlzdEJveCBmb3IgU3RhY2tzIC0tPg0KICAgICAgICAgICAgICAgIDxMaXN0Qm94IE5hbWU9IlN0YWNrc0xpc3RCb3giIEdyaWQuUm93PSIwIiBNYXJnaW49IjUiPg0KICAgICAgICAgICAgICAgICAgICA8TGlzdEJveC5JdGVtVGVtcGxhdGU+DQogICAgICAgICAgICAgICAgICAgICAgICA8RGF0YVRlbXBsYXRlPg0KICAgICAgICAgICAgICAgICAgICAgICAgICAgIDxTdGFja1BhbmVsIE9yaWVudGF0aW9uPSJIb3Jpem9udGFsIj4NCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPFRleHRCbG9jayBUZXh0PSJ7QmluZGluZyBOYW1lfSIgV2lkdGg9IjEwMCIvPg0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA8VGV4dEJsb2NrIFRleHQ9IntCaW5kaW5nIFN0YXR1c30iIFdpZHRoPSIxMDAiLz4NCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPFRleHRCbG9jayBUZXh0PSJ7QmluZGluZyBVcGRhdGVEYXRlfSIgV2lkdGg9IjEwMCIvPg0KICAgICAgICAgICAgICAgICAgICAgICAgICAgIDwvU3RhY2tQYW5lbD4NCiAgICAgICAgICAgICAgICAgICAgICAgIDwvRGF0YVRlbXBsYXRlPg0KICAgICAgICAgICAgICAgICAgICA8L0xpc3RCb3guSXRlbVRlbXBsYXRlPg0KICAgICAgICAgICAgICAgIDwvTGlzdEJveD4NCiAgICAgICAgICAgICAgICA8IS0tIEJ1dHRvbnMgLS0+DQogICAgICAgICAgICAgICAgPFN0YWNrUGFuZWwgR3JpZC5Sb3c9IjEiIE9yaWVudGF0aW9uPSJIb3Jpem9udGFsIiBIb3Jpem9udGFsQWxpZ25tZW50PSJDZW50ZXIiIE1hcmdpbj0iNSI+DQogICAgICAgICAgICAgICAgICAgIDxCdXR0b24gTmFtZT0iU3RvcFN0YWNrQnV0dG9uIiBDb250ZW50PSJTdG9wIiBXaWR0aD0iNzUiIE1hcmdpbj0iNSIvPg0KICAgICAgICAgICAgICAgICAgICA8QnV0dG9uIE5hbWU9IlJlc3RhcnRTdGFja0J1dHRvbiIgQ29udGVudD0iUmVzdGFydCIgV2lkdGg9Ijc1IiBNYXJnaW49IjUiLz4NCiAgICAgICAgICAgICAgICAgICAgPEJ1dHRvbiBOYW1lPSJTdGFydFN0YWNrQnV0dG9uIiBDb250ZW50PSJTdGFydCIgV2lkdGg9Ijc1IiBNYXJnaW49IjUiLz4NCiAgICAgICAgICAgICAgICA8L1N0YWNrUGFuZWw+DQogICAgICAgICAgICA8L0dyaWQ+DQogICAgICAgIDwvR3JvdXBCb3g+DQoNCiAgICAgICAgPCEtLSBDb250YWluZXJzIEdyb3VwIEJveCAtLT4NCiAgICAgICAgPEdyb3VwQm94IEhlYWRlcj0iQ29udGFpbmVycyIgR3JpZC5Sb3c9IjAiIEdyaWQuQ29sdW1uPSIyIiBHcmlkLkNvbHVtblNwYW49IjIiIE1hcmdpbj0iMTAiPg0KICAgICAgICAgICAgPEdyaWQ+DQogICAgICAgICAgICAgICAgPEdyaWQuUm93RGVmaW5pdGlvbnM+DQogICAgICAgICAgICAgICAgICAgIDxSb3dEZWZpbml0aW9uIEhlaWdodD0iKiIvPg0KICAgICAgICAgICAgICAgICAgICA8IS0tIExpc3RCb3ggLS0+DQogICAgICAgICAgICAgICAgICAgIDxSb3dEZWZpbml0aW9uIEhlaWdodD0iQXV0byIvPg0KICAgICAgICAgICAgICAgICAgICA8IS0tIEJ1dHRvbnMgLS0+DQogICAgICAgICAgICAgICAgPC9HcmlkLlJvd0RlZmluaXRpb25zPg0KICAgICAgICAgICAgICAgIDwhLS0gTGlzdEJveCBmb3IgQ29udGFpbmVycyAtLT4NCiAgICAgICAgICAgICAgICA8TGlzdEJveCBOYW1lPSJDb250YWluZXJzTGlzdEJveCIgR3JpZC5Sb3c9IjAiIE1hcmdpbj0iNSI+DQogICAgICAgICAgICAgICAgICAgIDxMaXN0Qm94Lkl0ZW1UZW1wbGF0ZT4NCiAgICAgICAgICAgICAgICAgICAgICAgIDxEYXRhVGVtcGxhdGU+DQogICAgICAgICAgICAgICAgICAgICAgICAgICAgPFN0YWNrUGFuZWwgT3JpZW50YXRpb249Ikhvcml6b250YWwiPg0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA8VGV4dEJsb2NrIFRleHQ9IntCaW5kaW5nIE5hbWV9IiBXaWR0aD0iMTAwIi8+DQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDxUZXh0QmxvY2sgVGV4dD0ie0JpbmRpbmcgU3RhdGV9IiBXaWR0aD0iMTAwIi8+DQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDxUZXh0QmxvY2sgVGV4dD0ie0JpbmRpbmcgU3RhdHVzfSIgV2lkdGg9IjEwMCIvPg0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA8VGV4dEJsb2NrIFRleHQ9IntCaW5kaW5nIENyZWF0aW9uRGF0ZX0iIFdpZHRoPSIyMDAiLz4NCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPFRleHRCbG9jayBUZXh0PSJ7QmluZGluZyBJbWFnZX0iIFdpZHRoPSIyMDAiLz4NCiAgICAgICAgICAgICAgICAgICAgICAgICAgICA8L1N0YWNrUGFuZWw+DQogICAgICAgICAgICAgICAgICAgICAgICA8L0RhdGFUZW1wbGF0ZT4NCiAgICAgICAgICAgICAgICAgICAgPC9MaXN0Qm94Lkl0ZW1UZW1wbGF0ZT4NCiAgICAgICAgICAgICAgICA8L0xpc3RCb3g+DQogICAgICAgICAgICAgICAgPCEtLSBCdXR0b25zIC0tPg0KICAgICAgICAgICAgICAgIDxTdGFja1BhbmVsIEdyaWQuUm93PSIxIiBPcmllbnRhdGlvbj0iSG9yaXpvbnRhbCIgSG9yaXpvbnRhbEFsaWdubWVudD0iQ2VudGVyIiBNYXJnaW49IjUiPg0KICAgICAgICAgICAgICAgICAgICA8QnV0dG9uIE5hbWU9IlN0b3BDb250YWluZXJCdXR0b24iIENvbnRlbnQ9IlN0b3AiIFdpZHRoPSI3NSIgTWFyZ2luPSI1Ii8+DQogICAgICAgICAgICAgICAgICAgIDxCdXR0b24gTmFtZT0iU3RhcnRDb250YWluZXJCdXR0b24iIENvbnRlbnQ9IlN0YXJ0IiBXaWR0aD0iNzUiIE1hcmdpbj0iNSIvPg0KICAgICAgICAgICAgICAgICAgICA8QnV0dG9uIE5hbWU9IkRldGFpbHNDb250YWluZXJCdXR0b24iIENvbnRlbnQ9IkRldGFpbHMiIFdpZHRoPSI3NSIgTWFyZ2luPSI1Ii8+DQogICAgICAgICAgICAgICAgPC9TdGFja1BhbmVsPg0KICAgICAgICAgICAgPC9HcmlkPg0KICAgICAgICA8L0dyb3VwQm94Pg0KDQogICAgICAgIDwhLS0gTG9ncyBHcm91cCBCb3ggLS0+DQogICAgICAgIDxHcm91cEJveCBIZWFkZXI9IkxvZ3MiIEdyaWQuUm93PSIyIiBHcmlkLkNvbHVtbj0iMCIgR3JpZC5Db2x1bW5TcGFuPSI0IiBNYXJnaW49IjEwIj4NCiAgICAgICAgICAgIDxHcmlkPg0KICAgICAgICAgICAgICAgIDxHcmlkLkNvbHVtbkRlZmluaXRpb25zPg0KICAgICAgICAgICAgICAgICAgICA8Q29sdW1uRGVmaW5pdGlvbiBXaWR0aD0iKiIvPg0KICAgICAgICAgICAgICAgICAgICA8Q29sdW1uRGVmaW5pdGlvbiBXaWR0aD0iQXV0byIvPg0KICAgICAgICAgICAgICAgIDwvR3JpZC5Db2x1bW5EZWZpbml0aW9ucz4NCiAgICAgICAgICAgICAgICA8R3JpZC5Sb3dEZWZpbml0aW9ucz4NCiAgICAgICAgICAgICAgICAgICAgPFJvd0RlZmluaXRpb24gSGVpZ2h0PSJBdXRvIi8+DQogICAgICAgICAgICAgICAgICAgIDwhLS0gQ2hlY2tib3hlcyAtLT4NCiAgICAgICAgICAgICAgICAgICAgPFJvd0RlZmluaXRpb24gSGVpZ2h0PSIqIi8+DQogICAgICAgICAgICAgICAgICAgIDwhLS0gRWRpdEJveCAtLT4NCiAgICAgICAgICAgICAgICA8L0dyaWQuUm93RGVmaW5pdGlvbnM+DQogICAgICAgICAgICAgICAgPCEtLSBDaGVja2JveGVzIC0tPg0KICAgICAgICAgICAgICAgIDxTdGFja1BhbmVsIE9yaWVudGF0aW9uPSJIb3Jpem9udGFsIiBHcmlkLlJvdz0iMCIgTWFyZ2luPSI1IiBHcmlkLkNvbHVtblNwYW49IjIiPg0KICAgICAgICAgICAgICAgICAgICA8Q2hlY2tCb3ggTmFtZT0iRG9ja2VyTG9nc0NoZWNrQm94IiBDb250ZW50PSJEb2NrZXIiIE1hcmdpbj0iNSIgSXNDaGVja2VkPSJUcnVlIiBJc0VuYWJsZWQ9ImZhbHNlIiAvPg0KICAgICAgICAgICAgICAgICAgICA8Q2hlY2tCb3ggTmFtZT0iUG9ydGFpbmVyTG9nc0NoZWNrQm94IiBDb250ZW50PSJQb3J0YWluZXIiIE1hcmdpbj0iNSIgSXNDaGVja2VkPSJUcnVlIiBJc0VuYWJsZWQ9ImZhbHNlIi8+DQogICAgICAgICAgICAgICAgICAgIDxDaGVja0JveCBOYW1lPSJOZXR3b3JrTG9nc0NoZWNrQm94IiBDb250ZW50PSJOZXR3b3JrIiBNYXJnaW49IjUiIElzQ2hlY2tlZD0iVHJ1ZSIgSXNFbmFibGVkPSJmYWxzZSIvPg0KICAgICAgICAgICAgICAgIDwvU3RhY2tQYW5lbD4NCiAgICAgICAgICAgICAgICA8IS0tIEVkaXQgQm94IC0tPg0KICAgICAgICAgICAgICAgIDxUZXh0Qm94IE5hbWU9IkxvZ3NUZXh0Qm94IiBHcmlkLlJvdz0iMSIgTWFyZ2luPSI1IiBBY2NlcHRzUmV0dXJuPSJUcnVlIiBWZXJ0aWNhbFNjcm9sbEJhclZpc2liaWxpdHk9IlZpc2libGUiIFRleHRXcmFwcGluZz0iV3JhcCIgR3JpZC5Db2x1bW5TcGFuPSIyIi8+DQogICAgICAgICAgICA8L0dyaWQ+DQogICAgICAgIDwvR3JvdXBCb3g+DQoNCiAgICAgICAgPCEtLSBDbG9zZSBCdXR0b24gLS0+DQogICAgICAgIDxCdXR0b24gTmFtZT0iUmVzdGFydERvY2tlckJ1dHRvbiIgQ29udGVudD0i4oaVIERvY2tlciDihpUiIEdyaWQuUm93PSIzIiBHcmlkLkNvbHVtbj0iMiIgV2lkdGg9Ijc1IiBIZWlnaHQ9IjI1IiBIb3Jpem9udGFsQWxpZ25tZW50PSJMZWZ0IiBNYXJnaW49IjEwIi8+DQogICAgICAgIDxCdXR0b24gTmFtZT0iVXBkYXRlQWxsQnV0dG9uIiBDb250ZW50PSJVcGRhdGUgRm9ybSBEYXRhIiBHcmlkLlJvdz0iMyIgR3JpZC5Db2x1bW49IjIiIFdpZHRoPSI3NSIgSGVpZ2h0PSIyNSIgSG9yaXpvbnRhbEFsaWdubWVudD0iUmlnaHQiIE1hcmdpbj0iMTAiLz4NCiAgICAgICAgPCEtLSA8QnV0dG9uIE5hbWU9IlRlc3RCdXR0b24iIENvbnRlbnQ9IlRlc3QiIEdyaWQuUm93PSIzIiBHcmlkLkNvbHVtbj0iMyIgV2lkdGg9Ijc1IiBIZWlnaHQ9IjI1IiBIb3Jpem9udGFsQWxpZ25tZW50PSJMZWZ0IiBNYXJnaW49IjEwIi8+IC0tPg0KICAgICAgICA8QnV0dG9uIE5hbWU9IkNsb3NlQnV0dG9uIiBDb250ZW50PSJDbG9zZSIgR3JpZC5Sb3c9IjMiIEdyaWQuQ29sdW1uPSI0IiBXaWR0aD0iNzUiIEhlaWdodD0iMjUiIEhvcml6b250YWxBbGlnbm1lbnQ9IlJpZ2h0IiBNYXJnaW49IjEwIi8+DQogICAgPC9HcmlkPg0KPC9XaW5kb3c+DQo=" 
    $byteArray = [System.Convert]::FromBase64String($XamlFile_000)
    $content = [System.Text.Encoding]::UTF8.GetString($byteArray)
    Set-Content -Path "$TempFilePath" -Value $content
    Write-Verbose "Building UI from `"$TempFilePath`". UseEmbeddedXaml=$UseEmbeddedXaml"
    [xml]$xaml = Get-Content $TempFilePath 
}else{
    Write-Verbose "Building UI from `"$XAMLPath`". UseEmbeddedXaml=$UseEmbeddedXaml"
    [xml]$xaml = Get-Content $XAMLPath 
}

#Build the GUI

     
$reader=(New-Object System.Xml.XmlNodeReader $xaml)
$Window=[Windows.Markup.XamlReader]::Load( $reader )

#AutoFind all controls 
$xaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]")  | ForEach-Object {  
    New-Variable  -Name $_.Name -Value $Window.FindName($_.Name) -Force -Scope Global
    Write-Verbose "Variable named: Name $($_.Name)"
}


function Write-AppLog {
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
    Write-AppLog "Calling Invoke-PopulateContainersList" -Color Red
    $containers = $containers = Get-DockerContainersData
    $ContainersListBox.ItemsSource = $null
    $ContainersListBox.ItemsSource = $containers
    
}

function Invoke-PopulateStacksList {
    Write-AppLog "Calling Invoke-PopulateStacksList"
    $stacks = List-PortainerStacks | Select Name, Status, UpdateDate | Convert-PortainerStacks
    $StacksListBox.ItemsSource = $null
    $StacksListBox.ItemsSource = $stacks
}

function Invoke-RefreshUiLists {
    Write-AppLog "Calling Invoke-RefreshUiLists"
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
    Write-AppLog "[Invoke-StopContainerBtn] Selected:"
    Write-AppLog $selectedContainer
    
    if ($null -ne $selectedContainer) {
        $name = $selectedContainer[0].Name
        Write-AppLog "name $name"
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
        Write-AppLog "Selected Stack:" -Color Green
        Write-AppLog $selectedStack
    }
})

# Event Handler for Containers Selection
$ContainersListBox.add_SelectionChanged({
    $selectedContainer = $ContainersListBox.SelectedItem
    if ($null -ne $selectedContainer) {
        Write-AppLog "Selected Container:" -Color Green
        Write-AppLog $selectedContainer
    }
})


# Stack Button Handlers

# Stop Stack
$StopStackButton.Add_Click({
    $selectedStack = $StacksListBox.SelectedItem
    if ($null -ne $selectedStack) {
        $sname = $($selectedStack.Name)
        Write-AppLog "Restarting Stack: $($selectedStack.Name)" -Color Cyan
         List-PortainerStacks | Where Name -match $sname | Stop-PortainerStack
         Invoke-PopulateStacksList
    } else {
        Write-AppLog "No stack selected!" -Color Yellow
    }
})

# Restart Stack
$RestartStackButton.Add_Click({
    $selectedStack = $StacksListBox.SelectedItem
    if ($null -ne $selectedStack) {
        $sname = $($selectedStack.Name)
        Write-AppLog "Restarting Stack: $($selectedStack.Name)" -Color Cyan
         List-PortainerStacks | Where Name -match $sname | Stop-PortainerStack
         Start-Sleep 1
         List-PortainerStacks | Where Name -match $sname | Start-PortainerStack
         Invoke-PopulateStacksList
    } else {
        Write-AppLog "No stack selected!" -Color Yellow
    }
})
# Start Stack
$StartStackButton.Add_Click({
    $selectedStack = $StacksListBox.SelectedItem
    if ($null -ne $selectedStack) {
        Write-AppLog "Starting Stack: $($selectedStack.Name)" -Color Green
        $sname = $($selectedStack.Name)
        Write-AppLog "Restarting Stack: $($selectedStack.Name)" -Color Cyan
         List-PortainerStacks | Where Name -match $sname | Start-PortainerStack
    } else {
        Write-AppLog "No stack selected!" -Color Yellow
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
