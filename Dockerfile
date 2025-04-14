# Step 1: Use the official .NET SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the project file(s) into the container
COPY . .  # Copy all files from the local directory into the container

# Restore the dependencies (NuGet packages)
RUN dotnet restore

# Build the app
RUN dotnet build -c Release -o /app/build

# Step 2: Publish the app to a directory
FROM build AS publish
RUN dotnet publish -c Release -o /app/publish

# Step 3: Use the official .NET runtime image to run the app
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS final
WORKDIR /app

# Copy the published files from the 'publish' stage to the final stage
COPY --from=publish /app/publish .

# Expose port 80 (standard for web apps)
EXPOSE 80

# Set the entry point to run your app
ENTRYPOINT ["dotnet", "YourProjectName.dll"]
