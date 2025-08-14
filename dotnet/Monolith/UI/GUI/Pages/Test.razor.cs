using Microsoft.AspNetCore.Components; // for blazor server
									   //using System.Net.Http.Json; // for api call
using Monolith.Logic.Services;
using Monolith.Logic.DTOs;
using System.Net.Http.Headers;

namespace Monolith.UI.GUI.Pages
{
	public partial class Test
	{
		[Inject]
		public TestDtoService TestService { get; set; }

		public TestDto? TestDto { get; set; }

		protected override async Task OnAfterRenderAsync(bool firstRender)
		{
			if (firstRender)
			{
				// if you want to land initially and use loading, controller should not make first call then
				TestDto = await GetInit();
				TestDto.Title = "SomeTitle";
                StateHasChanged();
			}
		}
		
		private async Task<List<string>> RemoveListString(string str)
		{
			TestDto.clickedString = str;

			// http requests only works when seperate apps, not monolith, and is redundant when using blazor server monolith
			//HttpResponseMessage response = new();
			//HttpClient httpClient = new HttpClient();
			//response = await httpClient.PostAsJsonAsync("http://localhost:5194" + "/api/test", TestDto);
			//var newDto = await response.Content.ReadFromJsonAsync<TestDto>() ?? new TestDto();

			var newDto = await TestService.GetStuff(TestDto);

			var listString = newDto.StringList;

			return listString;
		}

		private async Task<TestDto> GetInit()
		{
			// http requests only works when seperate apps, not monolith, and is redundant when using blazor server monolith
			//HttpResponseMessage response = new();
			//HttpClient httpClient = new HttpClient();
			//httpClient.DefaultRequestHeaders.Accept.Add(
			//	new MediaTypeWithQualityHeaderValue("application/json"));
			//response = await httpClient.GetAsync("http://localhost:5194" + "/api/test/init");
			//var content = await response.Content.ReadAsStringAsync();
			//var newDto = await response.Content.ReadFromJsonAsync<TestDto>() ?? new TestDto();

			var newDto = await TestService.GetInitialStuff();

			return newDto;
		}


		private void SetClass(string id)
		{
			var x = TestDto.elementStyles.TryGetValue(id, out var q);
			if (x && q.Contains("red"))
			{
				TestDto.elementStyles.Remove(id);
				TestDto.elementStyles.Add(id, "blue");
			}
			else if (x && q.Contains("blue"))
			{
				TestDto.elementStyles.Remove(id);
				TestDto.elementStyles.Add(id, "red");
			}
			else
			{
				TestDto.elementStyles.Add(id, "red");
			}
		}
		private async void Click(string str)
		{
			TestDto.Title = "Waiting for response...";
			//StateHasChanged();

			TestDto.StringList = await RemoveListString(str);
			//StateHasChanged();

			TestDto.Title = "SomeTitle";
			StateHasChanged();
		}
		private async void Increment()
		{
			TestDto.Counter++;
			StateHasChanged();
		}

		private async void Swap1(string str)
		{
			TestDto.list1.Remove(str);
			TestDto.list2.Add(str);
			StateHasChanged();
		}
		private async void Swap2(string str)
		{
			TestDto.list2.Remove(str);
			TestDto.list1.Add(str);
			StateHasChanged();
		}
	}
}
