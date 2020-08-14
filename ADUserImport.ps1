# Importing Active Directory Users via CSV file
#
#------------------------------------------------------------------------------
# Documentation:
# * Parameters
#   > tar_path      - Path of the .csv file
#                     ex. C:\Users\Tom\Desktop\somefile.csv
#
#------------------------------------------------------------------------------
# Change Log:
# * 8/10/2020
#   - Finished initial draft.
#   - 
#
#------------------------------------------------------------------------------
# Known Issues:
# 1. Add a force option?
#
#------------------------------------------------------------------------------

param ($tar_path)

function AccountNameSchema {
    Write-Host "`n`nAccount names can be generated automatically.`n
    There are three options for formatting the the account names.`n
    `t1. [lastname].[first initial]`n`t2. [first initial].[lastname]"
    
    $usr_resp = Read-Host "Select a number or type anything to keep the default."
    
    switch ($usr_resp) {
        '1' { return '1' }
        '2' { return '2' }
        Default { return $null }
    }
}

## Import CSV file and Verify Data
$new_users = Import-Csv -Path $tar_path
$new_users | Format-Table
$resp = Read-Host "Does the information above look correct? (yes / no): "
switch ($resp) {
    "yes" {  }
    "y" {  }
    "no" { exit }
    "n" { exit }
    Default { exit }
}

$ans = AccountNameSchema
foreach ($user in $new_users) {
    switch ($ans) {
        '1' { $usr = ($user.Surname + "." + $user.GivenName[0]).ToLower() }
        '2' { $usr = ($user.GivenName[0] + "." + $user.Surname).ToLower() }
        Default { $usr = ($user.GivenName[0] + $user.Surname).ToLower() }
    }
    Write-Host $usr
    New-ADUser -Name $user.Name -GivenName $user.GivenName -Surname $user.Surname `
               -Path $user.Path -ChangePasswordAtLogon $true -Enabled $true `
               -SamAccountName $usr
}

