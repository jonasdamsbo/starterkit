using Microsoft.AspNetCore.Components;
using myshared.DTOs;
using myshared.Models;
using myshared.Services;
using Newtonsoft.Json;
using System.Net.NetworkInformation;
using static myshared.Models.AzureResource;

namespace myblazor.Components.Pages
{
	public partial class ResourceOverview
	{
		// [Inject]
		// public AzureUtility AzureUtility { get; set; }
		[Inject]
		public EnvironmentVariableService EnvironmentVariableService { get; set; }

		HttpClient httpClient = new HttpClient();

		public List<AzureResource> listOfResources = new();

		//private HttpResponseMessage response = new();

		protected override async Task OnInitializedAsync()
		{
			//var listOfResources = AzureUtility.GetResourcesList();
			var APIURL = EnvironmentVariableService.GetEnvironmentVariable("MyAppSettings:APIURL");

			try
			{
				var response = await httpClient.GetAsync(APIURL + "api/ExampleModel/GetResources");
				listOfResources = JsonConvert.DeserializeObject<List<AzureResource>>(await response.Content.ReadAsStringAsync()) ?? new List<AzureResource>();
			}
			catch (Exception ex)
			{

			}
			httpClient.Dispose();
		}
	}
}
