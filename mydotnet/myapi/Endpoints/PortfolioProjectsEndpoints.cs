using Microsoft.EntityFrameworkCore;
using myapi.Data;
using myshared.Models;
using myshared.DTOs;
using myapi.Services;

namespace myapi.Endpoints // minimal apis
{
	public static class PortfolioProjectsEndpoints
	{
		public static void MapPortfolioProjectsEndpoints(this WebApplication app)
		{
			var group = app.MapGroup("api/portfolioprojects");
			group.MapGet("/", GetAllPortfolioProjects);
			group.MapGet("/{id}", GetPortfolioProject);
			group.MapPost("/", CreatePortfolioProject);
			group.MapPut("/{id}", UpdatePortfolioProject);
			group.MapDelete("/{id}", DeletePortfolioProject);
		}

		static async Task<IResult> GetAllPortfolioProjects(IPortfolioService portfolioService)
		{
			return TypedResults.Ok(await portfolioService.GetAllProjectsAsync());
		}

		static async Task<IResult> GetPortfolioProject(int id, IPortfolioService portfolioService)
		{
			return await portfolioService.GetProjectByIdAsync(id)
				is PortfolioProjectDTO portfolioProjectDTO
					? TypedResults.Ok(portfolioProjectDTO)
					: TypedResults.NotFound();
		}

		static async Task<IResult> CreatePortfolioProject(PortfolioProjectDTO portfolioProjectDTO, IPortfolioService portfolioService)
		{
			/*var portfolioProjectDTO = new PortfolioProjectDTO
			{
				Title = portfolioProjectDTO.Title,
				Description = portfolioProjectDTO.Description
			};*/

			await portfolioService.AddProjectAsync(portfolioProjectDTO);

			//portfolioProjectDTO = new PortfolioProjectDTO(portfolioProject);

			return TypedResults.Created($"/portfolioProjects/{portfolioProjectDTO.Id}", portfolioProjectDTO);
		}

		static async Task<IResult> UpdatePortfolioProject(int id, PortfolioProjectDTO updatedPortfolioProjectDTO, IPortfolioService portfolioService)
		{
			var portfolioProjectDTO = await portfolioService.GetProjectByIdAsync(id);

			if (portfolioProjectDTO is null) return TypedResults.NotFound();

			await portfolioService.UpdateProjectAsync(updatedPortfolioProjectDTO, id);

			return TypedResults.NoContent();
		}

		static async Task<IResult> DeletePortfolioProject(int id, IPortfolioService portfolioService)
		{
			if (await portfolioService.GetProjectByIdAsync(id) is PortfolioProjectDTO)
			{
				await portfolioService.DeleteProjectAsync(id);
				return TypedResults.NoContent();
			}

			return TypedResults.NotFound();
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
