# Version 0.1.1
#Copyright 2020 - ScriptBlock
#Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

param(
     [Parameter()]
     [string]$vpxLocation = "",
     [string]$pupLocation = "",
     [string]$assetLocation = "",
     [string]$configFile = "",
     [string]$tableName = "",
     [switch]$gridview,
    
    [switch]$list,[switch]$backup,[switch]$restore,
        [switch]$copyTable,[switch]$copyRom,[switch]$copyAltSound,[switch]$copyAltColor,[switch]$copyNVRam,[switch]$copyPUPPack,[switch]$copyAll,
            [switch]$tableB2S,[switch]$tablePOV,[switch]$tableVPX,[switch]$tableVBS,[switch]$tableAll
)

Function New-TableObject {
    $retVal = New-Object -TypeName psobject
    $retVal | Add-Member -MemberType NoteProperty -Name TableName -Value ""
    $retVal | Add-Member -MemberType NoteProperty -Name HasAltColor -Value ""
    $retVal | Add-Member -MemberType NoteProperty -Name HasAltSound -Value ""
    $retVal | Add-Member -MemberType NoteProperty -Name HasRoms -Value ""
    $retVal | Add-Member -MemberType NoteProperty -Name HasTables -Value ""
    $retVal | Add-Member -MemberType NoteProperty -Name HasNVRam -Value ""
    $retVal | Add-Member -MemberType NoteProperty -Name HasPUPPack -Value ""
    $retVal
}


Function Get-VPXParameters {
    #TODO write this
	if(($configFile -ne $null) -and (Test-Path $configFile)) {
        Write-Output $configFile
    } else {
        Write-Output "no"
    }
}

#Get-VPXParameters


Function Get-Tables {
    $tableList = @()
    if(($assetLocation -ne $null) -and (Test-Path $assetLocation)) {
        gci -Directory $assetLocation | % {
            $tableObj = New-TableObject
            if($_.Name -match $tableName) {
                $tableObj.TableName = $_.Name
                $tableObj.HasAltColor = Test-Path "$($_.PSPath)\AltColor"
                $tableObj.HasAltSound = Test-Path "$($_.PSPath)\AltSound"
                $tableObj.HasRoms = Test-Path "$($_.PSPath)\Roms"
                $tableObj.HasTables = Test-Path "$($_.PSPath)\Tables"
                $tableObj.HasNVRam = Test-Path "$($_.PSPath)\nvram"
                $tableObj.HasPUPPack = Test-Path "$($_.PSPath)\PupPack"
                $tableList += $tableObj
            }
        }
    }
    $tableList
}


Function List-Tables {
    if($gridview) {
        Get-Tables | Out-GridView
    } else {
        Write-Output "Table Name,HasTable,Has Rom,Has AltSound,Has AltColor,Has NVRam,Has PUP"
        foreach($table in Get-Tables) {
            Write-Output "$($table.TableName),$($table.HasTables),$($table.HasRoms),$($table.HasAltSound),$($table.HasAltColor),$($table.HasNVRam),$($table.HasPUPPack)"
        }        
    }
}


