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

using myshared.Models;
using myshared.Services;
using Microsoft.VisualStudio.Services.Commerce;
using SubscriptionResource = Azure.ResourceManager.Resources.SubscriptionResource;
using Microsoft.Graph;

namespace myapi.Utility
{
    public class AzureUtility
    {
        // temp hardcoded vars // Replace with your Azure Cloud Subscription info + Azure DevOps organization info
        //temp devops
        string organizationName;
		string orgUrl;
		string patToken;
		//temp cloud
		string subscriptionName;
		string subscriptionId;
		string tenantId;
		string clientId;
		string clientSecret;

		public string projectName;
		string resourceName;

		// normals vars
		public EnvironmentVariableService _envVarService;
        private List<string> resourceNames = new List<string>();
        private List<string> resourceTypes = new List<string>();
        public List<AzureResource> resources = new List<AzureResource>();

        private VssConnection azureDevopsOrganization;

        private SubscriptionResource azureCloudSubscription;

        private List<ResourceGroupData> resourceGroupsData = new List<ResourceGroupData>();
        private List<ResourceGroupResource> resourceGroupsResource = new List<ResourceGroupResource>();

        private List<TeamProjectReference> projectsReference = new List<TeamProjectReference>();

        public AzureUtility(EnvironmentVariableService envVarService) {
            _envVarService = envVarService;
            var env = _envVarService.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT");
            if (env == "Production")
            {
                //Init();
            }
        }

        public void Init()
        {
            InitVars();

            InitDevops();
            InitCloud();

            GetResources();

            SortResources();
        }

        private void InitVars(){
            organizationName = _envVarService.GetEnvironmentVariable("AzureServiceSettings:ORGANIZATIONNAME");
            orgUrl = _envVarService.GetEnvironmentVariable("AzureServiceSettings:FULLORGANIZATIONNAME");
            patToken = _envVarService.GetEnvironmentVariable("AzureServiceSettings:PAT");
            subscriptionName = _envVarService.GetEnvironmentVariable("AzureServiceSettings:SUBSCRIPTIONNAME");
            subscriptionId = _envVarService.GetEnvironmentVariable("AzureServiceSettings:SUBSCRIPTIONID");
            tenantId = _envVarService.GetEnvironmentVariable("AzureServiceSettings:TENANTID");
            clientId = _envVarService.GetEnvironmentVariable("AzureServiceSettings:CLIENTID");
            clientSecret = _envVarService.GetEnvironmentVariable("AzureServiceSettings:CLIENTSECRET");

			projectName = _envVarService.GetEnvironmentVariable("AzureServiceSettings:PROJECTNAME");
			resourceName = _envVarService.GetEnvironmentVariable("AzureServiceSettings:RESOURCENAME");
		}

        private void SortResources()
        {
            resources.Sort(delegate (AzureResource c1, AzureResource c2) { return c1.Type.CompareTo(c2.Type); });

            // find subscription and replace
			var subIndex = resources.FindIndex(a => a.Type.Contains("Azure Cloud Subscription"));
			AzureResource sub = resources[subIndex];
			resources.Remove(sub);
			resources.Insert(0, sub);

			// find rg and replace
			var rgIndex = resources.FindIndex(a => a.Type.Contains("Azure Cloud Resource Group"));
			AzureResource rg = resources[rgIndex];
			resources.Remove(rg);
			resources.Insert(1, rg);

			// find org
			var orgIndex = resources.FindIndex(a => a.Type.Contains("Azure DevOps Organization"));
			AzureResource org = resources[orgIndex];
			resources.Remove(org);

			// find first devops resource index
			var devopsIndex = resources.FindIndex(a => a.Type.Contains("Azure DevOps"));

			//insert org into devops index
			resources.Insert(devopsIndex, org);

			// find proj
			var projIndex = resources.FindIndex(a => a.Type.Contains("Azure DevOps Project"));
			AzureResource proj = resources[projIndex];
			resources.Remove(proj);

			// find first devops resource index
			var orgIndex2 = resources.FindIndex(a => a.Type.Contains("Azure DevOps Organization"));

			//insert proj into devops index
			resources.Insert(orgIndex2+1, proj);
		}

        private void GetResources()
        {
            GetProjects();
            GetResourcegroups();
            GetCloudResources();
            GetDevopsResources(projectName).GetAwaiter().GetResult();
            PrintAllResources();
        }

        public List<AzureResource> GetResourcesList()
        {
            return resources;
        }

        private void InitCloud()
        {
			var res = new AzureResource();
			res.Name = subscriptionName;
			res.Type = "Azure Cloud Subscription";
			resources.Add(res);

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

            //// app registration
            //var graphClient = new GraphServiceClient(credential);

            //// List App Registrations
            //var applications = graphClient.Applications
            //    .GetAsync().GetAwaiter().GetResult();

            //foreach (var app in applications.Value)
            //{
            //    Console.WriteLine($"App ID: {app.AppId}, App Name: {app.DisplayName}");
            //}
        }

