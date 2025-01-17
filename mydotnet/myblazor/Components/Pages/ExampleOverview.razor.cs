﻿using Microsoft.AspNetCore.Components;
using myshared.DTOs;
using myshared.Services;
using Newtonsoft.Json;

namespace myblazor.Components.Pages
{
	public partial class ExampleOverview
	{
		// frontend dependency injection

		// dotnet 8

		[Inject]
		public NavigationManager NavigationManager { get; set; }
		[Inject]
		public EnvironmentVariableService EnvironmentVariableService { get; set; }


		// dotnet 9

		//private readonly NavigationManager NavigationManager;
		//private readonly EnvironmentVariableService EnvironmentVariableService;

		//public ExampleOverview(
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
			// use this to use inmemory examples until syncing with db examples 1/2
			examples = EnvironmentVariableService.Examples;

			//controlllers
			var APIURL = EnvironmentVariableService.GetEnvironmentVariable("MyAppSettings:APIURL");
			HttpClient httpClient = new HttpClient();
			response = await httpClient.GetAsync(APIURL + "api/ExampleModel");
			try
			{
				// use this instead to use inmemory examples until syncing with db examples 2/2
				var newExamples = JsonConvert.DeserializeObject<List<ExampleDTO>>(await response.Content.ReadAsStringAsync()) ?? new List<ExampleDTO>();
				var isEqual = true;
				if (newExamples.Any() == false && examples.Any() == false) isEqual = true;
				else if (newExamples.Any() == true && examples.Any() == false) isEqual = false;
				else if ((newExamples.Any() == false && examples.Any() == true)) isEqual = false;
				else if (newExamples.Count != examples.Count) isEqual = false;
				else if (newExamples.Count == examples.Count)
				{
					for (int i = 0; i < newExamples.Count; i++)
					{
						if (newExamples[i].Id != examples[i].Id 
							|| newExamples[i].Title != examples[i].Title 
							|| newExamples[i].Description != examples[i].Description)
						{
							isEqual = false;
						}
					}
				}
				if (!isEqual)
				{
					EnvironmentVariableService.Examples = newExamples;
					examples = newExamples;
				}
			}
			catch (Exception ex)
			{

				throw;
			}
			httpClient.Dispose();
		}

		void EditExample(string id)
		{
			NavigationManager.NavigateTo($"/edit-example/{id}");
		}

		async Task DeleteExample(string id)
		{

			var APIURL = EnvironmentVariableService.GetEnvironmentVariable("MyAppSettings:APIURL");
			HttpClient httpClient = new HttpClient();
			await httpClient.DeleteAsync(APIURL + "api/ExampleModel/" + id);

			// workaround because deleting does not update projects, so it loads forever
			response = await httpClient.GetAsync(APIURL + "api/ExampleModel");
			examples = JsonConvert.DeserializeObject<List<ExampleDTO>>(await response.Content.ReadAsStringAsync()) ?? new List<ExampleDTO>();
			EnvironmentVariableService.Examples = examples;
			httpClient.Dispose();
		}

		void AddExample()
		{
			NavigationManager.NavigateTo($"/edit-example");
		}
	}
}
