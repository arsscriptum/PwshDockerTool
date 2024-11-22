#╔════════════════════════════════════════════════════════════════════════════════╗
#║                                                                                ║
#║   Start-DockerMgr.ps1                                                          ║
#║   Docker and Portainer GUI Application using the Docker PowerShell Module      ║
#║                                                                                ║
#╟────────────────────────────────────────────────────────────────────────────────╢
#║   Guillaume Plante <codegp@icloud.com>                                         ║
#║   Code licensed under the GNU GPL v3.0. See the LICENSE file for details.      ║
#╚════════════════════════════════════════════════════════════════════════════════╝

[CmdletBinding(SupportsShouldProcess)]
Param()

# ==================================================================
# Load Assemblies
# ==================================================================

[void][System.Reflection.Assembly]::LoadWithPartialName('PresentationFramework')
[void][System.Reflection.Assembly]::LoadWithPartialName('PresentationCore')
[void][System.Reflection.Assembly]::LoadWithPartialName('WindowsBase')
[void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
[void][System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')
[void][System.Reflection.Assembly]::LoadWithPartialName('System')
[void][System.Reflection.Assembly]::LoadWithPartialName('System.Xml')
[void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows')


# ==================================================================
# Script Variables
# ==================================================================

[string]$Script:XAMLPath                = "$PSScriptRoot\MainWindow.xaml"
[bool]$Script:UseEmbeddedXaml           = $True
[string]$Script:SelectedContainerName   = ""
[string]$Script:SelectedStackName       = ""


function Initialize-ProgressWndScript{
    [CmdletBinding(SupportsShouldProcess)]
    param ()
    $ProgressScript = "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"

    # Take my B64 string and do a Base64 to Byte array conversion of compressed data
    $ScriptBlockCompressed = [System.Convert]::FromBase64String($ProgressScript)

    # Then decompress script's data
    $InputStream = New-Object System.IO.MemoryStream(, $ScriptBlockCompressed)
    $GzipStream = New-Object System.IO.Compression.GzipStream $InputStream, ([System.IO.Compression.CompressionMode]::Decompress)
    $StreamReader = New-Object System.IO.StreamReader($GzipStream)
    $ScriptBlockDecompressed = $StreamReader.ReadToEnd()
    # And close the streams
    $GzipStream.Close()
    $InputStream.Close()

    $ScriptBlockDecompressed
}

$Script = Initialize-ProgressWndScript
Invoke-Expression $Script
#[string]$ProgressWndScript = (Resolve-Path "$PSScriptRoot\ProgressWnd.ps1").Path
#. "$ProgressWndScript"

Initialize-ProgressDialog

# ==================================================================
# Create the [xml] object from the xaml definition file.
# ==================================================================

if($Script:UseEmbeddedXaml){
    $TempFilePath = "$ENV:Temp\ui.xaml"
    $Script:ObjectXamlFile_000 = "77u/PFdpbmRvdyB4bWxucz0iaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93aW5meC8yMDA2L3hhbWwvcHJlc2VudGF0aW9uIg0KICAgICAgICB4bWxuczp4PSJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dpbmZ4LzIwMDYveGFtbCINCiAgICAgICAgVGl0bGU9IlBvcnRhaW5lciBhbmQgRG9ja2VyIE1hbmFnZXIiDQogICAgICAgIEhlaWdodD0iNjQwIiBXaWR0aD0iOTAwIiBXaW5kb3dTdGFydHVwTG9jYXRpb249IkNlbnRlclNjcmVlbiIgUmVzaXplTW9kZT0iTm9SZXNpemUiIFdpbmRvd1N0eWxlPSJTaW5nbGVCb3JkZXJXaW5kb3ciPg0KICAgIDxHcmlkIFJlbmRlclRyYW5zZm9ybU9yaWdpbj0iMC41LDAuNSIgTWFyZ2luPSIwLDAsMCwzNiI+DQogICAgICAgIDwhLS0gRGVmaW5lIExheW91dCB3aXRoIFJvd3MgYW5kIENvbHVtbnMgLS0+DQogICAgICAgIDxHcmlkLlJvd0RlZmluaXRpb25zPg0KICAgICAgICAgICAgPFJvd0RlZmluaXRpb24gSGVpZ2h0PSJBdXRvIi8+DQogICAgICAgICAgICA8IS0tIEdyb3VwIEJveGVzIC0tPg0KICAgICAgICAgICAgPFJvd0RlZmluaXRpb24gSGVpZ2h0PSJBdXRvIi8+DQogICAgICAgICAgICA8IS0tIEdyb3VwIEJveGVzIC0tPg0KICAgICAgICAgICAgPFJvd0RlZmluaXRpb24gSGVpZ2h0PSIqIi8+DQogICAgICAgICAgICA8IS0tIExvZ3MgLS0+DQogICAgICAgICAgICA8Um93RGVmaW5pdGlvbiBIZWlnaHQ9IkF1dG8iLz4NCiAgICAgICAgICAgIDwhLS0gQ2xvc2UgQnV0dG9uIC0tPg0KICAgICAgICA8L0dyaWQuUm93RGVmaW5pdGlvbnM+DQogICAgICAgIDxHcmlkLkNvbHVtbkRlZmluaXRpb25zPg0KICAgICAgICAgICAgPENvbHVtbkRlZmluaXRpb24gV2lkdGg9IjIuNSoiIC8+DQogICAgICAgICAgICA8Q29sdW1uRGVmaW5pdGlvbiBXaWR0aD0iMi41KiIgLz4NCiAgICAgICAgICAgIDxDb2x1bW5EZWZpbml0aW9uIFdpZHRoPSIyLjUqIiAvPg0KICAgICAgICAgICAgPENvbHVtbkRlZmluaXRpb24gV2lkdGg9IjIuNSoiIC8+DQogICAgICAgIDwvR3JpZC5Db2x1bW5EZWZpbml0aW9ucz4NCg0KICAgICAgICA8IS0tIFN0YWNrcyBHcm91cCBCb3ggLS0+DQogICAgICAgIDxHcm91cEJveCBIZWFkZXI9IlN0YWNrcyIgR3JpZC5Sb3c9IjAiIEdyaWQuQ29sdW1uPSIwIiBHcmlkLkNvbHVtblNwYW49IjIiIE1hcmdpbj0iMTAiPg0KICAgICAgICAgICAgPEdyaWQ+DQogICAgICAgICAgICAgICAgPEdyaWQuUm93RGVmaW5pdGlvbnM+DQogICAgICAgICAgICAgICAgICAgIDxSb3dEZWZpbml0aW9uIEhlaWdodD0iKiIvPg0KICAgICAgICAgICAgICAgICAgICA8IS0tIExpc3RCb3ggLS0+DQogICAgICAgICAgICAgICAgICAgIDxSb3dEZWZpbml0aW9uIEhlaWdodD0iQXV0byIvPg0KICAgICAgICAgICAgICAgICAgICA8IS0tIEJ1dHRvbnMgLS0+DQogICAgICAgICAgICAgICAgPC9HcmlkLlJvd0RlZmluaXRpb25zPg0KICAgICAgICAgICAgICAgIDwhLS0gTGlzdEJveCBmb3IgU3RhY2tzIC0tPg0KICAgICAgICAgICAgICAgIDxMaXN0Qm94IE5hbWU9IlN0YWNrc0xpc3RCb3giIEdyaWQuUm93PSIwIiBNYXJnaW49IjUiPg0KICAgICAgICAgICAgICAgICAgICA8TGlzdEJveC5JdGVtVGVtcGxhdGU+DQogICAgICAgICAgICAgICAgICAgICAgICA8RGF0YVRlbXBsYXRlPg0KICAgICAgICAgICAgICAgICAgICAgICAgICAgIDxTdGFja1BhbmVsIE9yaWVudGF0aW9uPSJIb3Jpem9udGFsIj4NCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPFRleHRCbG9jayBUZXh0PSJ7QmluZGluZyBOYW1lfSIgV2lkdGg9IjEwMCIvPg0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA8VGV4dEJsb2NrIFRleHQ9IntCaW5kaW5nIFN0YXR1c30iIFdpZHRoPSIxMDAiLz4NCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPFRleHRCbG9jayBUZXh0PSJ7QmluZGluZyBVcGRhdGVEYXRlfSIgV2lkdGg9IjEwMCIvPg0KICAgICAgICAgICAgICAgICAgICAgICAgICAgIDwvU3RhY2tQYW5lbD4NCiAgICAgICAgICAgICAgICAgICAgICAgIDwvRGF0YVRlbXBsYXRlPg0KICAgICAgICAgICAgICAgICAgICA8L0xpc3RCb3guSXRlbVRlbXBsYXRlPg0KICAgICAgICAgICAgICAgIDwvTGlzdEJveD4NCiAgICAgICAgICAgICAgICA8IS0tIEJ1dHRvbnMgLS0+DQogICAgICAgICAgICAgICAgPFN0YWNrUGFuZWwgR3JpZC5Sb3c9IjEiIE9yaWVudGF0aW9uPSJIb3Jpem9udGFsIiBIb3Jpem9udGFsQWxpZ25tZW50PSJDZW50ZXIiIE1hcmdpbj0iNSI+DQogICAgICAgICAgICAgICAgICAgIDxCdXR0b24gTmFtZT0iU3RvcFN0YWNrQnV0dG9uIiBDb250ZW50PSJTdG9wIiBXaWR0aD0iNzUiIE1hcmdpbj0iNSIvPg0KICAgICAgICAgICAgICAgICAgICA8QnV0dG9uIE5hbWU9IlJlc3RhcnRTdGFja0J1dHRvbiIgQ29udGVudD0iUmVzdGFydCIgV2lkdGg9Ijc1IiBNYXJnaW49IjUiLz4NCiAgICAgICAgICAgICAgICAgICAgPEJ1dHRvbiBOYW1lPSJTdGFydFN0YWNrQnV0dG9uIiBDb250ZW50PSJTdGFydCIgV2lkdGg9Ijc1IiBNYXJnaW49IjUiLz4NCiAgICAgICAgICAgICAgICA8L1N0YWNrUGFuZWw+DQogICAgICAgICAgICA8L0dyaWQ+DQogICAgICAgIDwvR3JvdXBCb3g+DQoNCiAgICAgICAgPCEtLSBDb250YWluZXJzIEdyb3VwIEJveCAtLT4NCiAgICAgICAgPEdyb3VwQm94IEhlYWRlcj0iQ29udGFpbmVycyIgR3JpZC5Sb3c9IjAiIEdyaWQuQ29sdW1uPSIyIiBHcmlkLkNvbHVtblNwYW49IjIiIE1hcmdpbj0iMTAiPg0KICAgICAgICAgICAgPEdyaWQ+DQogICAgICAgICAgICAgICAgPEdyaWQuUm93RGVmaW5pdGlvbnM+DQogICAgICAgICAgICAgICAgICAgIDxSb3dEZWZpbml0aW9uIEhlaWdodD0iKiIvPg0KICAgICAgICAgICAgICAgICAgICA8IS0tIExpc3RCb3ggLS0+DQogICAgICAgICAgICAgICAgICAgIDxSb3dEZWZpbml0aW9uIEhlaWdodD0iQXV0byIvPg0KICAgICAgICAgICAgICAgICAgICA8IS0tIEJ1dHRvbnMgLS0+DQogICAgICAgICAgICAgICAgPC9HcmlkLlJvd0RlZmluaXRpb25zPg0KICAgICAgICAgICAgICAgIDwhLS0gTGlzdEJveCBmb3IgQ29udGFpbmVycyAtLT4NCiAgICAgICAgICAgICAgICA8TGlzdEJveCBOYW1lPSJDb250YWluZXJzTGlzdEJveCIgR3JpZC5Sb3c9IjAiIE1hcmdpbj0iNSI+DQogICAgICAgICAgICAgICAgICAgIDxMaXN0Qm94Lkl0ZW1UZW1wbGF0ZT4NCiAgICAgICAgICAgICAgICAgICAgICAgIDxEYXRhVGVtcGxhdGU+DQogICAgICAgICAgICAgICAgICAgICAgICAgICAgPFN0YWNrUGFuZWwgT3JpZW50YXRpb249Ikhvcml6b250YWwiPg0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA8VGV4dEJsb2NrIFRleHQ9IntCaW5kaW5nIE5hbWV9IiBXaWR0aD0iMTAwIi8+DQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDxUZXh0QmxvY2sgVGV4dD0ie0JpbmRpbmcgU3RhdGV9IiBXaWR0aD0iMTAwIi8+DQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDxUZXh0QmxvY2sgVGV4dD0ie0JpbmRpbmcgU3RhdHVzfSIgV2lkdGg9IjEwMCIvPg0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA8VGV4dEJsb2NrIFRleHQ9IntCaW5kaW5nIENyZWF0aW9uRGF0ZX0iIFdpZHRoPSIyMDAiLz4NCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPFRleHRCbG9jayBUZXh0PSJ7QmluZGluZyBJbWFnZX0iIFdpZHRoPSIyMDAiLz4NCiAgICAgICAgICAgICAgICAgICAgICAgICAgICA8L1N0YWNrUGFuZWw+DQogICAgICAgICAgICAgICAgICAgICAgICA8L0RhdGFUZW1wbGF0ZT4NCiAgICAgICAgICAgICAgICAgICAgPC9MaXN0Qm94Lkl0ZW1UZW1wbGF0ZT4NCiAgICAgICAgICAgICAgICA8L0xpc3RCb3g+DQogICAgICAgICAgICAgICAgPCEtLSBCdXR0b25zIC0tPg0KICAgICAgICAgICAgICAgIDxTdGFja1BhbmVsIEdyaWQuUm93PSIxIiBPcmllbnRhdGlvbj0iSG9yaXpvbnRhbCIgSG9yaXpvbnRhbEFsaWdubWVudD0iQ2VudGVyIiBNYXJnaW49IjUiPg0KICAgICAgICAgICAgICAgICAgICA8QnV0dG9uIE5hbWU9IlN0b3BDb250YWluZXJCdXR0b24iIENvbnRlbnQ9IlN0b3AiIFdpZHRoPSI3NSIgTWFyZ2luPSI1Ii8+DQogICAgICAgICAgICAgICAgICAgIDxCdXR0b24gTmFtZT0iU3RhcnRDb250YWluZXJCdXR0b24iIENvbnRlbnQ9IlN0YXJ0IiBXaWR0aD0iNzUiIE1hcmdpbj0iNSIvPg0KICAgICAgICAgICAgICAgICAgICA8QnV0dG9uIE5hbWU9IkRldGFpbHNDb250YWluZXJCdXR0b24iIENvbnRlbnQ9IkRldGFpbHMiIFdpZHRoPSI3NSIgTWFyZ2luPSI1Ii8+DQogICAgICAgICAgICAgICAgPC9TdGFja1BhbmVsPg0KICAgICAgICAgICAgPC9HcmlkPg0KICAgICAgICA8L0dyb3VwQm94Pg0KDQogICAgICAgIDwhLS0gTG9ncyBHcm91cCBCb3ggLS0+DQogICAgICAgIDxHcm91cEJveCBIZWFkZXI9IkxvZ3MiIEdyaWQuUm93PSIyIiBHcmlkLkNvbHVtbj0iMCIgR3JpZC5Db2x1bW5TcGFuPSI0IiBNYXJnaW49IjEwIj4NCiAgICAgICAgICAgIDxHcmlkPg0KICAgICAgICAgICAgICAgIDxHcmlkLkNvbHVtbkRlZmluaXRpb25zPg0KICAgICAgICAgICAgICAgICAgICA8Q29sdW1uRGVmaW5pdGlvbiBXaWR0aD0iKiIvPg0KICAgICAgICAgICAgICAgICAgICA8Q29sdW1uRGVmaW5pdGlvbiBXaWR0aD0iQXV0byIvPg0KICAgICAgICAgICAgICAgIDwvR3JpZC5Db2x1bW5EZWZpbml0aW9ucz4NCiAgICAgICAgICAgICAgICA8R3JpZC5Sb3dEZWZpbml0aW9ucz4NCiAgICAgICAgICAgICAgICAgICAgPFJvd0RlZmluaXRpb24gSGVpZ2h0PSJBdXRvIi8+DQogICAgICAgICAgICAgICAgICAgIDwhLS0gQ2hlY2tib3hlcyAtLT4NCiAgICAgICAgICAgICAgICAgICAgPFJvd0RlZmluaXRpb24gSGVpZ2h0PSIqIi8+DQogICAgICAgICAgICAgICAgICAgIDwhLS0gRWRpdEJveCAtLT4NCiAgICAgICAgICAgICAgICA8L0dyaWQuUm93RGVmaW5pdGlvbnM+DQogICAgICAgICAgICAgICAgPCEtLSBDaGVja2JveGVzIC0tPg0KICAgICAgICAgICAgICAgIDxTdGFja1BhbmVsIE9yaWVudGF0aW9uPSJIb3Jpem9udGFsIiBHcmlkLlJvdz0iMCIgTWFyZ2luPSI1IiBHcmlkLkNvbHVtblNwYW49IjIiPg0KICAgICAgICAgICAgICAgICAgICA8Q2hlY2tCb3ggTmFtZT0iRG9ja2VyTG9nc0NoZWNrQm94IiBDb250ZW50PSJEb2NrZXIiIE1hcmdpbj0iNSIgSXNDaGVja2VkPSJUcnVlIiBJc0VuYWJsZWQ9ImZhbHNlIiAvPg0KICAgICAgICAgICAgICAgICAgICA8Q2hlY2tCb3ggTmFtZT0iUG9ydGFpbmVyTG9nc0NoZWNrQm94IiBDb250ZW50PSJQb3J0YWluZXIiIE1hcmdpbj0iNSIgSXNDaGVja2VkPSJUcnVlIiBJc0VuYWJsZWQ9ImZhbHNlIi8+DQogICAgICAgICAgICAgICAgICAgIDxDaGVja0JveCBOYW1lPSJOZXR3b3JrTG9nc0NoZWNrQm94IiBDb250ZW50PSJOZXR3b3JrIiBNYXJnaW49IjUiIElzQ2hlY2tlZD0iVHJ1ZSIgSXNFbmFibGVkPSJmYWxzZSIvPg0KICAgICAgICAgICAgICAgIDwvU3RhY2tQYW5lbD4NCiAgICAgICAgICAgICAgICA8IS0tIEVkaXQgQm94IC0tPg0KICAgICAgICAgICAgICAgIDxUZXh0Qm94IE5hbWU9IkxvZ3NUZXh0Qm94IiBHcmlkLlJvdz0iMSIgTWFyZ2luPSI1IiBBY2NlcHRzUmV0dXJuPSJUcnVlIiBWZXJ0aWNhbFNjcm9sbEJhclZpc2liaWxpdHk9IlZpc2libGUiIFRleHRXcmFwcGluZz0iV3JhcCIgR3JpZC5Db2x1bW5TcGFuPSIyIi8+DQogICAgICAgICAgICA8L0dyaWQ+DQogICAgICAgIDwvR3JvdXBCb3g+DQoNCiAgICAgICAgPCEtLSBDbG9zZSBCdXR0b24gLS0+DQogICAgICAgIDxCdXR0b24gTmFtZT0iUmVzdGFydERvY2tlckJ1dHRvbiIgQ29udGVudD0i4oaVIERvY2tlciDihpUiIEdyaWQuUm93PSIzIiBHcmlkLkNvbHVtbj0iMiIgV2lkdGg9Ijc1IiBIZWlnaHQ9IjI1IiBIb3Jpem9udGFsQWxpZ25tZW50PSJMZWZ0IiBNYXJnaW49IjEwIi8+DQogICAgICAgIDxCdXR0b24gTmFtZT0iVXBkYXRlQWxsQnV0dG9uIiBDb250ZW50PSJVcGRhdGUgRm9ybSBEYXRhIiBHcmlkLlJvdz0iMyIgR3JpZC5Db2x1bW49IjIiIFdpZHRoPSI3NSIgSGVpZ2h0PSIyNSIgSG9yaXpvbnRhbEFsaWdubWVudD0iUmlnaHQiIE1hcmdpbj0iMTAiLz4NCiAgICAgICAgPCEtLSA8QnV0dG9uIE5hbWU9IlRlc3RCdXR0b24iIENvbnRlbnQ9IlRlc3QiIEdyaWQuUm93PSIzIiBHcmlkLkNvbHVtbj0iMyIgV2lkdGg9Ijc1IiBIZWlnaHQ9IjI1IiBIb3Jpem9udGFsQWxpZ25tZW50PSJMZWZ0IiBNYXJnaW49IjEwIi8+IC0tPg0KICAgICAgICA8QnV0dG9uIE5hbWU9IkNsb3NlQnV0dG9uIiBDb250ZW50PSJDbG9zZSIgR3JpZC5Sb3c9IjMiIEdyaWQuQ29sdW1uPSI0IiBXaWR0aD0iNzUiIEhlaWdodD0iMjUiIEhvcml6b250YWxBbGlnbm1lbnQ9IlJpZ2h0IiBNYXJnaW49IjEwIi8+DQogICAgPC9HcmlkPg0KPC9XaW5kb3c+DQo=" 
    $byteArray = [System.Convert]::FromBase64String($Script:ObjectXamlFile_000)
    $content = [System.Text.Encoding]::UTF8.GetString($byteArray)
    Set-Content -Path "$TempFilePath" -Value $content
    Write-Verbose "Building UI from `"$TempFilePath`". UseEmbeddedXaml=$Script:UseEmbeddedXaml"
    [xml]$Script:ObjectXaml = Get-Content $TempFilePath 
}else{
    Write-Verbose "Building UI from `"$Script:XAMLPath`". UseEmbeddedXaml=$Script:UseEmbeddedXaml"
    [xml]$Script:ObjectXaml = Get-Content $Script:XAMLPath 
}


# ==================================================================
# Build the GUI
# ==================================================================

$reader=[System.Xml.XmlNodeReader]::new($Script:ObjectXaml)
$Script:WndApp=[Windows.Markup.XamlReader]::Load( $reader )

# ==================================================================
# Create Variables based on Controls defined in the xaml
# ==================================================================

$Script:ObjectXaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]")  | ForEach-Object {  
    New-Variable  -Name $_.Name -Value $Script:WndApp.FindName($_.Name) -Force -Scope Global
    Write-Verbose "Variable named: Name $($_.Name)"
}

function Show-ObjectTree {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
        [Object]$RootObject,
        [Parameter(Mandatory = $False)]
        [string]$RootObjectName = "Root"
    )

    # Recursive helper function to add object nodes to the TreeView
    function Add-Node {
        param (
            [System.Windows.Forms.TreeNode]$ParentNode,
            [string]$Key,
            [Object]$Value
        )

        if($Value -eq $Null){
            $node = New-Object System.Windows.Forms.TreeNode
            $node.Text = "$Key`: NULL"
            [void]$ParentNode.Nodes.Add($node)
            return
        }
        $type = $Value.GetType()

        if ($Value -is [PSCustomObject]) {
            # Handle PSCustomObject (key-value pairs)
            $node = New-Object System.Windows.Forms.TreeNode
            $node.Text = "$Key`: (Object)"
            [void]$ParentNode.Nodes.Add($node)

            $Value.PSObject.Properties | ForEach-Object {
                Add-Node $node $_.Name $_.Value
            }
        }
        elseif ($Value -is [Hashtable]) {
            # Handle Hashtable (key-value pairs)
            $node = New-Object System.Windows.Forms.TreeNode
            $node.Text = "$Key`: (Hashtable)"
            [void]$ParentNode.Nodes.Add($node)

            $Value.GetEnumerator() | ForEach-Object {
                Add-Node $node $_.Key $_.Value
            }
        }
        elseif ($Value -is [System.Collections.ArrayList] -or $Value -is [Array]) {
            # Handle arrays and ArrayLists
            $node = New-Object System.Windows.Forms.TreeNode
            $node.Text = "$Key`: (Array)"
            [void]$ParentNode.Nodes.Add($node)

            for ($i = 0; $i -lt $Value.Count; $i++) {
                Add-Node $node "[$i]" $Value[$i]
            }
        }
        else {
            # Handle primitive values
            $node = New-Object System.Windows.Forms.TreeNode
            $node.Text = "$Key`: $Value [$type]"
            [void]$ParentNode.Nodes.Add($node)
        }
    }

    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $Form = New-Object System.Windows.Forms.Form
    $Form.Text = "docker inspect $RootObjectName"
    [int]$TreeViewWndHeight = 640
    [int]$TreeViewWndWidth = 480
    $Form.Size = New-Object System.Drawing.Size($TreeViewWndHeight, $TreeViewWndWidth)
    # Set the properties
    $Form.StartPosition = "CenterScreen" # Set the startup location
    $Form.FormBorderStyle = "FixedSingle" # Set the border style to SingleBorderWindow
    $Form.MaximizeBox = $false          # Prevent resizing (disables the maximize button)
    $TreeView = New-Object System.Windows.Forms.TreeView
    $TreeView.Location = New-Object System.Drawing.Point(10, 10)
    $TreeView.Size = New-Object System.Drawing.Size(($TreeViewWndHeight-30), ($TreeViewWndWidth - 50))
    $Form.Controls.Add($TreeView)

    # Create the root node
    $rootNode = New-Object System.Windows.Forms.TreeNode
    $rootNode.Text = "$RootObjectName"
    [void]$TreeView.Nodes.Add($rootNode)

    # Add the object structure to the TreeView
    if ($RootObject -is [PSCustomObject]) {
        $RootObject.PSObject.Properties | ForEach-Object {
            Add-Node $rootNode $_.Name $_.Value
        }
    }
    elseif ($RootObject -is [Hashtable]) {
        $RootObject.GetEnumerator() | ForEach-Object {
            Add-Node $rootNode $_.Key $_.Value
        }
    }
    elseif ($RootObject -is [System.Collections.ArrayList] -or $RootObject -is [Array]) {
        for ($i = 0; $i -lt $RootObject.Count; $i++) {
            Add-Node $rootNode "[$i]" $RootObject[$i]
        }
    }
    else {
        Add-Node $rootNode "Value" $RootObject
    }

    $rootNode.Expand()

    $Form.Add_Shown({$Form.Activate()})
    [void]$Form.ShowDialog()

    $Form.Dispose()
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

    if($LogsTextBox -eq $Null){
        Write-Host "[DockerMgr] " -f DarkCyan -NoNewLine
        $currentBackground = $Host.UI.RawUI.BackgroundColor
        $currentColor = $Host.UI.RawUI.ForegroundColor
        if($Color -eq $currentBackground){
            Write-Host "$Message" -f $currentColor
        }else{
            Write-Host "$Message" -f $Color
        }
    }else{
        # Add the log message to the LogsTextBox
        $LogsTextBox.Dispatcher.Invoke({
            $run = New-Object Windows.Documents.Run $Message
            $run.Foreground = [System.Windows.Media.Brushes]::$Color
            $LogsTextBox.AppendText("$Message`n")
            $LogsTextBox.ScrollToEnd()
        })
    }
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
        $ContainerName = $name[0]
        $SshExe = (Get-Command 'ssh.exe').Source
        $TmpDockerLogFile = "$ENV:Temp\docker.json"
        $id = Show-ProgressDialogAsync -Verbose
        Write-AppLog "`"$SshExe`" 'mini' 'docker' 'inspect' `"$Script:SelectedContainerName`" > `"$TmpDockerLogFile`"" -Color Yellow
        &"$SshExe" 'mini' 'docker' 'inspect' "$Script:SelectedContainerName" > "$TmpDockerLogFile"
        Write-AppLog "Writing to `"$TmpDockerLogFile`""
        $JsonData = Get-Content -Path "$TmpDockerLogFile" | ConvertFrom-Json
        Write-AppLog "Generating TreeView..." -Color Red
        Close-ProgressDialogAsync $id
        Show-ObjectTree $JsonData -RootObjectName $SelectedContainerName
    }
}

function Invoke-RestartDockerButton{

    $SshExe = (Get-Command 'ssh.exe').Source
    $result = [System.Windows.Forms.MessageBox]::Show( "Do you want to restart the Docker Service on server 'mini' ?", "Docker Service Restart Confirmation", [System.Windows.Forms.MessageBoxButtons]::YesNo,[System.Windows.Forms.MessageBoxIcon]::Warning)
    if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
        Write-AppLog "`"$SshExe`" 'miniautoroot' 'systemctl restart snap.docker.dockerd.service'" -f Red
        $id = Show-ProgressDialogAsync "Restarting Docker" -Verbose
        &"$SshExe" 'miniautoroot' 'systemctl restart snap.docker.dockerd.service'
        Close-ProgressDialogAsync $id
    } else {
        Write-AppLog "Operation cancelled by the user."
    }
}

