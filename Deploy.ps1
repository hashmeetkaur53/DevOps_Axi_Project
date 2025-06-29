param (
    [string]$ImageName = "superservice",
    [string]$Tag = "latest",
    [string]$ContainerName = "superservice"
)

$ErrorActionPreference = "Stop"

# Step 1: Run tests
Write-Host "Running automated tests..."
if (Test-Path ".\test\SuperService.UnitTests.csproj") {
    dotnet test .\test\SuperService.UnitTests.csproj
} else {
    Write-Host "No test project found. Skipping tests."
}

# Step 2: Build Docker image
Write-Host "Building Docker image..."
docker build -t "${ImageName}:${Tag}" .

# Step 3: Stop and remove any existing container
$existing = docker ps -a -q -f "name=$ContainerName"
if ($existing) {
    Write-Host "Stopping and removing existing container..."
    docker stop $ContainerName
    docker rm $ContainerName
}

# Step 4: Run the new container
Write-Host "Running the container on http://localhost:8080"
docker run -d -p 8080:80 --name $ContainerName ${ImageName}:${Tag}

