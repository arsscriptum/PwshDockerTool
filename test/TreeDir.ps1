
function Show-ObjectTree {
    [CmdletBinding()]
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

        $type = $Value.GetType().FullName

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
    $Form.Text = "Object Tree"
    $Form.Size = New-Object System.Drawing.Size(600, 600)

    $TreeView = New-Object System.Windows.Forms.TreeView
    $TreeView.Location = New-Object System.Drawing.Point(10, 10)
    $TreeView.Size = New-Object System.Drawing.Size(580, 550)
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


function Show-ObjectTree2 {
    [CmdletBinding()]
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

        $type = $Value.GetType().FullName

        if ($Value -is [PSCustomObject]) {
            # Handle PSCustomObject (key-value pairs)
            $node = New-Object System.Windows.Forms.TreeNode
            $node.Tag = "$Key"
            $node.Text = "$Key"
            [void]$ParentNode.Nodes.Add($node)

            $Value.PSObject.Properties | ForEach-Object {
                Add-Node $node $_.Name $_.Value
            }
        }
        elseif ($Value -is [Hashtable]) {
            # Handle Hashtable (key-value pairs)
            $node = New-Object System.Windows.Forms.TreeNode
            $node.Tag = "$Key"
            $node.Text = "$Key"
            [void]$ParentNode.Nodes.Add($node)

            $Value.GetEnumerator() | ForEach-Object {
                Add-Node $node $_.Key $_.Value
            }
        }
        elseif ($Value -is [System.Collections.ArrayList] -or $Value -is [Array]) {
            # Handle arrays and ArrayLists
            $node = New-Object System.Windows.Forms.TreeNode
            $node.Tag = "$Key"
            $node.Text = "$Key"
            [void]$ParentNode.Nodes.Add($node)

            for ($i = 0; $i -lt $Value.Count; $i++) {
                Add-Node $node "[$i]" $Value[$i]
            }
        }
        else {
            # Handle primitive values
            $node = New-Object System.Windows.Forms.TreeNode
            $node.Tag = "$Key`:`t$Value"
            $node.Text = "$Key`: $Value"
            [void]$ParentNode.Nodes.Add($node)
        }
    }

    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $Form = New-Object System.Windows.Forms.Form
    $Form.Text = "Object Tree"
    $Form.Size = New-Object System.Drawing.Size(600, 600)

    $TreeView = New-Object System.Windows.Forms.TreeView
    $TreeView.Location = New-Object System.Drawing.Point(10, 10)
    $TreeView.Size = New-Object System.Drawing.Size(580, 550)
    $TreeView.DrawMode = [System.Windows.Forms.TreeViewDrawMode]::OwnerDrawText

    # Add custom drawing for bold values
    $TreeView.add_DrawNode({
        param($sender, $e)

        $node = $e.Node
        $graphics = $e.Graphics
        $bounds = $e.Bounds

        # Fonts
        $keyFont = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Regular)
        $valueFont = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)

        # Split Key and Value
        if ($node.Tag -match "(.*?):\s(.*)") {
            $key = $matches[1]
            $value = $matches[2]

            # Measure text sizes
            $keySize = $graphics.MeasureString($key + ": ", $keyFont)
            $keyX = $bounds.X
            $valueX = $keyX + $keySize.Width

            # Draw key (normal font)
            $graphics.DrawString("$key`: ", $keyFont, [System.Drawing.Brushes]::Black, $keyX, $bounds.Y)

            # Draw value (bold font)
            $graphics.DrawString($value, $valueFont, [System.Drawing.Brushes]::Black, $valueX, $bounds.Y)
        } else {
            # Fallback to default text if no colon is found
            $graphics.DrawString($node.Text, $keyFont, [System.Drawing.Brushes]::Black, $bounds.X, $bounds.Y)
        }

        # Prevent default rendering
        $e.DrawDefault = $false
    })

    $Form.Controls.Add($TreeView)

    # Create the root node
    $rootNode = New-Object System.Windows.Forms.TreeNode
    $rootNode.Text = $RootObjectName
    Write-host "Write $RootObjectName"
    $rootNode.Tag = $RootObjectName
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


function Show-DirectoryTree {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
        [string]$RootFolder
    )

    # recursive helper function to add folder nodes to the treeview
    function Add-Node {
        param (
            [System.Windows.Forms.TreeNode]$parentNode, 
            [System.IO.DirectoryInfo]$Folder
        )
        Write-Verbose "Adding node $($Folder.Name)"
        $subnode      = New-Object System.Windows.Forms.TreeNode
        $subnode.Text = $Folder.Name
        [void]$parentNode.Nodes.Add($subnode)
        Get-ChildItem -Path $Folder.FullName -Directory | ForEach-Object {
            Add-Node $subnode $_
        }
    }

    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $Form = New-Object System.Windows.Forms.Form
    $Form.Text = "Folders"
    $Form.Size = New-Object System.Drawing.Size(390, 390)

    $TreeView = New-Object System.Windows.Forms.TreeView
    $TreeView.Location = New-Object System.Drawing.Point(48, 12)
    $TreeView.Size = New-Object System.Drawing.Size(290, 322)
    $Form.Controls.Add($TreeView)

    $rootnode = New-Object System.Windows.Forms.TreeNode
    # get the name of the rootfolder to use for the root node
    $rootnode.Text = [System.IO.Path]::GetFileName($RootFolder.TrimEnd('\'))  #'# or use: (Get-Item -Path $RootFolder).Name
    $rootnode.Name = "Root"
    [void]$TreeView.Nodes.Add($rootnode)
    # expand just the root node
    $rootNode.Expand()

    # get all subdirectories inside the root folder and 
    # call the recursive function on each of them
    Get-ChildItem -Path $RootFolder -Directory | ForEach-Object {
        Add-Node $rootnode $_
   }

   $Form.Add_Shown({$Form.Activate()})
   [void] $Form.ShowDialog()

   # remove the form when done with it
   $Form.Dispose()
}

# call the function to show the directory tree 
# take off the -Verbose switch if you do not want console output
# Show-DirectoryTree -RootFolder 'd:\Scripts' -Verbose

$jsonFile = "D:\Scripts\PwshDockerTool\data.json"
$JsonData = Get-Content -Path $jsonFile | ConvertFrom-Json
Show-ObjectTree $JsonData