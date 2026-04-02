# menu.ps1 - Menu com setas simples (asterisco *)

param(
    [string]$submenu = ""
)

Clear-Host

function Show-Menu {
    param (
        [string[]]$Opcoes,
        [string]$Titulo
    )

    $pos = 0
    $total = $Opcoes.Count

    while ($true) {
        Clear-Host
        Write-Host $Titulo
        Write-Host "-----------------------------"
        Write-Host ""

        for ($i = 0; $i -lt $total; $i++) {
            if ($i -eq $pos) {
                Write-Host "* $($Opcoes[$i])" -BackgroundColor Green -ForegroundColor White
            } else {
                Write-Host "  $($Opcoes[$i])" 
            }
        }

        Write-Host ""
        Write-Host "Use setas CIMA / BAIXO para navegar"
        Write-Host "ENTER para selecionar"
        Write-Host "ESC ou Q para voltar/sair"
        Write-Host ""

        $tecla = [Console]::ReadKey($true).Key

        switch ($tecla) {
            "UpArrow" {
                if ($pos -gt 0) { $pos-- } else { $pos = $total - 1 }
            }
            "DownArrow" {
                if ($pos -lt $total - 1) { $pos++ } else { $pos = 0 }
            }
            "Enter" {
                return ($pos + 1)
            }
            "Escape" {
                return 0
            }
            "Q" {
                return 0
            }
        }
    }
}

if ($submenu -eq "") {
    # Menu principal
    $opcoes = @(
        "Baixar como MP3",
        "Baixar como MP4",
        "Atualizar yt-dlp",
        "Sair"
    )

    $escolha = Show-Menu -Opcoes $opcoes -Titulo "YOUTUBE DOWNLOADER PRO 4.7"
    exit $escolha
}
elseif ($submenu -eq "mp3") {
    $opcoes = @(
        "Alta   (320 kbps)",
        "Media  (192 kbps)",
        "Baixa  (128 kbps)",
        "Voltar"
    )

    $escolha = Show-Menu -Opcoes $opcoes -Titulo "QUALIDADE MP3"
    exit $escolha
}
elseif ($submenu -eq "mp4") {
    $opcoes = @(
        "Full HD  (1080p + audio)",
        "HD       (720p)",
        "SD       (480p)",
        "Voltar"
    )

    $escolha = Show-Menu -Opcoes $opcoes -Titulo "QUALIDADE MP4"
    exit $escolha
}

exit 0
