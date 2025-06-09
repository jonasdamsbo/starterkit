using Microsoft.AspNetCore.Components;
using Monolith.Logic.DTOs;
using Monolith.Logic.Services;
using Newtonsoft.Json;

namespace Monolith.Route.UI.Pages
{
	public partial class ExampleOverview
	{
		// frontend dependency injection

		// dotnet 8

		[Inject]
		public NavigationManager NavigationManager { get; set; }
		[Inject]
		public EnvironmentVariableService EnvironmentVariableService { get; set; }
		[Inject]
		public ExampleModelService ExampleModelService { get; set; }


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

		// methods
		//protected override async Task OnInitializedAsync()
		protected override async Task OnAfterRenderAsync(bool firstRender)
		{
			if (firstRender)
			{

				// use this to use inmemory examples until syncing with db examples 1/2
				examples = EnvironmentVariableService.Examples;

				//controlllers
				try
				{
					// use this instead to use inmemory examples until syncing with db examples 2/2
					var newExamples = await ExampleModelService.GetAllAsync();
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

				StateHasChanged();
			}
		}

		void EditExample(string id)
		{
			NavigationManager.NavigateTo($"/edit-example/{id}");
		}

		async Task DeleteExample(string id)
		{
			await ExampleModelService.DeleteAsync(id);

			// workaround because deleting does not update projects, so it loads forever
			var allExamples = await ExampleModelService.GetAllAsync();
			EnvironmentVariableService.Examples = allExamples;
			examples = allExamples;
			StateHasChanged();
		}

		void AddExample()
		{
			NavigationManager.NavigateTo($"/edit-example");
		}
	}
}
