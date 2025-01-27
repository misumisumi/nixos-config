Write-Host "Update all installed packages..."

if (Get-Command * | Where-Object { $_.Name -match "winget" }) {
Write-Host "Updating winget packages..."
sudo winget upgrade `
    --all `
    --accept-package-agreements `
    --accept-source-agreements `
    --disable-interactivity `
    --include-unknown
}

if (Get-Command * | Where-Object { $_.Name -match "scoop" }) {
Write-Host "Updating scoop packages..."
scoop update *
}