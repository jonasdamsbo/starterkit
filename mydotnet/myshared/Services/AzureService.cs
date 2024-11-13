using Microsoft.TeamFoundation.Core.WebApi;
using Microsoft.VisualStudio.Services.Common;
using Microsoft.VisualStudio.Services.WebApi;
using Azure.Identity;
using Azure.ResourceManager;
using Azure.ResourceManager.Resources;
using Microsoft.TeamFoundation.Build.WebApi;
using Microsoft.TeamFoundation.SourceControl.WebApi;
using System.Net.Http.Headers;
using System.Text;

using Newtonsoft.Json;

namespace myshared.Services
{
    public class AzureService
    {
        // temp hardcoded vars // Replace with your Azure Cloud Subscription info + Azure DevOps organization info
        //temp devops
        string organizationName = "jonasdamsbo";
        string orgUrl = "https://dev.azure.com/jonasdamsbo";
        string patToken = "CXJ3OyaKTFmcbMjSjHannRvjNepidqZGyN4endV9ldZqeruEWuCHJQQJ99AKACAAAAAjpjMvAAASAZDOhOVN"; // <-- cant get with ps1, add manually to EnvVar
        //temp cloud
        string subscriptionName = "jgdtestsubscription";
        string subscriptionId = "8e4e96ed-7549-4b0c-9bd9-edbeed4c2f77";
        string tenantId = "ec481362-ae50-4bfb-8524-b7c76d7b4cd8";
        string clientId = "ec84cdac-142e-479f-89c1-4c70bb8f743d";
        string clientSecret = "J2q8Q~JCA2psO-e0oY1O6YXfgYKzwSrhOFsCpafb";

        // normals vars
        private List<string> resourceNames = new List<string>();
        private List<string> resourceTypes = new List<string>();
        public List<Resourcex> resources = new List<Resourcex>();

        private VssConnection azureDevopsOrganization;

        private SubscriptionResource azureCloudSubscription;

        private List<ResourceGroupData> resourceGroupsData;
        private ResourceGroupCollection resourceGroupsResource;

        private IPagedList<TeamProjectReference> projectsReference;

        public class Resourcex()
        {
            public string Name { get; set; }
            public string Type { get; set; }
        }

        public AzureService() {
            Init();
        }

        public void Init()
        {
            InitDevops();
            InitCloud();

            GetResources();
        }

        private void GetResources()
        {
            GetProjects();
            GetResourcegroups();
            GetCloudResources();
            GetDevopsResources().GetAwaiter().GetResult();
            PrintAllResources();
        }

        public List<Resourcex> GetResourcesList()
        {
            return resources;
        }

        private void InitCloud()
        {
            var resourceIdentifier = new Azure.Core.ResourceIdentifier($"/subscriptions/{subscriptionId}");

            // Step 1: Authenticate using DefaultAzureCredential (supports multiple auth types like Azure CLI, Managed Identity, etc.)
            var credential = new ClientSecretCredential(tenantId, clientId, clientSecret);

            // Step 2: Create a client to interact with Azure Resource Manager
            var armClient = new ArmClient(credential);

            // Step 3: Get the subscription where the App Service will be created
            try
            {
                var subscription = armClient.GetSubscriptionResource(resourceIdentifier);
                // initialize subscription
                azureCloudSubscription = subscription;
            }
            catch (Exception ex)
            {
                Console.WriteLine("Exception in azureservice: " + ex.ToString());
            }
        }

        private void InitDevops()
        {
            // Authenticate using the Personal Access Token (PAT)
            VssBasicCredential credentials = new VssBasicCredential(string.Empty, patToken);
            VssConnection connection = new VssConnection(new Uri(orgUrl), credentials);

            // initialize azure devops connection
            azureDevopsOrganization = connection;
        }

        private void GetProjects()
        {
            try
            {
                // Create the Project API Client
                var projectClient = azureDevopsOrganization.GetClient<ProjectHttpClient>();

                // Get all projects in the organization
                var projects = projectClient.GetProjects().Result;
                //var x = projects.ToList();

                // Output project names
                //Console.WriteLine("Projects in the organization:");
                foreach (var project in projects)
                {
                    //Console.WriteLine($"- {project.Name}");
                }
                projectsReference = projects;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}");
            }
        }

