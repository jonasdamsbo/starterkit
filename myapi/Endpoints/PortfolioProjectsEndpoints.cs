using Microsoft.EntityFrameworkCore;
using myapi.Data;
using myshared.Models;
using myshared.DTOs;

namespace myapi.Endpoints // minimal apis
{
	public static class PortfolioProjectsEndpoints
	{
		public static RouteGroupBuilder MapPortfolioProjectsEndpoints(this RouteGroupBuilder group)
		{
			// route =  "/portfolioprojects"
			group.MapGet("/", GetAllPortfolioProjects);
			group.MapGet("/{id}", GetPortfolioProject);
			group.MapPost("/", CreatePortfolioProject);
			group.MapPut("/{id}", UpdatePortfolioProject);
			group.MapDelete("/{id}", DeletePortfolioProject);

			return group;
		}

		static async Task<IResult> GetAllPortfolioProjects(DataContext db)
		{
			return TypedResults.Ok(await db.PortfolioProjects.Select(x => new PortfolioProjectDTO(x)).ToArrayAsync());
		}

		static async Task<IResult> GetPortfolioProject(int id, DataContext db)
		{
			return await db.PortfolioProjects.FindAsync(id)
				is PortfolioProject portfolioProject
					? TypedResults.Ok(new PortfolioProjectDTO(portfolioProject))
					: TypedResults.NotFound();
		}

		static async Task<IResult> CreatePortfolioProject(PortfolioProjectDTO portfolioProjectDTO, DataContext db)
		{
			var portfolioProject = new PortfolioProject
			{
				Title = portfolioProjectDTO.Title,
				Description = portfolioProjectDTO.Description
			};

			db.PortfolioProjects.Add(portfolioProject);
			await db.SaveChangesAsync();

			portfolioProjectDTO = new PortfolioProjectDTO(portfolioProject);

			return TypedResults.Created($"/portfolioProjects/{portfolioProject.Id}", portfolioProjectDTO);
		}

		static async Task<IResult> UpdatePortfolioProject(int id, PortfolioProjectDTO portfolioProjectDTO, DataContext db)
		{
			var portfolioProject = await db.PortfolioProjects.FindAsync(id);

			if (portfolioProject is null) return TypedResults.NotFound();

			portfolioProject.Title = portfolioProjectDTO.Title;
			portfolioProject.Description = portfolioProjectDTO.Description;

			await db.SaveChangesAsync();

			return TypedResults.NoContent();
		}

		static async Task<IResult> DeletePortfolioProject(int id, DataContext db)
		{
			if (await db.PortfolioProjects.FindAsync(id) is PortfolioProject portfolioProject)
			{
				db.PortfolioProjects.Remove(portfolioProject);
				await db.SaveChangesAsync();
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
