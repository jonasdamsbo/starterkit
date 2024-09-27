using Microsoft.AspNetCore.Components;
using myshared.DTOs;
using myshared.Services;
using Newtonsoft.Json;

namespace myblazor.Components.Pages
{
	public partial class ExampleOverview
	{
		// dependencies

		// dotnet 8

		[Inject]
		public NavigationManager NavigationManager { get; set; }
		[Inject]
		public EnvironmentVariableService EnvironmentVariableService { get; set; }


		// dotnet 9
		//private readonly NavigationManager NavigationManager;
		//private readonly EnvironmentVariableService EnvironmentVariableService;

		//public PortfolioOverview(
		//	NavigationManager navigationManager,
		//	EnvironmentVariableService environmentVariableService)
		//{
		//	NavigationManager = navigationManager;
		//	EnvironmentVariableService = environmentVariableService;
		//}

		// properties
		List<ExampleDTO> examples = new List<ExampleDTO>();
		private HttpResponseMessage response = new();

		// methods
		protected override async Task OnInitializedAsync()
		{
			/*await Task.Delay(500);
			projects = await PortfolioService.GetAllProjectsAsync();*/

			//controlllers
			var APIURL = EnvironmentVariableService.GetApiUrl();
			HttpClient httpClient = new HttpClient();
			response = await httpClient.GetAsync(APIURL + "api/ExampleModel");
			examples = JsonConvert.DeserializeObject<List<ExampleDTO>>(await response.Content.ReadAsStringAsync()) ?? new List<ExampleDTO>();
			httpClient.Dispose();

			//minimal api
			/*var APIURL = EnvironmentVariableService.GetApiUrl();
			HttpClient httpClient = new HttpClient();
			response = await httpClient.GetAsync(APIURL + "PortfolioProjects");
			projects = JsonConvert.DeserializeObject<List<PortfolioProjectDTO>>(await response.Content.ReadAsStringAsync()) ?? new List<PortfolioProjectDTO>();
			httpClient.Dispose();*/
		}

		void EditExample(int id)
		{
			NavigationManager.NavigateTo($"/edit-example/{id}");
		}

		async Task DeleteExample(int id)
		{
			/*await PortfolioService.DeleteProjectAsync(id);
			projects = await PortfolioService.GetAllProjectsAsync(); */

			var APIURL = EnvironmentVariableService.GetApiUrl();
			HttpClient httpClient = new HttpClient();
			await httpClient.DeleteAsync(APIURL + "api/ExampleModel/" + id);
			//response = await httpClient.DeleteAsync(APIURL + "api/PortfolioProjects/" + id);
			//projects = JsonConvert.DeserializeObject<List<PortfolioProjectDTO>>(await response.Content.ReadAsStringAsync()) ?? new List<PortfolioProjectDTO>();
			//httpClient.Dispose();

			// workaround because deleting does not update projects, so it loads forever
			response = await httpClient.GetAsync(APIURL + "api/ExampleModel");
			examples = JsonConvert.DeserializeObject<List<ExampleDTO>>(await response.Content.ReadAsStringAsync()) ?? new List<ExampleDTO>();
			//NavigationManager.NavigateTo("/portfolio");
			httpClient.Dispose();
		}

		void AddExample()
		{
			NavigationManager.NavigateTo($"/edit-example");
		}
	}
}
