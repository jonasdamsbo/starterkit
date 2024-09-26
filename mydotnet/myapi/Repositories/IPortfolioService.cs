using myshared.Models;
using myshared.DTOs;

namespace myapi.Repositories
{
	public interface IPortfolioRepository
	{
		Task<List<PortfolioProjectDTO>> GetAllProjectsAsync();
		Task<PortfolioProjectDTO> GetProjectByIdAsync(int id);
		Task AddProjectAsync(PortfolioProjectDTO projectDTO);
		Task UpdateProjectAsync(PortfolioProjectDTO projectDTO, int id);
		Task DeleteProjectAsync(int id);
	}
}
