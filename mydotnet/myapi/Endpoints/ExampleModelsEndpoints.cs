using Microsoft.EntityFrameworkCore;
using myapi.Data;
using myshared.Models;
using myshared.DTOs;
using myapi.Repositories;
using myapi.Services;
using Microsoft.IdentityModel.Tokens;

namespace myapi.Endpoints // minimal apis
{
	public static class ExampleModelsEndpoints
	{
		public static void MapExampleModelsEndpoints(this WebApplication app)
		{
			var group = app.MapGroup("api/examplemodels");
			group.MapGet("/", GetAllAsync);
			group.MapGet("/{id}", GetByIdAsync);
			group.MapPost("/", AddAsync);
			group.MapPut("/{id}", UpdateAsync);
			group.MapDelete("/{id}", DeleteAsync);
		}

		static async Task<IResult> GetAllAsync(ExampleService exampleService)
		{
			var examples = await exampleService.GetAllAsync();

			if (examples.IsNullOrEmpty())
			{
				return TypedResults.BadRequest();
			}

			return TypedResults.Ok(examples);

			//return TypedResults.Ok(await mssqlExampleRepository.GetAllProjectsAsync());
		}

		static async Task<IResult> GetByIdAsync(int id, ExampleService exampleService)
		{
			var example = await exampleService.GetByIdAsync(id);

			if (example == null)
			{
				return TypedResults.NotFound();
			}

			return TypedResults.Ok(example);

			//return example
			//	is ExampleDTO exampleDTO
			//		? TypedResults.Ok(exampleDTO)
			//		: TypedResults.NotFound();
		}

		static async Task<IResult> AddAsync(ExampleDTO exampleDTO, ExampleService exampleService)
		{
			/*var portfolioProjectDTO = new PortfolioProjectDTO
			{
				Title = portfolioProjectDTO.Title,
				Description = portfolioProjectDTO.Description
			};*/

			var example = await exampleService.AddAsync(exampleDTO);

			if (example == null)
			{
				return TypedResults.BadRequest();
			}

			//portfolioProjectDTO = new PortfolioProjectDTO(portfolioProject);

			return TypedResults.Created($"/portfolioProjects/{exampleDTO.Id}", exampleDTO);
		}

		static async Task<IResult> UpdateAsync(int id, ExampleDTO updatedExampleDTO, ExampleService exampleService)
		{
			var exampleDTO = await exampleService.GetByIdAsync(id);

			if (exampleDTO is null) return TypedResults.NotFound();

			await exampleService.UpdateAsync(id, updatedExampleDTO);

			return TypedResults.NoContent();
		}

		static async Task<IResult> DeleteAsync(int id, ExampleService exampleService)
		{
			//if (await exampleService.GetByIdAsync(id) is ExampleDTO)
			//{
			//	await exampleService.DeleteAsync(id);
			//	return TypedResults.NoContent();
			//}
			var example = await exampleService.GetByIdAsync(id);

			if (example == null)
			{
				return TypedResults.NotFound();
			}

			await exampleService.DeleteAsync(id);
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
