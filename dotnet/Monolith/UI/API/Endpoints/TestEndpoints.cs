//using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Monolith.Logic.DTOs;
using Monolith.Logic.Services;
using Microsoft.AspNetCore.Mvc;

namespace Monolith.UI.API.Endpoints
{
	public static class TestEndpoints
	{
		public static void MapTestEndpoints(this WebApplication app)
		{
			var group = app.MapGroup("api/test");

			group.MapPost("/", Remove);
			static async Task<IResult> Remove(TestDto testDto, TestDtoService testService)
			{
				var newDto = await testService.GetStuff(testDto);

				return TypedResults.Ok(newDto);
			}
			group.MapGet("/init", Init);
			static async Task<IResult> Init(TestDtoService testService)
			{
				var newDto = await testService.GetInitialStuff();

				return TypedResults.Ok(newDto);
			}
			group.MapGet("/icalfile", () =>
			{
				var ical = ICalBuilder.CreateICalEvent(
					uid: Guid.NewGuid().ToString(),
					summary: "Team Meeting",
					description: "Discuss project updates and milestones.",
					start: DateTime.UtcNow.AddHours(1),
					end: DateTime.UtcNow.AddHours(2),
					location: "Conference Room A"
				);

				var bytes = System.Text.Encoding.UTF8.GetBytes(ical);
				return Results.File(
					bytes,
					"text/calendar",
					"meeting.ics"
				);
			});
			group.MapGet("/icalnetfile", ([FromServices] CalendarService calendarService) =>
			{
				var ical = calendarService.CreateSimpleEvent(
					title: "Team Meeting",
					description: "Discuss project updates and milestones.",
					location: "Conference Room A",
					start: DateTime.UtcNow.AddHours(1),
					end: DateTime.UtcNow.AddHours(2)
				);

				var bytes = System.Text.Encoding.UTF8.GetBytes(ical);
				return Results.File(bytes, "text/calendar; charset=utf-8", "meeting.ics");
			});
		}
	}
}
