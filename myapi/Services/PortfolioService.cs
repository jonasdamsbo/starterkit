using Microsoft.EntityFrameworkCore;
using myapi.Data;
using myshared.Models;

namespace myapi.Services
{
	public class PortfolioService : IPortfolioService
	{
		private readonly DataContext _context;

		public PortfolioService(DataContext context)
		{
			_context = context;
		}

		public async Task AddProjectAsync(PortfolioProject project)
		{
			_context.Add(project);
			await _context.SaveChangesAsync();
		}

		public async Task DeleteProjectAsync(int id)
		{
			var project = await _context.PortfolioProjects.FindAsync(id);
			if(project != null)
			{
				_context.PortfolioProjects.Remove(project);
				await _context.SaveChangesAsync();
			}
		}

		public async Task<List<PortfolioProject>> GetAllProjectsAsync()
		{
			var projects = await _context.PortfolioProjects.ToListAsync();
			return projects;
		}

		public async Task<PortfolioProject> GetProjectByIdAsync(int id)
		{
			var project = await _context.PortfolioProjects.FindAsync(id);
			return project;
		}

		public async Task UpdateProjectAsync(PortfolioProject project, int id)
		{
			var dbProject = await _context.PortfolioProjects.FindAsync(id);
			if (dbProject != null)
			{
				dbProject.Title = project.Title;
				dbProject.Description = project.Description;
				dbProject.WebUrl = project.WebUrl;

				await _context.SaveChangesAsync();
			}
		}
	}
}
