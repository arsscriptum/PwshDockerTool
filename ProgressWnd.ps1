
function Convert-Base64CompressedToBinaryFile {
    [CmdletBinding(SupportsShouldProcess)]
    Param( 
        [Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $True)]
        [ValidateNotNullOrEmpty()]
        [string]$String,
        [Parameter(Mandatory = $True, Position = 1, ValueFromPipeline = $True)]
        [ValidateNotNullOrEmpty()]
        [string]$Path        
    )
    try{
        try{
            New-Item -Path "$Path" -ItemType File -Force -ErrorAction Stop | Out-Null
        }catch{
            throw "cant create file in  path $Path"
        }
        # Base64 to Byte array of compressed data
        $Datacompressed = [System.Convert]::FromBase64String($String)

        # Decompress data
        $InputStream = New-Object System.IO.MemoryStream(, $Datacompressed)
        $MemoryStream = New-Object System.IO.MemoryStream
        $GzipStream = New-Object System.IO.Compression.GzipStream $InputStream, ([System.IO.Compression.CompressionMode]::Decompress)
        $GzipStream.CopyTo($MemoryStream)
        $GzipStream.Close()
        $MemoryStream.Close()
        $InputStream.Close()
        [Byte[]] $Bytes = $MemoryStream.ToArray()
        [System.IO.File]::WriteAllBytes("$Path",$Bytes)
    }catch{
        Write-Error "$_"
    }
}

function Initialize-ProgressDialog {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Position = 0, Mandatory = $False)]
        [string]$Path = "$ENV:Temp\loading.gif"
    )

    if(-not(Test-Path -Path "$Path" -PathType Leaf)){
        Restore-GifFromBase64 $Path
        Write-Host "[ProgressDialogAsync] Wrote `"$Path`""
    }else{
        Write-Host "[ProgressDialogAsync] Already Exists`: `"$Path`""
    }
}

function Restore-GifFromBase64 {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Position = 0, Mandatory = $true)]
        [string]$Path
    )

    $LoadingGif_1 = "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"
    $LoadingGif_2 = "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"

    $Base64Gif = "{0}{1}" -f $LoadingGif_1, $LoadingGif_2
    Convert-Base64CompressedToBinaryFile -String $Base64Gif -Path $Path
}


# Function to show a progress dialog asynchronously
function Show-ProgressDialogAsync {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Position = 0, Mandatory = $false)]
        [string]$Message = ""
    )
    [string]$TmpJobFile = "$ENV:Temp\psjob.tmp"
    [string]$TmpGifFile = "$ENV:Temp\loading.gif"
    [string[]]$ArgumentsList = $Message, $TmpGifFile, $TmpJobFile
    # Start a job to run the dialog
    $ProgressJob = Start-Job -ScriptBlock {
        param ([string]$Message,[string]$ImgPath,[string]$JobFilePath)

        Set-Content $JobFilePath -Value 1
        # Load required assemblies
        Add-Type -AssemblyName System.Windows.Forms
        Add-Type -AssemblyName System.Drawing

        # Create the form
        $Form = New-Object System.Windows.Forms.Form
   
        $Form.Text = ""
        $Form.Size = New-Object System.Drawing.Size(230, 160)
        $Form.StartPosition = "CenterScreen"
        $Form.FormBorderStyle = "FixedDialog"
        $Form.ControlBox = $false
        $Form.TopMost = $true

        # Add a label to display the message
        $Label = New-Object System.Windows.Forms.Label
        $Label.Text = "Please Wait..."
        $Label.AutoSize = $true
        $Label.Location = New-Object System.Drawing.Point(60, 50)

        # Set the font to Consolas, size 22, and bold
        $Label.Font = New-Object System.Drawing.Font("Consolas", 12, [System.Drawing.FontStyle]::Bold)

        $Form.Controls.Add($Label)

        $Label1 = New-Object System.Windows.Forms.Label
        $Label1.Text = $Message
        $Label1.AutoSize = $true
        $Label1.Location = New-Object System.Drawing.Point(15, 85)

        # Set the font to Consolas, size 22, and bold
        $Label1.Font = New-Object System.Drawing.Font("Consolas", 12, [System.Drawing.FontStyle]::Italic)

        $Form.Controls.Add($Label1)


        # Add a PictureBox for the animated GIF
        $PictureBox = New-Object System.Windows.Forms.PictureBox
        $PictureBox.Size = New-Object System.Drawing.Size(32, 32)
        $PictureBox.Location = New-Object System.Drawing.Point(19, 39)
        $PictureBox.SizeMode = "StretchImage"

        # Set the GIF image (ensure the path is correct)
        $PictureBox.Image = [System.Drawing.Image]::FromFile($ImgPath)
        $Form.Controls.Add($PictureBox)

        # Show the dialog
        Write-Host "[ProgressDialogAsync] Showing Dialog..."
        $Form.Show()

        # Periodically check the ShouldStop flag
        while ((Get-Content $JobFilePath) -eq '1') {
            [System.Windows.Forms.Application]::DoEvents()
            Start-Sleep -Milliseconds 200
        }
        Write-Host "[ProgressDialogAsync] Closing Dialog..."

        # Close the form when ShouldStop is true
        $Form.Invoke({ $Form.Close() })
    } -ArgumentList $ArgumentsList

    $JobId = $ProgressJob.Id
    $JobId
}

# Function to stop the progress dialog
function Close-ProgressDialogAsync {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Position = 0, Mandatory = $true)]
        [int]$JobId
    )  
    $TmpFile = "$ENV:Temp\psjob.tmp"
    
    # Set ShouldStop to true
    Set-Content $TmpFile -Value 0
    $Job = Get-Job -Id $JobId -ErrorAction Ignore 
    if($Job){
      $Job | Wait-Job -Timeout 3
      $Job | Remove-Job -Force
    }

    Write-Host "Progress dialog closed." -ForegroundColor Green
}


