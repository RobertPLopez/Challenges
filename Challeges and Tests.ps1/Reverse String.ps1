#The beginner warm-up for PowerShell from Iron Scripter
function ConvertTo-ReverseString{
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$TheOriginalString
    )
    $charArray = $TheOriginalString.ToCharArray()
    [array]::Reverse($charArray)
    return -join($charArray)
}
Write-Host "'Powershell' reversed spells like $(ConvertTo-ReverseString 'Powershell')"

#The intermediate warm-up for PowerShell from Iron Scripter
function ConvertTo-ReverseString {
    param(
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]$TheOriginalString
    )
    begin {
        $returnValues = @()
    }
    process {
        $charArray = $TheOriginalString.ToCharArray()
        [array]::Reverse($charArray)
        $returnValues += -join ($charArray)
    }
    end {
        return $returnValues
    }
}
$sentence = "This is how you can improve your PowerShell skills"
$reversed=ConvertTo-ReverseString $sentence
Write-Host "$sentence`n reversed spells like `n$reversed"
Write-Host " reversed again is `n$($reversed|ConvertTo-ReverseString)"

#The advanced warm-up for PowerShell from Iron Scripter
function ConvertTo-ReverseString {
    param(
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]$TheOriginalString
    )
    begin {
        $returnValues = @()
    }
    process {
        $charArray = $TheOriginalString.ToCharArray()
        [array]::Reverse($charArray)
        $returnValues += -join ($charArray)
    }
    end {
        return $returnValues
    }
}
$sentence = "This is how you can improve your PowerShell skills"
$reversed=ConvertTo-ReverseString $sentence
Write-Host "$sentence`n reversed spells like `n$reversed"
Write-Host " reversed again is `n$($reversed|ConvertTo-ReverseString)"