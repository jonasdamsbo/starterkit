using Microsoft.EntityFrameworkCore;
using myapi.Data;
using myshared.Models;
using myshared.DTOs;
using myapi.Repositories;
using myapi.Services;
using Microsoft.IdentityModel.Tokens;

namespace myapi.Endpoints // minimal apis
{
	public static class ExampleModelEndpoints
	{
		public static void MapExampleModelEndpoints(this WebApplication app)
		{
			var group = app.MapGroup("api/ExampleModel");
			group.MapGet("/", GetAllAsync);
			group.MapGet("/ExampleNavigationProperty", GetAllNavPropsAsync);
			group.MapGet("/{id}", GetByIdAsync);
			group.MapPost("/", AddAsync);
			group.MapPut("/{id}", UpdateAsync);
			group.MapDelete("/{id}", DeleteAsync);
		}

		static async Task<IResult> GetAllAsync(ExampleService exampleService)
		{
			var examples = await exampleService.GetAllAsync();

			if (examples == new List<ExampleDTO>()) return TypedResults.NotFound();
			if (examples is null) return TypedResults.BadRequest();

			return TypedResults.Ok(examples);
		}

		static async Task<IResult> GetAllNavPropsAsync(ExampleNavPropService exampleNavPropService)
		{
			var examples = await exampleNavPropService.GetAllAsync();

			if (examples == new List<ExampleNavigationProperty>()) return TypedResults.NotFound();
			if (examples is null) return TypedResults.BadRequest();

			return TypedResults.Ok(examples);
		}

		static async Task<IResult> GetByIdAsync(string id, ExampleService exampleService)
		{
			var example = await exampleService.GetByIdAsync(id);

			if (example == new ExampleDTO()) return TypedResults.NotFound();
			if (example is null) return TypedResults.BadRequest();

			return TypedResults.Ok(example);
		}

		static async Task<IResult> AddAsync(ExampleDTO exampleDTO, ExampleService exampleService)
		{
			var example = await exampleService.AddAsync(exampleDTO);

			if (example == new ExampleDTO()) return TypedResults.NotFound();
			if (example is null) return TypedResults.BadRequest();

			return TypedResults.Created($"/ExampleModel/{exampleDTO.Id}", exampleDTO);
		}

		static async Task<IResult> UpdateAsync(string id, ExampleDTO updatedExampleDTO, ExampleService exampleService)
		{
			var example = await exampleService.UpdateAsync(id, updatedExampleDTO);

			if (example == new ExampleDTO()) return TypedResults.NotFound();
			if (example is null) return TypedResults.BadRequest();

			return TypedResults.NoContent();
		}

		static async Task<IResult> DeleteAsync(string id, ExampleService exampleService)
		{
			var example = await exampleService.DeleteAsync(id);

			if (example == new ExampleDTO()) return TypedResults.NotFound();
			if (example is null) return TypedResults.BadRequest();

			return TypedResults.NoContent();
		}


		/*public static void MapPortfolioProjectsEndpoints(this WebApplication app)
		{
			var route = "api/portfolioProjects";

			app.MapGet(route, async (DataContext db) =>
			{
				await db.PortfolioProjects.ToListAsync();
			});

			app.MapGet(route + "/{id}", async (int id, DataContext db) =>
			{
				await db.PortfolioProjects.FindAsync(id) is PortfolioProject portfolioProject ? Results.Ok(portfolioProject) : Results.NotFound();
			});

			app.MapPost("/todoitems", async (PortfolioProject portfolioProject, DataContext db) =>
			{
				db.PortfolioProjects.Add(portfolioProject);
				await db.SaveChangesAsync();

				return Results.Created($"/todoitems/{portfolioProject.Id}", portfolioProject);
			});

			app.MapPut("/todoitems/{id}", async (int id, Todo inputTodo, DataContext db) =>
			{
				var todo = await db.Todos.FindAsync(id);

				if (todo is null) return Results.NotFound();

				todo.Name = inputTodo.Name;
				todo.IsComplete = inputTodo.IsComplete;

				await db.SaveChangesAsync();

				return Results.NoContent();
			});

			app.MapDelete("/todoitems/{id}", async (int id, DataContext db) =>
			{
				if (await db.Todos.FindAsync(id) is Todo todo)
				{
					db.Todos.Remove(todo);
					await db.SaveChangesAsync();
					return Results.NoContent();
				}

				return Results.NotFound();
			});

		}*/
	}
}
