using Microsoft.AspNetCore.Components;
using Monolith.Logic.DTOs;
using Monolith.Logic.Enums;
using Monolith.Logic.Services;
using Newtonsoft.Json;

namespace Monolith.UI.GUI.Pages
{
	partial class SinglePageCrud
	{
		// frontend dependency injection

		// dotnet 8

		[Inject]
		NavigationManager NavigationManager { get; set; }
		[Inject]
		EnvironmentVariableService EnvironmentVariableService { get; set; }
		[Inject]
		ExampleModelService ExampleModelService { get; set; }


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

		CrudState state = CrudState.Loading;

		//public ExampleDTO CurrentExample { get; set; } = new();
		ExampleDTO CurrentExampleDTO { get; set; } = new();

		//[Parameter]
		string? Id { get; set; }

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
					if (newExamples?.Any() == false && examples.Any() == false) isEqual = true;
					else if (newExamples?.Any() == true && examples.Any() == false) isEqual = false;
					else if ((newExamples?.Any() == false && examples.Any() == true)) isEqual = false;
					else if (newExamples?.Count != examples.Count) isEqual = false;
					else if (newExamples?.Count == examples.Count)
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

				state = CrudState.Loaded;
				StateHasChanged();
			}

			//if(state == "reload")
			//{
			//	var newExamples = await ExampleModelService.GetAllAsync();
			//	if(newExamples is not null)
			//	{
			//		examples = newExamples;
			//	}

			//	state = "loaded";
			//	StateHasChanged();
			//}
		}

		async Task EditExample(string id)
		{
			state = CrudState.Edit;
			Id = id;
			if (Id is not null)
			{
				var example = await ExampleModelService.GetByIdAsync(Id);

				if (example is not null)
				{
					CurrentExampleDTO = example;
				}
			}
			StateHasChanged();
			//NavigationManager.NavigateTo($"/edit-example/{id}");
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
			state = CrudState.Add;
			if(CurrentExampleDTO.Id is not null)
			{
				CurrentExampleDTO.Id = null;
				CurrentExampleDTO.Title = null;
				CurrentExampleDTO.Description = null;
				CurrentExampleDTO.ExampleNavigationProperties = null;
			}
			Id = null;
			StateHasChanged();
			//NavigationManager.NavigateTo($"/edit-example");
		}

		async Task HandleSubmitAdd()
		{
			CurrentExampleDTO.Id = "0";
			await ExampleModelService.AddAsync(CurrentExampleDTO);
			await Reload();
		}
		async Task HandleSubmitEdit()
		{
			await ExampleModelService.UpdateAsync(Id, CurrentExampleDTO);
			await Reload();
		}
		//async Task HandleSubmit()
		//{
		//	if (Id is not null)
		//	{
		//		await ExampleModelService.UpdateAsync(Id, CurrentExampleDTO);
		//		await Reload();
		//		//state = "reload";
		//		//StateHasChanged();
		//		//NavigationManager.NavigateTo("/single");
		//	}
		//	else
		//	{
		//		CurrentExampleDTO.Id = "0";
		//		await ExampleModelService.AddAsync(CurrentExampleDTO);
		//		await Reload();
		//		//state = "reload";
		//		//StateHasChanged();

		//		//NavigationManager.NavigateTo("/single");
		//	}
		//}

		async Task Reload()
		{
			state = CrudState.Loading;
			StateHasChanged();

			var newExamples = await ExampleModelService.GetAllAsync();
			if (newExamples is not null)
			{
				examples = newExamples;
			}

			state = CrudState.Loaded;
			StateHasChanged();
		}
	}
}