        private void GetResourcegroups()
        {
            try
            {
                // Get all projects in the organization
                var resourcegroups = azureCloudSubscription.GetResourceGroups();
                var resourcegroupsData = new List<ResourceGroupData>();
                //var x = projects.ToList();

                // Output project names
                //Console.WriteLine("Resourcegroup in the subscription:");
                foreach (var resourcegroup in resourcegroups)
                {
                    //Console.WriteLine($"- {resourcegroup.Data.Name}");
                    resourcegroupsData.Add(resourcegroup.Data);
                }
                resourceGroupsData = resourcegroupsData;
                resourceGroupsResource = resourcegroups;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}");
            }
        }

        private void GetCloudResources()
        {
            try
            {
                // Get all projects in the organization
                var apps = resourceGroupsResource.First().GetGenericResources();
                //var x = projects.ToList();

                // Output project names
                //Console.WriteLine("Resourcegroup in the subscription:");
                foreach (var resource in apps)
                {


                    var resourcename = resource.Data.Name;
                    var resourcetype = "";
                    //Console.WriteLine($"- {resource.Data.Name}");

                    //resourceTypes.Add(resource.Data.ResourceType);
                    if (resource.Data.ResourceType == "Microsoft.Sql/servers/databases") resourcetype = "SQLDatabase";
                    if (resource.Data.ResourceType == "Microsoft.Sql/servers") resourcetype = "SQLServer";
                    if (resource.Data.ResourceType == "Microsoft.Web/sites") resourcetype = "AppService";
                    if (resource.Data.ResourceType == "Microsoft.DocumentDB/mongoClusters") resourcetype = "CosmosMongoDB";
                    if (resource.Data.ResourceType == "Microsoft.Web/serverFarms") resourcetype = "AppServicePlan";
                    if (resource.Data.ResourceType == "Microsoft.Storage/storageAccounts") resourcetype = "StorageAccount";
                    if (resource.Data.ResourceType == "microsoft.insights/components") resourcetype = "AppInsights";
                    if (resource.Data.ResourceType == "microsoft.insights/actiongroups") resourcetype = "AppInsightsSmartDetection";
                    if (resource.Data.ResourceType == "Microsoft.Web/connections") resourcetype = "TaskConnection";
                    if (resource.Data.ResourceType == "Microsoft.Logic/workflows") resourcetype = "StorageAccountTask";

                    resourceTypes.Add(resourcetype);
                    resourceNames.Add(resourcename);

                    var res = new Resourcex();
                    res.Name = resourcename;
                    res.Type = resourcetype;
                    resources.Add(res);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}");
            }
        }

        private async Task GetDevopsResources()
        {
            var gitClient = azureDevopsOrganization.GetClient<GitHttpClient>();
            var pipelineClient = azureDevopsOrganization.GetClient<BuildHttpClient>();

            // List Git Repositories in the project
            //Console.WriteLine($"Listing Repositories for project: {projectsReference.First().Name}");
            var repositories = await gitClient.GetRepositoriesAsync(projectsReference.First().Id);
            foreach (var repo in repositories)
            {
                //Console.WriteLine($"Repository Name: {repo.Name}, Repository ID: {repo.Id}");
                resourceNames.Add(repo.Name);
                resourceTypes.Add("AzureRepository");
                var res = new Resourcex();
                res.Name = repo.Name;
                res.Type = "AzureRepository";
                resources.Add(res);
            }

            // List Build Pipelines in the project
            //Console.WriteLine($"\nListing Pipelines for project: {projectsReference.First().Name}");
            var pipelines = await pipelineClient.GetDefinitionsAsync(projectsReference.First().Id);
            foreach (var pipeline in pipelines)
            {
                //Console.WriteLine($"Pipeline Name: {pipeline.Name}, Pipeline ID: {pipeline.Id}");
                resourceNames.Add(pipeline.Name);
                resourceTypes.Add("BuildPipeline");
                //resourceTypes.Add(pipeline.Type.ToString());
                var res = new Resourcex();
                res.Name = pipeline.Name;
                res.Type = "BuildPipeline";
                resources.Add(res);
            }

            // VARIABLE GROUP
            // Azure DevOps organization and project (replace with your values)
            string orgName = organizationName;
            string projectName = projectsReference.First().Name;
            string pat = patToken; // Your PAT here

            // Set up the HTTP client
            var client = new HttpClient();

            // Set the base URL for Azure DevOps API
            client.BaseAddress = new Uri($"https://dev.azure.com/{orgName}/{projectName}/_apis/distributedtask/variablegroups?api-version=7.1-preview.2");

            // Set the authorization header using the PAT
            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Basic", Convert.ToBase64String(Encoding.ASCII.GetBytes($":{pat}")));

            // Make the GET request to the API
            var response = await client.GetAsync(client.BaseAddress);

            // Check if the response is successful
            if (response.IsSuccessStatusCode)
            {
                // Read the response content as string
                var content = await response.Content.ReadAsStringAsync();

                // Deserialize the JSON response into a dynamic object
                var result = JsonConvert.DeserializeObject<dynamic>(content);

                // Iterate over the variable groups and print their names
                //Console.WriteLine("Variable Groups:");
                foreach (var variableGroup in result.value)
                {
                    //Console.WriteLine($"Name: {variableGroup.name}, ID: {variableGroup.id}");
                    resourceNames.Add(variableGroup.name.ToString());
                    resourceTypes.Add("VariableGroup");
                    var res = new Resourcex();
                    res.Name = variableGroup.name.ToString();
                    res.Type = "VariableGroup";
                    resources.Add(res);
                }
            }
            else
            {
                Console.WriteLine($"Error: {response.StatusCode}");
                var errorContent = await response.Content.ReadAsStringAsync();
                Console.WriteLine(errorContent);
            }


            // RELEASES
            var releasesClient = new HttpClient();

            // Set the base URL for Azure DevOps API to list release pipelines (release definitions)
            releasesClient.BaseAddress = new Uri($"https://vsrm.dev.azure.com/{orgName}/{projectName}/_apis/release/definitions?api-version=7.1-preview.3");

            // Set the authorization header using the PAT (Personal Access Token)
            releasesClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Basic", Convert.ToBase64String(Encoding.ASCII.GetBytes($":{pat}")));

            // Make the GET request to the API
            var releasesResponse = await releasesClient.GetAsync(releasesClient.BaseAddress);

            // Check if the response is successful
            if (releasesResponse.IsSuccessStatusCode)
            {
                // Read the response content as string
                var content = await releasesResponse.Content.ReadAsStringAsync();

                // Deserialize the JSON response into a dynamic object
                var result = JsonConvert.DeserializeObject<dynamic>(content);

                // Iterate over the release pipelines and print their names
                //Console.WriteLine("Release Pipelines:");
                foreach (var releasePipeline in result.value)
                {
                    //Console.WriteLine($"Pipeline Name: {releasePipeline.name}, ID: {releasePipeline.id}");
                    resourceNames.Add(releasePipeline.name.ToString());
                    resourceTypes.Add("DeployRelease");
                    var res = new Resourcex();
                    res.Name = releasePipeline.name.ToString();
                    res.Type = "DeployRelease";
                    resources.Add(res);
                }
            }
            else
            {
                Console.WriteLine($"Error: {releasesResponse.StatusCode}");
                var errorContent = await releasesResponse.Content.ReadAsStringAsync();
                Console.WriteLine(errorContent);
            }
        }

        private void PrintAllResources()
        {
            Console.WriteLine(" ");
            Console.WriteLine($"All resources list for org({organizationName})/sub({subscriptionName})/proj({projectsReference.First().Name})/rg({resourceGroupsData.First().Name}): ");
            //var index = 0;
            //foreach (var item in resourceNames)
            //{
            //    Console.WriteLine("# Resource of type: "+ resourceTypes[index] + " # With name: " + item);
            //    index++;
            //}
            foreach (var item in resources)
            {
                Console.WriteLine("# Resource of type: " + item.Type + " # With name: " + item.Name);
            }
            Console.WriteLine("All resources list end...");
            Console.WriteLine(" ");
        }
    }
}