        private void InitDevops()
        {
			var res = new AzureResource();
			res.Name = organizationName;
			res.Type = "Azure DevOps Organization";
			resources.Add(res);

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
				//var projects = projectClient.GetProjects().Result
				var projects = projectClient.GetProjects().Result;
				//var x = projects.ToList();

				// Output project names
				//Console.WriteLine("Projects in the organization:");
				foreach (var project in projects)
                {
                    //Console.WriteLine($"- {project.Name}");
                    if (project.Name.Contains(projectName))
                    {
					    var res = new AzureResource();
					    res.Name = project.Name;
					    res.Type = "Azure DevOps Project";
					    resources.Add(res);

						projectsReference.Add(project);
					}
				}
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
                    if (resourcegroup.Data.Name.Contains(resourceName))
					{
						resourcegroupsData.Add(resourcegroup.Data);

						var res = new AzureResource();
						res.Name = resourcegroup.Data.Name;
						res.Type = "Azure Cloud Resource Group";
						//res.Type = resourcegroup.Data.ResourceType;
						resources.Add(res);

						resourceGroupsData.Add(resourcegroup.Data);
                        resourceGroupsResource.Add(resourcegroup);
					}
				}
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
                var apps = resourceGroupsResource.Where(x => x.Data.Name.Contains(resourceName)).First().GetGenericResources();
                //var x = projects.ToList();

                // Output project names
                //Console.WriteLine("Resourcegroup in the subscription:");
                foreach (var resource in apps)
                {


                    var resourcename = resource.Data.Name;
                    var resourcetype = "";
                    //Console.WriteLine($"- {resource.Data.Name}");

                    //resourceTypes.Add(resource.Data.ResourceType);
                    if (resource.Data.ResourceType == "Microsoft.Sql/servers/databases") resourcetype = "Azure Cloud SQL Database";
                    if (resource.Data.ResourceType == "Microsoft.Sql/servers") resourcetype = "Azure Cloud SQL Server";
                    if (resource.Data.ResourceType == "Microsoft.Web/sites") resourcetype = "Azure Cloud App Service";
                    if (resource.Data.ResourceType == "Microsoft.DocumentDB/mongoClusters") resourcetype = "Azure Cloud Cosmos MongoDB Database";
                    if (resource.Data.ResourceType == "Microsoft.Web/serverFarms") resourcetype = "Azure Cloud App Service Plan";
                    if (resource.Data.ResourceType == "Microsoft.Storage/storageAccounts") resourcetype = "Azure Cloud Storage Account";
                    if (resource.Data.ResourceType == "microsoft.insights/components") resourcetype = "Azure Cloud App Insights";
                    if (resource.Data.ResourceType == "microsoft.insights/actiongroups") resourcetype = "Azure Cloud App Insights Smart Detection";
                    if (resource.Data.ResourceType == "Microsoft.Web/connections") resourcetype = "Azure Cloud Task Connection";
                    if (resource.Data.ResourceType == "Microsoft.Logic/workflows") resourcetype = "Azure Cloud Storage Account Task";

                    resourceTypes.Add(resourcetype);
                    resourceNames.Add(resourcename);

                    var res = new AzureResource();
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

        private async Task GetDevopsResources(string projName)
        {
            var gitClient = azureDevopsOrganization.GetClient<GitHttpClient>();
            var pipelineClient = azureDevopsOrganization.GetClient<BuildHttpClient>();

            // List Git Repositories in the project
            //Console.WriteLine($"Listing Repositories for project: {projectsReference.First().Name}");
            var repositories = await gitClient.GetRepositoriesAsync(projectsReference.Where(x => x.Name.Contains(projName)).First().Id);
            foreach (var repo in repositories)
            {
                //Console.WriteLine($"Repository Name: {repo.Name}, Repository ID: {repo.Id}");
                resourceNames.Add(repo.Name);
                resourceTypes.Add("Azure DevOps Repository");
                var res = new AzureResource();
                res.Name = repo.Name;
                res.Type = "Azure DevOps Repository";
                resources.Add(res);
            }

            // List Build Pipelines in the project
            //Console.WriteLine($"\nListing Pipelines for project: {projectsReference.First().Name}");
            var pipelines = await pipelineClient.GetDefinitionsAsync(projectsReference.Where(x => x.Name.Contains(projName)).First().Id);
            foreach (var pipeline in pipelines)
            {
                //Console.WriteLine($"Pipeline Name: {pipeline.Name}, Pipeline ID: {pipeline.Id}");
                resourceNames.Add(pipeline.Name);
                resourceTypes.Add("Azure DevOps Build Pipeline");
                //resourceTypes.Add(pipeline.Type.ToString());
                var res = new AzureResource();
                res.Name = pipeline.Name;
                res.Type = "Azure DevOps Build Pipeline";
                resources.Add(res);
            }

            // VARIABLE GROUP
            // Azure DevOps organization and project (replace with your values)
            string orgName = organizationName;
            string projectName = projectsReference.Where(x => x.Name.Contains(projName)).First().Name;
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
                    resourceTypes.Add("Azure DevOps Variable Group");
                    var res = new AzureResource();
                    res.Name = variableGroup.name.ToString();
                    res.Type = "Azure DevOps Variable Group";
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
                    resourceTypes.Add("Azure DevOps Deploy Release");
                    var res = new AzureResource();
                    res.Name = releasePipeline.name.ToString();
                    res.Type = "Azure DevOps Deploy Release";
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
