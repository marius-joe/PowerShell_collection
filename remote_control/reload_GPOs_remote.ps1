# ******************************************
#  Dev:  marius-joe
# ******************************************
#  v1.0.0
# ******************************************

# One Liner
# invoke command on remote PC

# Commands:
#   gpupdate /Force
#   systeminfo
#   shutdown -sg -t 30 -d p:4:1


$remote_machines = @("DG03", "DG04", "DG06"); `
$PScmd = {gpupdate /Force}; `
$waitFor_cmd = $True; `
; `
$nl = [System.Environment]::NewLine; `
$path_psExec = '\\live.sysinternals.com\tools\psexec.exe'; `
$list_targets = $remote_machines -join ', '; `
Write-Host $nl$nl"remote_machines: $list_targets"$nl"remote_cmd:`t ""$PScmd"""$nl$nl; `
foreach($machine in $remote_machines) {
    if (Test-Connection $machine -Count 1 -ErrorAction SilentlyContinue) {
        $PScmd_bytes = [System.Text.Encoding]::Unicode.GetBytes($PScmd)
        $PScmd_encoded = [Convert]::ToBase64String($PScmd_bytes)
        $output = &$path_psExec -accepteula -nobanner $(if ($waitFor_cmd) {''} else {'-d'}) `
                  "\\$machine" powershell -NoProfile -Output XML -EncodedCommand $PScmd_encoded `
                  | Format-Table -AutoSize
    } else {
        $output = "Error: $machine is down !"
    }; `
    $output
    Write-Host $nl
}
