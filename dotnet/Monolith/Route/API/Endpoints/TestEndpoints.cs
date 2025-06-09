//using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Monolith.Logic.API.DTOs;
using Monolith.Logic.API.Services;

namespace Monolith.Route.API.Endpoints
{
	public static class TestEndpoints
	{
		public static void MapTestEndpoints(this WebApplication app)
		{
			var group = app.MapGroup("api/test");

			group.MapPost("/", Remove);
			static async Task<IResult> Remove(TestDto testDto, TestDtoFactory testService)
			{
				var newDto = await testService.GetStuff(testDto);

				return TypedResults.Ok(newDto);
			}
			group.MapGet("/init", Init);
			static async Task<IResult> Init(TestDtoFactory testService)
			{
				var newDto = await testService.GetInitialStuff();

				return TypedResults.Ok(newDto);
			}
		}
	}
}
