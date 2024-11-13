using Microsoft.AspNetCore.Components;
using myshared.DTOs;
using myshared.Services;
using Newtonsoft.Json;
using System.Net.NetworkInformation;
using static myshared.Services.AzureService;

namespace myblazor.Components.Pages
{
	public partial class ResourceOverview
	{
		// [Inject]
		// public AzureService AzureService { get; set; }
		[Inject]
		public EnvironmentVariableService EnvironmentVariableService { get; set; }

		HttpClient httpClient = new HttpClient();

		public List<Resourcex> listOfResources = new();

		//private HttpResponseMessage response = new();

		protected override async Task OnInitializedAsync()
		{
			//var listOfResources = AzureService.GetResourcesList();
			var APIURL = EnvironmentVariableService.GetEnvironmentVariable("MyAppSettings:APIURL");

			try
			{
				var response = await httpClient.GetAsync(APIURL + "api/ExampleModel/GetResources");
				listOfResources = JsonConvert.DeserializeObject<List<Resourcex>>(await response.Content.ReadAsStringAsync()) ?? new List<Resourcex>();
			}
			catch (Exception ex)
			{

			}
			httpClient.Dispose();
		}
	}
}
