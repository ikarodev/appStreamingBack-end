$missingFiles = @(
    "assets/images/ic_genresbanner.png",
    "assets/images/ic_series.png",
    "assets/images/ic_more_details.png",
    "assets/images/ic_download_list.png",
    "assets/images/ic_cmingsoon.png",
    "assets/images/ic_twitter.png",
    "assets/images/ic_instagram.png",
    "assets/images/ic_live.png",
    "assets/images/ic_naturalaudio.png",
    "assets/images/ic_dolbyaudio.png",
    "assets/images/ic_subtitles.png",
    "assets/images/ic_relate_icon.png",
    "assets/images/ic_no_download.png",
    "assets/images/ic_comments.png",
    "assets/images/ic_audio.png",
    "assets/images/ic_chromecast.png",
    "assets/images/ic_nodata.png",
    "assets/images/ic_nointernet.png",
    "assets/images/ic_tvguide.png",
    "assets/images/ic_buzzing_web.png",
    "assets/images/ic_buzzing.png",
    "assets/images/ic_nodata_banner.jpg",
    "assets/images/ic_nomessage.png"
)

foreach ($file in $missingFiles) {
    $fullPath = Join-Path -Path $PSScriptRoot -ChildPath $file
    $directory = [System.IO.Path]::GetDirectoryName($fullPath)
    
    # Create directory if it doesn't exist
    if (-not (Test-Path -Path $directory)) {
        New-Item -ItemType Directory -Path $directory -Force | Out-Null
    }
    
    # Create empty file if it doesn't exist
    if (-not (Test-Path -Path $fullPath)) {
        New-Item -ItemType File -Path $fullPath -Force | Out-Null
        Write-Host "Created empty file: $file"
    } else {
        Write-Host "File already exists: $file"
    }
}

Write-Host "All missing asset files have been created as empty placeholders."
