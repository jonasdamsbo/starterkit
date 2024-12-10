using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

using Azure.Storage.Blobs;
using Microsoft.SqlServer.Dac;
using myshared.Services;
using System.Globalization;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

namespace myapi.Utility
{
    public class BackupDbUtility
    {
        string databaseName;
        string conStr;

        string storageConnectionString;
        string containerName;
        string bacpacFileName;
        string bacpacFilePath;

        EnvironmentVariableService environmentVariableService;

        public BackupDbUtility(EnvironmentVariableService envVarService)
        {
            environmentVariableService = envVarService;

            // remember to add this one connectionstring and these three envvars to azure portal api (currently in appsettings.json)
            conStr = envVarService.GetConnectionString("Mssql");
            databaseName = envVarService.GetEnvironmentVariable("MyApiSettings:DatabaseName");
            storageConnectionString = envVarService.GetEnvironmentVariable("MyApiSettings:AzureStorageConnectionString");
            containerName = envVarService.GetEnvironmentVariable("MyApiSettings:StorageContainerName");

            // get date
            var time = DateTime.Now.ToString(new CultureInfo("de-DE"));
            time = time.Replace(" ", "-").Replace(":", ".");

            // prep filename and path
            bacpacFileName = databaseName + time + ".bacpac";
            bacpacFilePath = Path.Combine(Path.GetTempPath(), bacpacFileName);
        }

        public void InitBackup()
        {
            var currentDevelopmentEnvironment = environmentVariableService.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT");
            if (currentDevelopmentEnvironment == "Production")
            {
                // Export BACPAC
                ExportDatabaseToBacpac(conStr, databaseName, bacpacFilePath);

                // Upload BACPAC to Azure Blob Storage
                UploadToAzureBlob(storageConnectionString, containerName, bacpacFilePath, bacpacFileName);

                // Optionally, delete the local BACPAC file after uploading
                File.Delete(bacpacFilePath);
            }
        }

        static void ExportDatabaseToBacpac(string conStr, string databaseName, string bacpacFilePath)
        {
            var dacServices = new DacServices(conStr);
            dacServices.ExportBacpac(bacpacFilePath, databaseName);
            Console.WriteLine($"Exported {databaseName} to {bacpacFilePath}");
        }

        static void UploadToAzureBlob(string connectionString, string containerName, string localFilePath, string blobName)
        {
            var blobServiceClient = new BlobServiceClient(connectionString);
            var containerClient = blobServiceClient.GetBlobContainerClient(containerName);
            containerClient.CreateIfNotExists();

            var blobClient = containerClient.GetBlobClient(blobName);
            using (var fileStream = File.OpenRead(localFilePath))
            {
                blobClient.Upload(fileStream, overwrite: true);
            }

            Console.WriteLine($"Uploaded {localFilePath} to Azure Blob Storage as {blobName}");
        }

    }
}