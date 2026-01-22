# setup.ps1 - Script de configuration automatique

Write-Host "======================================" -ForegroundColor Green
Write-Host "Configuration DevOps - Banking App" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green

# Vérification Java
Write-Host "`nVérification de Java..." -ForegroundColor Yellow
java -version
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERREUR: Java n'est pas installé !" -ForegroundColor Red
    exit 1
}

# Vérification Maven
Write-Host "`nVérification de Maven..." -ForegroundColor Yellow
mvn -version
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERREUR: Maven n'est pas installé !" -ForegroundColor Red
    exit 1
}

# Vérification Docker
Write-Host "`nVérification de Docker..." -ForegroundColor Yellow
docker --version
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERREUR: Docker n'est pas installé !" -ForegroundColor Red
    exit 1
}

# Nettoyage
Write-Host "`nNettoyage des builds précédents..." -ForegroundColor Yellow
mvn clean

# Compilation et tests
Write-Host "`nCompilation et tests..." -ForegroundColor Yellow
mvn clean test
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERREUR: Les tests ont échoué !" -ForegroundColor Red
    exit 1
}

# Rapport JaCoCo
Write-Host "`nGénération du rapport de couverture..." -ForegroundColor Yellow
mvn jacoco:report
Write-Host "Rapport disponible: target\site\jacoco\index.html" -ForegroundColor Green

# Démarrage SonarQube
Write-Host "`nDémarrage de SonarQube..." -ForegroundColor Yellow
docker-compose up -d sonarqube

Write-Host "`nAttente du démarrage de SonarQube (60 secondes)..." -ForegroundColor Yellow
Start-Sleep -Seconds 60

# Vérification SonarQube
$maxAttempts = 20
$attempt = 0
do {
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:9000/api/system/status" -UseBasicParsing
        if ($response.Content -match '"status":"UP"') {
            Write-Host "SonarQube est opérationnel !" -ForegroundColor Green
            break
        }
    } catch {
        Write-Host "SonarQube démarre encore..." -ForegroundColor Yellow
        Start-Sleep -Seconds 10
        $attempt++
    }
} while ($attempt -lt $maxAttempts)

Write-Host "`nAccès SonarQube: http://localhost:9000" -ForegroundColor Green
Write-Host "Login: admin / admin (changez le mot de passe)" -ForegroundColor Yellow

# Build Docker
Write-Host "`nConstruction de l'image Docker..." -ForegroundColor Yellow
docker build -t banking-app:latest .
if ($LASTEXITCODE -eq 0) {
    Write-Host "Image Docker créée avec succès !" -ForegroundColor Green
} else {
    Write-Host "ERREUR lors du build Docker !" -ForegroundColor Red
    exit 1
}

# Résumé
Write-Host "`n======================================" -ForegroundColor Green
Write-Host "Configuration terminée !" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green
Write-Host "`nServices:" -ForegroundColor Yellow
Write-Host "• SonarQube: http://localhost:9000" -ForegroundColor Cyan
Write-Host "• Rapport JaCoCo: target\site\jacoco\index.html" -ForegroundColor Cyan
Write-Host "`nProchaines étapes:" -ForegroundColor Yellow
Write-Host "1. Configurez Jenkins" -ForegroundColor White
Write-Host "2. Créez un compte DockerHub" -ForegroundColor White
Write-Host "3. Testez le pipeline" -ForegroundColor White