Function Restore-Tables {

    foreach($table in Get-Tables) {
        Write-Output "`n`n`n$($table.TableName)"
        Write-Output "---------------------------------------"
        if($vpxLocation -ne "") {
            if($copyTable -or $copyAll) {
                Write-Output "`nTABLE FILES"
                Write-Output "---------------------------------------"
                #copy the backglass
                if(($tableB2S -or $tableAll) -and $table.HasTables -and (Test-Path "$($assetLocation)\$($table.TableName)\Tables\$($table.TableName).directb2s")) {
                    Write-Output "Copying $($assetLocation)\$($table.TableName)\Tables\$($table.TableName).directb2s to $vpxLocation\Tables"
                    Copy-Item "$($assetLocation)\$($table.TableName)\Tables\$($table.TableName).directb2s" "$vpxLocation\Tables" -Force
                } else {
                    Write-Output "$($table.TableName) NOT copying B2S"
                }

                #copy the pov
                if(($tablePOV -or $tableAll) -and $table.HasTables -and (Test-Path "$($assetLocation)\$($table.TableName)\Tables\$($table.TableName).pov")) {
                    Write-Output "Copying $($assetLocation)\$($table.TableName)\Tables\$($table.TableName).pov to $vpxLocation\Tables"
                    Copy-Item "$($assetLocation)\$($table.TableName)\Tables\$($table.TableName).pov" "$vpxLocation\Tables" -Force
                } else {
                    Write-Output "$($table.TableName) NOT copying POV"
                }
                #copy the vbs
                if(($tableVBS  -or $tableAll) -and $table.HasTables -and (Test-Path "$($assetLocation)\$($table.TableName)\Tables\$($table.TableName).vbs")) {
                    Write-Output "Copying $($assetLocation)\$($table.TableName)\Tables\$($table.TableName).vbs to $vpxLocation\Tables"
                    Copy-Item "$($assetLocation)\$($table.TableName)\Tables\$($table.TableName).vbs" "$vpxLocation\Tables" -Force
                } else {
                    Write-Output "$($table.TableName) NOT copying VBS"
                }
                #copy the vpx
                if(($tableVPX -or $tableAll) -and $table.HasTables -and (Test-Path "$($assetLocation)\$($table.TableName)\Tables\$($table.TableName).vpx")) {
                    Write-Output "Copying $($assetLocation)\$($table.TableName)\Tables\$($table.TableName).vpx to $vpxLocation\Tables"
                    Copy-Item "$($assetLocation)\$($table.TableName)\Tables\$($table.TableName).vpx" "$vpxLocation\Tables" -Force
                } else {
                    Write-Output "$($table.TableName) NOT copying VPX"
                }
            }
        }
    }
    if($copyRom -or $copyAll) {
        Write-Output "`nROMS"
        Write-Output "---------------------------------------"

        if($vpxLocation -ne "") {
            if($table.HasRoms) {
                Write-Output "Copying $($assetLocation)\$($table.TableName)\Roms\*.zip to $vpxLocation\VPinMAME\roms"
                Copy-Item "$($assetLocation)\$($table.TableName)\Roms\*.zip" "$vpxLocation\VPinMAME\roms" -Force
            } else {
                Write-Output "$($table.TableName) NOT copying Roms"
            }
        }
    }
    if($copyAltSound -or $copyAll) {
        Write-Output "`nALTSOUND"
        Write-Output "---------------------------------------"
        
        if($vpxLocation -ne "") {
            if($table.HasAltSound) {
                mkdir -Force "$vpxLocation\VPinMAME\altsound" | Out-Null
                foreach($f in (gci "$($assetLocation)\$($table.TableName)\altsound")) {
                    if($f.Name.EndsWith("zip")) {
                        Write-Output "Copying $($assetLocation)\$($table.TableName)\altsound\$($f.Name) to $vpxLocation\VPinMAME\altsound"
                        Expand-Archive -Path $f.PSPath -DestinationPath "$vpxLocation\VPinMAME\altsound" -Force | Out-Null
                    }
                }
            }
        }
    }    
    if($copyAltColor -or $copyAll) {
        Write-Output "`nALTCOLOR"
        Write-Output "---------------------------------------"
        if($vpxLocation -ne "") {
            if($table.HasAltColor) {
                mkdir -Force "$vpxLocation\VPinMAME\altcolor" | Out-Null
                foreach($f in (gci "$($assetLocation)\$($table.TableName)\altcolor")) {
                    Write-Output "Copying $($assetLocation)\$($table.TableName)\altcolor\$($f.Name) to $vpxLocation\VPinMAME\altcolor"
                    cp -Recurse -Force $f.PSPath "$vpxLocation\VPinMAME\altcolor"
                }
            }
        }
    }
    if($copyNVRam -or $copyAll) {
        Write-Output "`nNVRAM"
        Write-Output "---------------------------------------"
        
        if($vpxLocation -ne "") {
            if($table.HasNVRam) {
                mkdir -Force "$vpxLocation\VPinMAME\nvram" | Out-Null
                foreach($f in (gci "$($assetLocation)\$($table.TableName)\nvram")) {
                    Write-Output "Copying $($assetLocation)\$($table.TableName)\nvram\$($f.Name) to $vpxLocation\VPinMAME\nvram"
                    cp -Force $f.PSPath "$vpxLocation\VPinMAME\nvram"
                }
            }
        }
    }

    if($copyPUPPack -or $copyAll) {
        Write-Output "`nPUPPACK"
        Write-Output "---------------------------------------"

        if($pupLocation -ne "") {
            if($table.HasPUPPack) {
                foreach($f in (gci "$($assetLocation)\$($table.TableName)\PupPack")) {
                    if($f.Name.EndsWith("zip")) {
                        Write-Output "Copying $($assetLocation)\$($table.TableName)\PupPack\$($f.Name) to $pupLocation\PUPVideos"
                        Expand-Archive -Path $f.PSPath -DestinationPath "$pupLocation\PUPVideos" -Force | Out-Null
                    }
                }
            }
        }
    }
}

if($list) {
    List-Tables
} elseif($restore) {
    Restore-Tables

}