function Invoke-UpdateAllButton{
    Invoke-RefreshUiLists
}


$StacksListBox.add_SelectionChanged({
    $selectedStack = $StacksListBox.SelectedItem
    if ($null -ne $selectedStack) {
        $Script:SelectedStackName = $selectedStack.Name 
        Write-AppLog "Selected Stack`: $Script:SelectedStackName" -Color Green
        Write-AppLog $selectedStack
    }
})

# Event Handler for Containers Selection
$ContainersListBox.add_SelectionChanged({
    $selectedContainer = $ContainersListBox.SelectedItem
    if ($null -ne $selectedContainer) {
        $Script:SelectedContainerName = $selectedContainer.Name 
        Write-AppLog "Selected Container`: $Script:SelectedContainerName" -Color Green
        Write-AppLog $selectedContainer
    }
})


# Stack Button Handlers

# Stop Stack
$StopStackButton.Add_Click({
    $selectedStack = $StacksListBox.SelectedItem
    if ($null -ne $selectedStack) {
        $sname = $($selectedStack.Name)
        $id = Show-ProgressDialogAsync -Verbose
        Write-AppLog "Restarting Stack: $($selectedStack.Name)" -Color Cyan
        List-PortainerStacks | Where Name -match $sname | Stop-PortainerStack
        Invoke-PopulateStacksList
        Close-ProgressDialogAsync $id
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
        $id = Show-ProgressDialogAsync "Restarting $sname" -Verbose
        List-PortainerStacks | Where Name -match $sname | Stop-PortainerStack
        Start-Sleep 1
        List-PortainerStacks | Where Name -match $sname | Start-PortainerStack
        Invoke-PopulateStacksList
        Close-ProgressDialogAsync $id
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
        $id = Show-ProgressDialogAsync -Verbose
        List-PortainerStacks | Where Name -match $sname | Start-PortainerStack
        Close-ProgressDialogAsync $id
    } else {
        Write-AppLog "No stack selected!" -Color Yellow
    }
})
$RestartDockerButton = $Script:WndApp.FindName("RestartDockerButton")
$CloseButton = $Script:WndApp.FindName("CloseButton")
$UpdateAllButton = $Script:WndApp.FindName("UpdateAllButton")
# Button Click Handlers
$StartContainerButton.Add_Click({Invoke-StartContainerBtn})

$RestartDockerButton.Add_Click({Invoke-RestartDockerButton})
$UpdateAllButton.Add_Click({Invoke-TestBlocking})

$StopContainerButton.Add_Click({Invoke-StopContainerBtn})
$DetailsContainerButton.Add_Click({Invoke-ShowDetailsContainerBtn})
  
$CloseButton.Add_Click({ $Script:WndApp.Close() })
Invoke-RefreshUiLists
$Script:WndApp.ShowDialog() | Out-Null

