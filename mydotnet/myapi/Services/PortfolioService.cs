using Microsoft.EntityFrameworkCore;
using myapi.Data;
using myshared.DTOs;
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

		public async Task AddProjectAsync(PortfolioProjectDTO projectDTO)
		{
			// service
			var project = new PortfolioProject(projectDTO);

			// repo
			_context.Add(project);
			await _context.SaveChangesAsync();
		}

		public async Task DeleteProjectAsync(int id)
		{
			// service
			var project = await _context.PortfolioProjects.FindAsync(id);
			if(project != null)
			{
				// repo
				_context.PortfolioProjects.Remove(project);
				await _context.SaveChangesAsync();
			}
		}

		public async Task<List<PortfolioProjectDTO>> GetAllProjectsAsync()
		{
			var projects = await _context.PortfolioProjects.ToListAsync();
			
			List<PortfolioProjectDTO> projectDTOS = new List<PortfolioProjectDTO>();
			foreach (var project in projects)
			{
				projectDTOS.Add(new PortfolioProjectDTO(project));
			}

			return projectDTOS;
		}

		public async Task<PortfolioProjectDTO> GetProjectByIdAsync(int id)
		{
			var project = await _context.PortfolioProjects.FindAsync(id);
			var projectDto = new PortfolioProjectDTO(project);
			return projectDto;
		}

		public async Task UpdateProjectAsync(PortfolioProjectDTO projectDTO, int id)
		{
			// service
			var dbProject = await _context.PortfolioProjects.FindAsync(id);
			var updatedDbProject = new PortfolioProject(projectDTO);
			if (dbProject != null)
			{
				// repo
				dbProject.Title = updatedDbProject.Title;
				dbProject.Description = updatedDbProject.Description;
				//dbProject.WebUrl = projectDTO.WebUrl;

				await _context.SaveChangesAsync();
			}
		}
	}
}
